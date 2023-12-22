import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/delayed_animation.dart';
import 'homepage.dart';
import 'package:device_info_plus/device_info_plus.dart';


class FlashScreen extends StatefulWidget {
  const FlashScreen({Key? key}) : super(key: key);

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;
  // final bool? repeat = true;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }
  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }
  final int delayedAmount = 1000;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            colors: [Color.fromRGBO(129, 45, 203, 1), Color.fromRGBO(133, 53, 204, 0.1)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
                'assets/animation_locka698.zip',
              width: width,
              height: height/2,
                // reverse: repeat,
                fit: BoxFit.contain,
              frameRate: FrameRate(90),
              // controller: _controller,
              // onLoaded: (compos) {
              //     _controller
              //     ..duration = compos.duration
              //         ..forward().then((value) {
              //           // Navigator.push(context, MaterialPageRoute(builder: (context) => MyAppHomeScreen()));
              //         });
              // }
            ),
            DelayedAnimation(
              delay: delayedAmount,
              child: Text(
                "NoteVerse",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32.0,
                    fontFamily: 'sometype-mono',
                    color: Colors.indigo),
              ),
            ),
            DelayedAnimation(
              delay: delayedAmount + 1000,
              child: Text(
                "Your Digital Study Companion",
                style: TextStyle(fontSize: 20.0, color:Color.fromRGBO(129, 45, 203, 1),fontFamily: 'sometype-mono',),
              ),
            ),
            SizedBox(height: height/8),
            DelayedAnimation(
              delay: delayedAmount + 2000,
              child: GestureDetector(
                onTap:() async {
                  final androidInfo = await DeviceInfoPlugin().androidInfo;
                  late final Map<Permission,PermissionStatus> statusess;
                  if (androidInfo.version.sdkInt! <= 32){
                    statusess = await [
                      Permission.storage,
                      Permission.camera,
                      Permission.location,
                      Permission.microphone
                    ].request();
                  } else {
                    statusess = await [
                      Permission.photos,
                      Permission.camera,
                      Permission.location,
                      Permission.microphone
                    ].request();
                  }
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyAppHomeScreen()));;
                  var allAccepted = true;
                  statusess.forEach((permission, status) {
                    if (status != PermissionStatus.granted){
                      allAccepted = false;
                    }
                  });
                  // if (allAccepted){
                  //   await Navigator.push(context,
                  //       MaterialPageRoute(builder: (context) => MyAppHomeScreen()));;
                  // } else {
                  //   showmessage('This permission is required');
                  // }
                  },
                child: _animatedButtonUI,
              ),
            ),
          ],
        ),
      ),
    );
  }
  void showmessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
  Widget get _animatedButtonUI => Container(
    height: 60,
    width: 270,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100.0),
      gradient: LinearGradient(
        colors: [Color.fromRGBO(129, 45, 203, 1), Color.fromARGB(255, 29, 221, 163)],
      ),
    ),
    child: const Center(
      child: Text(
        'Get Started',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );
}
