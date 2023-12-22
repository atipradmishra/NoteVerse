import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../database/user_curd.dart';
import '../database/usermodel.dart';
import '../widgets/custom_drawer.dart';


class AddUser extends StatefulWidget {
  User? users;
  AddUser({this.users});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {

  FilePickerResult? result;
  String? _filePath;
  PlatformFile? pickedfile;
  bool isLoding = false;
  File? fileToDisplay;
  void pickFile() async{
    try{
      setState(() {
        isLoding = true;
      });
      result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if(result != null){
        pickedfile = result!.files.first;
        fileToDisplay = File(pickedfile!.path.toString());
        _filePath = pickedfile!.path.toString();
      }
      setState(() {
        isLoding = false;
      });
    }catch(e){
      print(e);
    }
  }


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _textController1 = TextEditingController();
  TextEditingController _textController2 = TextEditingController();
  TextEditingController _textController3 = TextEditingController();
  TextEditingController _textController4 = TextEditingController();
  Usercurdmap _usertablemap = Usercurdmap();
  User  user = User.empty();

  String title = "Add User";
  void FormData() {
    if (widget.users != null) {
      title = "Update User";
      _textController1.text = widget.users!.UserName.toString();
      _textController2.text = widget.users!.UserName.toString();
      _textController3.text = widget.users!.UserName.toString();
      _textController4.text = widget.users!.UserName.toString();
      _filePath = widget.users!.ImagePath.toString();
      user = widget.users!;
    }
  }

  void save() {
    user.UserName = _textController1.text;
    user.Gender = _textController2.text;
    user.Email = _textController3.text;
    user.PhoneNo = _textController4.text;
    user.ImagePath = _filePath;
    if (user.UserId == null) {
      adduser();
      return;
    }
    else {
      updateuser();
    }
  }

  void updateuser() async {
    try {
      if (await _usertablemap.update(user)) {
        showmessage('user updated');
        return;
      }
      showmessage('No user changed');
    } catch (error) {
      print(error);
      showmessage('Error');
    }
  }

  void adduser() async {
    try {
      user.UserName = _textController1.text;
      user.Gender = _textController2.text;
      user.Email = _textController3.text;
      user.PhoneNo = _textController4.text;
      user.ImagePath = _filePath;
      User data = await _usertablemap.add(user);
      user.UserId = data.UserId;
      showmessage('User added successful');
      setState(() {});
    } catch (error) {
      print(error);
      showmessage('Error Saving User');
    }
  }

  void showmessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    FormData();
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
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                SizedBox(height: height/60),
                Center(
                  child: Text(
                    "Add User",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Color.fromRGBO(44, 57, 74, 1),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: height/60),
                GestureDetector(
                  onTap:() async {
                    final androidInfo = await DeviceInfoPlugin().androidInfo;
                    late final Map<Permission,PermissionStatus> statusess;
                    if (androidInfo.version.sdkInt! <= 32){
                      statusess = await [
                        Permission.storage
                      ].request();
                    } else {
                      statusess = await [
                        Permission.photos
                      ].request();
                    }

                    var allAccepted = true;
                    statusess.forEach((permission, status) {
                      if (status != PermissionStatus.granted){
                        allAccepted = false;
                      }
                    });
                    if (allAccepted){
                      pickFile();
                    } else {
                      showmessage('This permission is required');
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: width/5,
                    child: fileToDisplay != null || _filePath != null ?
                    ClipOval(
                      child: Image.file(
                        File(_filePath!),
                        fit: BoxFit.cover,
                        width: width/2,
                        height: height/5,
                      ),
                    ) :
                    Container(
                        decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(200)),),
                        child: Center(
                          child: Icon(
                            Icons.add_a_photo,
                            size: 60,
                          ),
                        ),
                        width: width/2,
                        height: height/5
                    ),
                  ),
                ),
                SizedBox(height: height/60),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: TextFormField(
                    controller: _textController1,
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'User Name*',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: TextFormField(
                    controller:  _textController2,
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Gender',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                        child: TextFormField(
                          controller: _textController3,
                          autofocus: false,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: 'Email*',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 10, 10),
                        child: TextFormField(
                          controller: _textController4,
                          autofocus: false,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: 'Phone No*',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: height/40),
                  child: SizedBox(
                    height: height/15,
                    width: width/2,
                    child: ElevatedButton(
                      child: Text('Save', style: TextStyle(fontSize: 25,color: Colors.green),),
                      onPressed: () async {
                          save();
                          Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(
                            width: 1, color: Color.fromRGBO(25, 153, 0, 1)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
