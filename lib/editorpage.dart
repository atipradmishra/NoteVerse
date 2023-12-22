import 'dart:async';
import 'dart:convert';
import 'dart:io' show File, Platform;
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:noteverse/database/chapter_curd.dart';
import 'package:noteverse/screens/homepage.dart';
import 'package:noteverse/widgets/custom_drawer.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../universal_ui/universal_ui.dart';
import '../widgets/time_stamp_embed_widget.dart';
import 'database/chaptermodel.dart';
import 'database/note_curd.dart';
import 'database/notemodel.dart';

enum _SelectionType {
  none,
  word,
  // line,
}

class EditorPage extends StatefulWidget {
  Note? notes;EditorPage({this.notes});
  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  bool _validate = false;
  late final QuillController _controller;
  late final Future<void> _loadDocumentFromAssetsFuture;
  final FocusNode _focusNode = FocusNode();
  Timer? _selectAllTimer;
  _SelectionType _selectionType = _SelectionType.none;
  TextEditingController _textController1 = TextEditingController();
  String? chapValue;

  List<Chapter> chapter = [];
  Chaptercurdmap _map = Chaptercurdmap();
  void selectallchapters() async {
    try {
      List<Chapter> data = await _map.selectall();
      chapter.clear();
      chapter.addAll(data);
      setState(() {});
    } catch (error) {
      print(error);
    }
  }

  void FormData() {
    if (widget.notes != null) {
      final doc = Document.fromJson(jsonDecode(widget.notes!.content!));
      _textController1.text = widget.notes!.title.toString();
      _controller = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
      chapValue = widget.notes!.ChapterId.toString();
      note = widget.notes!;
    }
  }

  @override
  void dispose() {
    _selectAllTimer?.cancel();
    // Dispose the controller to free resources
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    FormData();
    selectallchapters();
    super.initState();
    _loadDocumentFromAssetsFuture = _loadFromAssets();
  }

