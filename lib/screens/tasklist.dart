import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:noteverse/database/notemodel.dart';
import '../database/chaptermodel.dart';
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



class Tasklist extends StatefulWidget {
  const Tasklist({Key? key}) : super(key: key);

  @override
  State<Tasklist> createState() => _TasklistState();
}

class _TasklistState extends State<Tasklist> {
  List<Task> tasks = [];
  int? tn = 0;
  int? tt = 0;
  int? tr = 0;
  TextEditingController searchController = TextEditingController();
  Notecurdmap _map = Notecurdmap();
  Taskcurdmap _tmap = Taskcurdmap();
  Remindercurdmap _rmap = Remindercurdmap();
  Future<void> selectallnotes() async {
    try {
      List<Note> data = await _map.selectall();
      tn = data.length;
      setState(() {});
    } catch (error) {
      print(error);
    }
  }
  Future<void> selectalltasks() async {
    try {
      List<Task> data = await _tmap.selectall();
      tasks.clear();
      tasks.addAll(data);
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

  List<Chapter> names = [];
  List<Task> foundtasks = [];
  void filterNotes(String query) {
    List<Task> results = [];
    if (query.isEmpty){
      results = tasks;
    } else {
      results =  tasks.where((user) => user.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState((){
      foundtasks = results;
    });
  }


  @override
  void initState() {
    foundtasks = tasks;
    selectallnotes();
    selectalltasks();
    selectallreminders();
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
            Text('Tasks',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
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
                                        '${foundtasks[index].title}',
                                        style: TextStyle(
                                          color: Color(0xFF14181B),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                        child: Text(
                                          '${foundtasks[index].date}',
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
                                          builder: (context) => AddTask(
                                            tasks : foundtasks[index],
                                          ),
                                        )).then((value) => selectalltasks());
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
                                        content: Text('Are you sure you want to delete ${tasks[index].title}?',style: TextStyle(fontSize: ScreenUtil().setSp(20))),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await _tmap.deleteItem(tasks[index].TaskId ?? 0);
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(content: Text('Task Deleted Successfully')));
                                            },
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      );
                                    }).then((value) => selectalltasks());
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
    );
  }
}
