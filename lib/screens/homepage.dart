import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:noteverse/database/chapter_curd.dart';
import 'package:noteverse/database/notemodel.dart';
import 'package:noteverse/screens/pdfpriview.dart';
import 'package:noteverse/screens/reminderlist.dart';
import 'package:noteverse/screens/tasklist.dart';
import '../database/chaptermodel.dart';
import '../database/connections.dart';
import '../database/note_curd.dart';
import '../database/remindercurd.dart';
import '../database/remindermodel.dart';
import '../database/taskcurd.dart';
import '../database/taskmodel.dart';
import '../editorpage.dart';
import '../widgets/custom_drawer.dart';
import 'addchapter.dart';
import 'addreminder.dart';
import 'addtask.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'adduser.dart';
import 'noteviewpage.dart';


class MyAppHomeScreen extends StatefulWidget {
  @override
  State<MyAppHomeScreen> createState() => _MyAppHomeScreenState();
}

class _MyAppHomeScreenState extends State<MyAppHomeScreen> {
  List<Note> notes = [];
  int? tn = 0;
  int? tt = 0;
  int? tr = 0;
  TextEditingController searchController = TextEditingController();
  Notecurdmap _map = Notecurdmap();
  Taskcurdmap _tmap = Taskcurdmap();
  Remindercurdmap _rmap = Remindercurdmap();
  Chaptercurdmap _cmap = Chaptercurdmap();
  Future<void> selectallnotes() async {
    try {
      List<Note> data = await _map.selectall();
      notes.clear();
      notes.addAll(data);
      tn = data.length;
      setState(() {});
    } catch (error) {
      print(error);
    }
  }
  Future<void> selectalltasks() async {
    try {
      List<Task> data = await _tmap.selectall();
      tt = data.length;
      setState(() {});
    } catch (error) {
      print(error);
    }
  }
  Future<void> selectallreminders() async {
    try {
      List<Reminder> data = await _rmap.selectall();
      tr = data.length;
      setState(() {});
    } catch (error) {
      print(error);
    }
  }
  Future<List<Chapter>> getallChapter() async {
    final db = await ConnectionSQLiteService.instance.db;
    List<Map> data = await db.rawQuery('select * from Chapter;');
    List<Chapter> names = Chapter.fromSQLiteList(data);
    return names;
  }
  final List<Chapter> names = [];
  Future<void> selectallnames() async {
    try {
      List<Chapter> data = await _cmap.selectall();
      names.clear();
      names.addAll(data);
      setState(() {});
    } catch (error) {
      print(error);
    }
  }
  // Future<String> getChapterNames(String id) async {
  //   final db = await ConnectionSQLiteService.instance.db;
  //   final result = await db.rawQuery('select Name from Chapter WHERE ChapterId = ?;', [id]);
  //
  //   if (result.isNotEmpty) {
  //     return result.first['Name'] as String; // Ensure the value is of type String
  //   } else {
  //     return 'others';
  //   }
  // }

