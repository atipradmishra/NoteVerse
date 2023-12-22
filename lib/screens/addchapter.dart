import 'package:flutter/material.dart';
import 'package:noteverse/database/chapter_curd.dart';
import 'package:noteverse/screens/homepage.dart';
import '../database/chaptermodel.dart';
import '../widgets/custom_drawer.dart';

class AddChapter extends StatefulWidget {
  Chapter? chaps;
  AddChapter({this.chaps});

  @override
  State<AddChapter> createState() => _AddChapterState();
}
final List<bool> _isSelected = [false, false, false];
bool vertical = false;
TextEditingController _name = TextEditingController();
TextEditingController _description = TextEditingController();


class _AddChapterState extends State<AddChapter> {

  Chapter chap = Chapter.empty();
  Chaptercurdmap _map = Chaptercurdmap();

  String title = "Add Chapter";
  void FormData() {
    if (widget.chaps != null) {
      title = "Update Chapter";
      _name.text = widget.chaps!.Name.toString();
      _description.text = widget.chaps!.Description.toString();
      chap = widget.chaps!;
    }
  }

  void save() {
    chap.Name = _name.text;
    chap.Description = _description.text;
    if (chap.ChapterId == null) {
      addchap();
      return;
    }
    else {
      updatechap();
    }
  }

  void updatechap() async {
    try {
      if (await _map.update(chap)) {
        showmessage('Chapter updated');
        return;
      }
      showmessage('No Chapter changed');
    } catch (error) {
      print(error);
      showmessage('Error');
    }
  }

  void addchap() async {
    try {
      chap.Name = _name.text;
      chap.Description = _description.text;
      Chapter data = await _map.add(chap);
      chap.ChapterId = data.ChapterId;
      showmessage('Chapter added successful');
      setState(() {});
    } catch (error) {
      print(error);
      showmessage('Error Saving Chapter');
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
                        'Chapter Name',
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
                            hintText: "# Chapter Name",
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
                          hintText: "# Description about the Chapter",
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      )
                    ],
                  ),
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
