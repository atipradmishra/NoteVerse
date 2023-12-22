import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:noteverse/database/chapter_curd.dart';
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



class Chapterlist extends StatefulWidget {
  const Chapterlist({Key? key}) : super(key: key);

  @override
  State<Chapterlist> createState() => _TasklistState();
}

class _TasklistState extends State<Chapterlist> {
  TextEditingController searchController = TextEditingController();
   Chaptercurdmap _map = Chaptercurdmap();
  Taskcurdmap _tmap = Taskcurdmap();
  Remindercurdmap _rmap = Remindercurdmap();

  Future<List<Chapter>> getChapterNames() async {
    final db = await ConnectionSQLiteService.instance.db;
    List<Map> data = await db.rawQuery('select * from Chapter;');
    List<Chapter> names = Chapter.fromSQLiteList(data);
    return names;
  }
  List<Chapter> names = [];
  Future<void> selectallnames() async {
    try {
      List<Chapter> data = await getChapterNames();
      names.clear();
      names.addAll(data);
      setState(() {});
    } catch (error) {
      print(error);
    }
  }
  List<Chapter> foundtasks = [];
  void filterNotes(String query) {
    List<Chapter> results = [];
    if (query.isEmpty){
      results = names;
    } else {
      results =  names.where((user) => user.Name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState((){
      foundtasks = results;
    });
  }


  @override
  void initState() {
    foundtasks = names;
    selectallnames();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(44, 57, 74, 1),
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Note Verse',
        ),
      ),
      body:GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: height/30,),
            Text('Chapters',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
            SizedBox(height: height/30,),
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
            foundtasks.isNotEmpty ?
            Expanded(
              flex: 1,
              child: ListView.builder(
                padding: EdgeInsets.only(top: 22),
                itemCount: foundtasks.length,
                itemBuilder: (context, index) {
                  var name;
                  for (var a in names){
                    name = a.Name;
                  }
                  return GestureDetector(
                    onTap: () async {
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
                                        '${foundtasks[index].Name}',
                                        style: TextStyle(
                                          color: Color(0xFF14181B),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                        child: Text(
                                          '${foundtasks[index].Description}',
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
                                          builder: (context) => AddChapter(
                                            chaps : foundtasks[index],
                                          ),
                                        )).then((value) => selectallnames());
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
                                        content: Text('Are you sure you want to delete ${names[index].Name}?',style: TextStyle(fontSize: ScreenUtil().setSp(20))),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await _map.deleteItem(names[index].ChapterId ?? 0);
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(content: Text('Chapter Deleted Successfully')));
                                            },
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      );
                                    }).then((value) => selectallnames());
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
                  )).then((value) => selectallnames());
            },
          ),
        ],
        child: const Icon(Icons.add),
      ),
    );
  }
}