  List<Note> foundnotes = [];
  void filterNotes(String query) {
    List<Note> results = [];
    if (query.isEmpty){
      results = notes;
    } else {
      results =  notes.where((user) => user.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState((){
      foundnotes = results;
    });
  }


  @override
  void initState() {
    foundnotes = notes;
    selectallnotes();
    selectalltasks();
    selectallnames();
    selectallreminders();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        drawer: const CustomDrawer(),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: height/4,
                width: width,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  image: DecorationImage(
                      image: const AssetImage("assets/mountains-8314422_1920.png"),
                      fit: BoxFit.cover,
                      opacity: 0.6
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(15,0, 0, 0),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'NoteVerse',
                                style: TextStyle(fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.bold,color: Color.fromRGBO(44, 57, 74, 1),),),
                              Text(
                                'Welcome, Buddy',
                                style: TextStyle(
                                  fontSize:ScreenUtil().setSp(20),
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(44, 57, 74, 1),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: height/50,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: height/11,
                          width: width/4,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(44, 57, 74, 1),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10.0,
                            ),],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Notes",
                                style: TextStyle(
                                    fontSize: 18,
                                    decoration: TextDecoration.underline,
                                    color: Colors.white
                                ),
                              ),
                              Text(
                                tn.toString(),
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Tasklist(),
                              ),
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: height/11,
                            width: width/4,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(44, 57, 74, 1),
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              boxShadow: [BoxShadow(
                                color: Colors.grey,
                                blurRadius: 10.0,
                              ),],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Tasks",
                                  style: TextStyle(
                                      fontSize: 18,
                                      decoration: TextDecoration.underline,
                                      color: Colors.white
                                  ),
                                ),
                                Text(
                                  tt.toString(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.yellow,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Reminderlist(),
                              ),
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: height/11,
                            width: width/3,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(44, 57, 74, 1),
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              boxShadow: [BoxShadow(
                                color: Colors.grey,
                                blurRadius: 10.0,
                              ),],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Reminders",
                                  style: TextStyle(
                                      fontSize: 18,
                                      decoration: TextDecoration.underline,
                                      color: Colors.white
                                  ),
                                ),
                                Text(
                                  tr.toString(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.yellow,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) => filterNotes(value),
                    decoration: InputDecoration(
                      hintText: 'Search Title...',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () => searchController.clear(),
                      ),
                      prefixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {},
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
              ),
              foundnotes.isNotEmpty ?
              Expanded(
                flex: 1,
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 22),
                  itemCount: foundnotes.length,
                  itemBuilder: (context, index) {
                    var note = foundnotes[index];
                    var name = names.firstWhere((Chapter) => Chapter.ChapterId == note.ChapterId, orElse: () => Chapter(ChapterId: 0, Name: 'Others', Description: ''));
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotePreview(
                                notes : foundnotes[index],
                              ),
                            )).then((value) => selectallnotes());
                      },
                      child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 7,
                                  color: Color(0x2F1D2429),
                                  offset: Offset(0, 3),
                                )
                              ],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.sticky_note_2_outlined,
                                    color: Color(0xFF4B39EF),
                                    size: 32,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(12, 0, 10, 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${foundnotes[index].title}',
                                            style: TextStyle(
                                              color: Color(0xFF14181B),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                            child: Text(
                                              '${name.Name}',
                                              style: TextStyle(
                                                color: Color(0xFF57636C),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 4, 0),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.edit_outlined,
                                        color: Color(0xFF57636C),
                                        size: 20,
                                      ),
                                      onPressed: () async {
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditorPage(
                                                notes : foundnotes[index],
                                              ),
                                            )).then((value) => selectallnotes());
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 4, 0),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.share_rounded,
                                        color: Color(0xFF57636C),
                                        size: 20,
                                      ),
                                      onPressed: () async {
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => pdf(
                                                notes : foundnotes[index],
                                              ),
                                            )).then((value) => selectallnotes());
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 4, 0),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Color(0xFF57636C),
                                        size: 20,
                                      ),
                                      onPressed: (){
                                        showDialog(context: context,barrierDismissible: false, builder: (BuildContext context){
                                          return AlertDialog(
                                            title: Text('Confirm'),
                                            content: Text('Are you sure you want to delete ${foundnotes[index].title}?',style: TextStyle(fontSize: ScreenUtil().setSp(20))),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await _map.deleteItem(foundnotes[index].NoteId ?? 0);
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(content: Text('Note Deleted Successfully')));
                                                },
                                                child: Text('Delete'),
                                              ),
                                            ],
                                          );
                                        }).then((value) => selectallnotes());
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    );
                  },
                ),
              )
                  :SingleChildScrollView(
                    child: Column(
                      children: [
                        Lottie.asset(
                      width: width,
                      height: height/2,
                      frameRate: FrameRate(90),
                      "assets/animation_lod166yj.zip",
                      reverse: true,
                      options: LottieOptions(enableApplyingOpacityToLayers: true),
                      fit: BoxFit.fill,
                    ),
                    Text(
                      'No Records Found',
                      style: TextStyle(
                        fontFamily: 'sometype-mono',
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(44, 57, 74, 1),
                      ),
                    )
                ],
              ),
                  ),
            ],
          ),
        ),
        floatingActionButton: SpeedDial(
          iconTheme: IconThemeData.fallback(),
          animatedIcon: AnimatedIcons.add_event,
          backgroundColor: Color.fromRGBO(44, 57, 74, 1),
          overlayColor: Colors.black,
          overlayOpacity: 0.2,
          spacing: 10,
          closeManually: false,
          children: [
            SpeedDialChild(
                child: Icon(Icons.add_comment_outlined),
                label: 'Add Chapters',
                onTap: () async {
                  Get.to(() => AddChapter(),transition: Transition.rightToLeftWithFade,duration: Duration(seconds: 1)
                  );
                }
            ),
            SpeedDialChild(
                child: Icon(Icons.add_task_outlined),
                label: 'Add Task',
                onTap: () {
                  Get.to(() => AddTask(),transition: Transition.rightToLeftWithFade,duration: Duration(seconds: 1)
                  );
                }
            ),
            SpeedDialChild(
                child: Icon(Icons.add_alert_outlined),
                label: 'Add Reminder',
                onTap: () {
                  Get.to(() => Addreminder(),transition: Transition.downToUp,duration: Duration(seconds: 1));
                }
            ),
            SpeedDialChild(
                child: Icon(Icons.note_add),
                label: 'Add Note',
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditorPage(),
                    )).then((value) => selectallnotes());
              },
            ),
          ],
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}