  Future<void> _loadFromAssets() async {
    try {
      final result = await rootBundle.loadString(isDesktop()
          ? ''
          : '');
      final doc = Document.fromJson(jsonDecode(widget.notes!.content!));
      _controller = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    } catch (error) {
      final doc = Document()..insert(0, '');
      _controller = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
  }

  Notecurdmap _tablemap = Notecurdmap();
  Note note = Note.empty();
  int? noteid;

  void addnote() async {
    final content = _controller.document.toDelta().toJson();
    try {
      note.title = _textController1.text;
      note.content = jsonEncode(content);
      if (chapValue == null){
        note.ChapterId = '1';
      } else {
        note.ChapterId = chapValue.toString();
      }
      Note data = await _tablemap.add(note);
      note.NoteId = note.NoteId;
      noteid = data.NoteId;

      setState(() {});
    } catch (error) {
      print(error);
    }
  }


  void save() {
    final content = _controller.document.toDelta().toJson();
    note.title = _textController1.text;
    note.content = jsonEncode(content);
    note.ChapterId = chapValue.toString();
    if (note.NoteId == null) {
      addnote();
      return;
    }
    else {
      updatenote();
    }
  }

  void updatenote() async {
    try {
      if (await _tablemap.update(note) ) {
        showmessage('Note updated');
        return;
      }
      showmessage('No Note changed');
    } catch (error) {
      print(error);
      showmessage('Error');
    }
  }

  void showmessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadDocumentFromAssetsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        return Scaffold(
          drawer: const CustomDrawer(),
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(44, 57, 74, 1),
            elevation: 0,
            centerTitle: false,
            title: const Text(
              'Note Verse',
            ),
            actions: [
              IconButton(
                onPressed: () => _insertTimeStamp(
                  _controller,
                  DateTime.now().toString(),
                ),
                icon: const Icon(Icons.add_alarm_rounded),
              ),
              IconButton(
                onPressed: () async {
                  setState(() {
                    _textController1.text.isEmpty ? _validate = true : _validate = false;
                  });
                  if(_validate == false){
                    save();
                    Navigator.pop(context);
                  }
                  },
                icon: const Icon(Icons.save_outlined),
              )
            ],
          ),
          body: Scaffold(body: _buildWelcomeEditor(context)),
        );
      },
    );
  }

  bool _onTripleClickSelection() {
    final controller = _controller;

    _selectAllTimer?.cancel();
    _selectAllTimer = null;

    // If you want to select all text after paragraph, uncomment this line
    // if (_selectionType == _SelectionType.line) {
    //   final selection = TextSelection(
    //     baseOffset: 0,
    //     extentOffset: controller.document.length,
    //   );

    //   controller.updateSelection(selection, ChangeSource.REMOTE);

    //   _selectionType = _SelectionType.none;

    //   return true;
    // }

    if (controller.selection.isCollapsed) {
      _selectionType = _SelectionType.none;
    }

    if (_selectionType == _SelectionType.none) {
      _selectionType = _SelectionType.word;
      _startTripleClickTimer();
      return false;
    }

    if (_selectionType == _SelectionType.word) {
      final child = controller.document.queryChild(
        controller.selection.baseOffset,
      );
      final offset = child.node?.documentOffset ?? 0;
      final length = child.node?.length ?? 0;

      final selection = TextSelection(
        baseOffset: offset,
        extentOffset: offset + length,
      );

      controller.updateSelection(selection, ChangeSource.REMOTE);

      // _selectionType = _SelectionType.line;

      _selectionType = _SelectionType.none;

      _startTripleClickTimer();

      return true;
    }

    return false;
  }

  void _startTripleClickTimer() {
    _selectAllTimer = Timer(const Duration(milliseconds: 900), () {
      _selectionType = _SelectionType.none;
    });
  }

  Widget get quillEditor {
    if (kIsWeb) {
      return QuillEditor(
        focusNode: _focusNode,
        scrollController: ScrollController(),
        configurations: QuillEditorConfigurations(
          placeholder: 'Add content',
          readOnly: false,
          scrollable: true,
          autoFocus: false,
          expands: false,
          padding: EdgeInsets.zero,
          onTapUp: (details, p1) {
            return _onTripleClickSelection();
          },
          customStyles: const DefaultStyles(
            h1: DefaultTextBlockStyle(
                TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  height: 1.15,
                  fontWeight: FontWeight.w300,
                ),
                VerticalSpacing(16, 0),
                VerticalSpacing(0, 0),
                null),
            sizeSmall: TextStyle(fontSize: 9),
          ),
          embedBuilders: [
            ...defaultEmbedBuildersWeb,
            TimeStampEmbedBuilderWidget()
          ],
        ),
      );
    }
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
            image: const AssetImage("assets/vector.png"),
            fit: BoxFit.cover,
            opacity: 0.2
          ),
        ),
      padding: EdgeInsets.all(5),
      child: QuillEditor(
        configurations: QuillEditorConfigurations(
          placeholder: 'Add Note',
          readOnly: false,
          autoFocus: false,
          enableSelectionToolbar: isMobile(),
          expands: false,
          padding: EdgeInsets.zero,
          onImagePaste: _onImagePaste,
          onTapUp: (details, p1) {
            return _onTripleClickSelection();
          },
          customStyles: const DefaultStyles(
            h1: DefaultTextBlockStyle(
                TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  height: 1.15,
                  fontWeight: FontWeight.w300,
                ),
                VerticalSpacing(16, 0),
                VerticalSpacing(0, 0),
                null),
            sizeSmall: TextStyle(fontSize: 9),
            subscript: TextStyle(
              fontFamily: 'SF-UI-Display',
              fontFeatures: [FontFeature.subscripts()],
            ),
            superscript: TextStyle(
              fontFamily: 'SF-UI-Display',
              fontFeatures: [FontFeature.superscripts()],
            ),
          ),
          embedBuilders: [
            ...FlutterQuillEmbeds.builders(),
            TimeStampEmbedBuilderWidget()
          ],
        ),
        scrollController: ScrollController(),
        focusNode: _focusNode,
      ),
    );
  }

  QuillToolbar get quillToolbar {
    if (kIsWeb) {
      return QuillToolbar(
        configurations: QuillToolbarConfigurations(
          embedButtons: FlutterQuillEmbeds.buttons(
            onImagePickCallback: _onImagePickCallback,
            webImagePickImpl: _webImagePickImpl,
          ),
          buttonOptions: QuillToolbarButtonOptions(
            base: QuillToolbarBaseButtonOptions(
              afterButtonPressed: _focusNode.requestFocus,
            ),
          ),
        ),
        // afterButtonPressed: _focusNode.requestFocus,
      );
    }
    if (_isDesktop()) {
      return QuillToolbar(
        configurations: QuillToolbarConfigurations(
          embedButtons: FlutterQuillEmbeds.buttons(
            onImagePickCallback: _onImagePickCallback,
            filePickImpl: openFileSystemPickerForDesktop,
          ),
          showAlignmentButtons: true,
          buttonOptions: QuillToolbarButtonOptions(
            base: QuillToolbarBaseButtonOptions(
              afterButtonPressed: _focusNode.requestFocus,
            ),
          ),
        ),
        // afterButtonPressed: _focusNode.requestFocus,
      );
    }
    return QuillToolbar(
      configurations: QuillToolbarConfigurations(
        embedButtons: FlutterQuillEmbeds.buttons(
          // provide a callback to enable picking images from device.
          // if omit, "image" button only allows adding images from url.
          // same goes for videos.
          onImagePickCallback: _onImagePickCallback,
          onVideoPickCallback: _onVideoPickCallback,
          // uncomment to provide a custom "pick from" dialog.
          // mediaPickSettingSelector: _selectMediaPickSetting,
          // uncomment to provide a custom "pick from" dialog.
          // cameraPickSettingSelector: _selectCameraPickSetting,
        ),
        showAlignmentButtons: true,
        buttonOptions: QuillToolbarButtonOptions(
          base: QuillToolbarBaseButtonOptions(
            afterButtonPressed: _focusNode.requestFocus,
          ),
        ),
      ),
      // afterButtonPressed: _focusNode.requestFocus,
    );
  }

  Widget _buildWelcomeEditor(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<String> chap = [];
    List<String> chapid = [];
    for (var a in chapter){
      var b = a.Name.toString();
      var c = a.ChapterId;
      chap.addAll([b]);
      chapid.addAll([c.toString()]);
    }
    // BUG in web!! should not releated to this pull request
    ///
    ///══╡ EXCEPTION CAUGHT BY WIDGETS LIBRARY ╞═════════════════════
    ///══════════════════════════════════════
    // The following bool object was thrown building MediaQuery
    //(MediaQueryData(size: Size(769.0, 1205.0),
    // devicePixelRatio: 1.0, textScaleFactor: 1.0, platformBrightness:
    //Brightness.dark, padding:
    // EdgeInsets.zero, viewPadding: EdgeInsets.zero, viewInsets:
    // EdgeInsets.zero,
    // systemGestureInsets:
    // EdgeInsets.zero, alwaysUse24HourFormat: false, accessibleNavigation:
    // false,
    // highContrast: false,
    // disableAnimations: false, invertColors: false, boldText: false,
    //navigationMode: traditional,
    // gestureSettings: DeviceGestureSettings(touchSlop: null), displayFeatures:
    // []
    // )):
    //   false
    // The relevant error-causing widget was:
    //   SafeArea
    ///
    ///
    return Container(
      child: QuillProvider(
        configurations: QuillConfigurations(
          controller: _controller,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: height/13,
                  padding: EdgeInsetsDirectional.fromSTEB(5, 0,5, 0),
                  child: TextFormField(
                    controller: _textController1,
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: "Give a Title to your note",
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      labelText: "Title",
                      border: InputBorder.none,
                        errorText: _validate ? "Title Can't Be Empty" : null,
                    ),
                  ),
                ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsetsDirectional.fromSTEB(20, 5,5, 5),
              height: height/15,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  menuMaxHeight: height/3,
                  hint: Text('Select Chapter'),
                  dropdownColor: Colors.white,
                  value: chapValue,
                  onChanged: (String? value) {
                    setState(() {
                      chapValue = value;
                    });
                  },
                  items: chap.map((String value) {
                    int b = chap.indexOf(value);
                    return DropdownMenuItem<String>(
                        value: chapid[b],
                        child: Text(value,style: TextStyle(fontSize: 15,color: Color.fromRGBO(44, 57, 74, 1)))
                    );
                  }).toList(),
                  iconSize: 50,
                  iconEnabledColor: Colors.black,
                  isExpanded: true,
                ),
              ),
            ),
            Expanded(
              flex: 15,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: quillEditor,
              ),
            ),
            kIsWeb
                ? Expanded(
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: quillToolbar,
                ))
                : Container(
                    child: quillToolbar,
            )
          ],
        ),
      ),
    );
  }

  bool _isDesktop() => !kIsWeb && !Platform.isAndroid && !Platform.isIOS;

  Future<String?> openFileSystemPickerForDesktop(BuildContext context) async {
    return await FilesystemPicker.open(
      context: context,
      rootDirectory: await getApplicationDocumentsDirectory(),
      fsType: FilesystemType.file,
      fileTileSelectMode: FileTileSelectMode.wholeTile,
    );
  }

  // Renders the image picked by imagePicker from local file storage
  // You can also upload the picked image to any server (eg : AWS s3
  // or Firebase) and then return the uploaded image URL.
  Future<String> _onImagePickCallback(File file) async {
    // Copies the picked file from temporary cache to applications directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final copiedFile =
    await file.copy('${appDocDir.path}/${path.basename(file.path)}');
    return copiedFile.path.toString();
  }

  Future<String?> _webImagePickImpl(
      OnImagePickCallback onImagePickCallback) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return null;
    }

    // Take first, because we don't allow picking multiple files.
    final fileName = result.files.first.name;
    final file = File(fileName);

    return onImagePickCallback(file);
  }

  // Renders the video picked by imagePicker from local file storage
  // You can also upload the picked video to any server (eg : AWS s3
  // or Firebase) and then return the uploaded video URL.
  Future<String> _onVideoPickCallback(File file) async {
    // Copies the picked file from temporary cache to applications directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final copiedFile =
    await file.copy('${appDocDir.path}/${path.basename(file.path)}');
    return copiedFile.path.toString();
  }

  // ignore: unused_element
  Future<MediaPickSetting?> _selectMediaPickSetting(BuildContext context) =>
      showDialog<MediaPickSetting>(
        context: context,
        builder: (ctx) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.collections),
                label: const Text('Gallery'),
                onPressed: () => Navigator.pop(ctx, MediaPickSetting.Gallery),
              ),
              TextButton.icon(
                icon: const Icon(Icons.link),
                label: const Text('Link'),
                onPressed: () => Navigator.pop(ctx, MediaPickSetting.Link),
              )
            ],
          ),
        ),
      );

  // ignore: unused_element
  Future<MediaPickSetting?> _selectCameraPickSetting(BuildContext context) =>
      showDialog<MediaPickSetting>(
        context: context,
        builder: (ctx) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.camera),
                label: const Text('Capture a photo'),
                onPressed: () => Navigator.pop(ctx, MediaPickSetting.Camera),
              ),
              TextButton.icon(
                icon: const Icon(Icons.video_call),
                label: const Text('Capture a video'),
                onPressed: () => Navigator.pop(ctx, MediaPickSetting.Video),
              )
            ],
          ),
        ),
      );

  Widget _buildMenuBar(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    const itemStyle = TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Divider(
          thickness: 2,
          color: Colors.white,
          indent: size.width * 0.1,
          endIndent: size.width * 0.1,
        ),
        ListTile(
          title: const Center(child: Text('Read only demo', style: itemStyle)),
          dense: true,
          visualDensity: VisualDensity.compact,
          onTap: _readOnly,
        ),
        Divider(
          thickness: 2,
          color: Colors.white,
          indent: size.width * 0.1,
          endIndent: size.width * 0.1,
        ),
      ],
    );
  }

  void _readOnly() {
    Navigator.pop(super.context);
  }

  Future<String> _onImagePaste(Uint8List imageBytes) async {
    // Saves the image to applications directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final file = await File(
      '${appDocDir.path}/${path.basename('${DateTime.now().millisecondsSinceEpoch}.png')}',
    ).writeAsBytes(imageBytes, flush: true);
    return file.path.toString();
  }

  static void _insertTimeStamp(QuillController controller, String string) {
    controller.document.insert(controller.selection.extentOffset, '\n');
    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.LOCAL,
    );

    controller.document.insert(
      controller.selection.extentOffset,
      TimeStampEmbed(string),
    );

    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.LOCAL,
    );

    controller.document.insert(controller.selection.extentOffset, ' ');
    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.LOCAL,
    );

    controller.document.insert(controller.selection.extentOffset, '\n');
    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.LOCAL,
    );
  }
}
