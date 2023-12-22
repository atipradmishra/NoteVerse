import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import '../database/taskcurd.dart';
import '../database/taskmodel.dart';
import '../widgets/custom_drawer.dart';
import 'homepage.dart';

class AddTask extends StatefulWidget {
  Task? tasks;AddTask({this.tasks});

  @override
  State<AddTask> createState() => _AddTaskState();
}
bool vertical = false;
class _AddTaskState extends State<AddTask> {
  TextEditingController _name = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _event = TextEditingController();
  DateTime? dateTime;
  Task task = Task.empty();
  Taskcurdmap _map = Taskcurdmap();

  String title = "Add Task";
  void FormData() {
    if (widget.tasks != null) {
      title = "Update Task";
      _name.text = widget.tasks!.title.toString();
      _description.text = widget.tasks!.description.toString();
      _event.text = widget.tasks!.event.toString();
      task = widget.tasks!;
    }
  }

  void save() {
    task.title = _name.text;
    task.description = _description.text;
    task.event = _event.text;
    if (task.TaskId == null) {
      addtask();
      return;
    }
    else {
      updatetask();
    }
  }

  void updatetask() async {
    try {
      if (await _map.update(task)) {
        showmessage('Task updated');
        return;
      }
      showmessage('No Task changed');
    } catch (error) {
      print(error);
      showmessage('Error');
    }
  }

  void addtask() async {
    try {
      task.title = _name.text;
      task.description = _description.text;
      task.event = _event.text;
      task.date = dateTime.toString();
      Task data = await _map.add(task);
      task.TaskId = data.TaskId;
      showmessage('Task added successful');
      setState(() {});
    } catch (error) {
      print(error);
      showmessage('Task Saving Chapter');
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
          scrollDirection: Axis.vertical,
          child: Container(
            color: Color.fromRGBO(250, 250, 250, 1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: height/6,
                  width: width,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin:  Alignment.topRight,
                      end: Alignment.bottomLeft, colors: [Colors.transparent,Colors.black],
                    ),
                    image: DecorationImage(
                        image: const AssetImage("assets/vector.png"),
                        fit: BoxFit.cover,
                        opacity: 0.5
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height/60,),
                      Row(
                        children: [
                          InkWell(
                            onTap: ()  {Navigator.pop(context);},
                            child: Icon(Icons.arrow_back,size: 35,color: Colors.white,),
                          ),
                          SizedBox(width: width/30,),
                          Text(
                            title,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22
                            ),
                          )
                        ],
                      ),
                      Text(
                        'Describe Your Work And Let Us Remember',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: height/40),
                Container(
                  height: height/6,
                  width: width,
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _name,
                          obscureText: false,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.grey,fontSize: 20),
                            hintText: "# Give a Title to your task",
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: height/6,
                  width: width,
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Event Name',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _event,
                          obscureText: false,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.grey,fontSize: 20),
                            hintText: "# Event name of your task",
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: height/3.5,
                  width: width,
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description (optional)',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: _description,
                        obscureText: false,
                        maxLines: 4,
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey,fontSize: 20),
                          hintText: "# Give a Description to your task",
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? pickedDateTime = await showOmniDateTimePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate:
                      DateTime(1600).subtract(const Duration(days: 3652)),
                      lastDate: DateTime.now().add(
                        const Duration(days: 3652),
                      ),
                      is24HourMode: false,
                      isShowSeconds: false,
                      minutesInterval: 1,
                      secondsInterval: 1,
                      isForce2Digits: true,
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      constraints: const BoxConstraints(
                        maxWidth: 350,
                        maxHeight: 650,
                      ),
                      transitionBuilder: (context, anim1, anim2, child) {
                        return FadeTransition(
                          opacity: anim1.drive(
                            Tween(
                              begin: 0,
                              end: 1,
                            ),
                          ),
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 100),
                      barrierDismissible: true,
                      selectableDayPredicate: (dateTime) {
                        // Disable 25th Feb 2023
                        if (dateTime == DateTime(2023, 2, 25)) {
                          return false;
                        } else {
                          return true;
                        }
                      },
                    );
                    if (pickedDateTime != null ){
                      setState(() {
                        dateTime = pickedDateTime;
                      });
                    }
                    print("dateTime: $dateTime");
                  },
                  child: const Text("Select Date and Time"),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  height: height/15,
                  width: width/1.1,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                      color: Colors.green,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green,
                          spreadRadius: 4,
                          blurRadius: 10,
                        ),
                        BoxShadow(
                          color: Colors.green,
                          spreadRadius: -4,
                          blurRadius: 5,
                        )
                      ]),
                  child: TextButton(
                    onPressed:() async{
                      save();
                      await Navigator.push(context ,MaterialPageRoute(builder: (context) => MyAppHomeScreen()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Continue",style: TextStyle(color: Colors.white,fontSize: 25),),
                        Icon(Icons.arrow_right_alt_rounded,size: 40,color: Colors.white,),
                      ],
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
