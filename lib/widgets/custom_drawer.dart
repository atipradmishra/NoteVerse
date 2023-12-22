import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:noteverse/screens/addchapter.dart';
import 'package:noteverse/screens/addreminder.dart';
import 'package:noteverse/screens/homepage.dart';

import '../screens/chapterlist.dart';
import '../screens/reminderlist.dart';
import '../screens/tasklist.dart';
import 'bottom_user_info.dart';
import 'custom_list_tile.dart';
import 'header.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        curve: Curves.easeInBack,
        duration: const Duration(milliseconds: 500),
        width:// _isCollapsed
            //?
          MediaQuery.of(context).size.width/2,
            //: MediaQuery.of(context).size.width * 0.15,
        margin: const EdgeInsets.only(bottom: 100, top: 100),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: Colors.blueGrey,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomDrawerHeader(isColapsed: !_isCollapsed),
              const Divider(
                color: Colors.deepOrange,
              ),
              CustomListTile(
                onTapped: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyAppHomeScreen(),
                      ));
                },
                isCollapsed: !_isCollapsed,
                icon: Icons.home_outlined,
                title: 'Home',
                infoCount: 0,
              ),
              CustomListTile(
                isCollapsed: !_isCollapsed,
                icon: Icons.notes,
                title: 'Notes',
                infoCount: 0,
                onTapped: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyAppHomeScreen(),
                      ));
                },
              ),
              CustomListTile(
                isCollapsed: !_isCollapsed,
                icon: Icons.view_week,
                title: 'Tasks',
                infoCount: 0,
                onTapped: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Tasklist(),
                    ),
                  );
                },
              ),
              CustomListTile(
                isCollapsed: !_isCollapsed,
                icon: Icons.remember_me,
                title: 'Reminders',
                infoCount: 0,
                onTapped: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Reminderlist(),
                      ));
                },
              ),
              CustomListTile(
                isCollapsed: !_isCollapsed,
                icon: Icons.comment_bank,
                title: 'Chapters',
                infoCount: 0,
                onTapped: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Chapterlist(),
                      ));
                },
              ),
              const Divider(
                color: Colors.deepOrange,
              ),
              const Spacer(),
              CustomListTile(
                isCollapsed: !_isCollapsed,
                icon: Icons.notifications,
                title: 'Notifications',
                infoCount: 0,
                onTapped: () {

                },
              ),
              LiteRollingSwitch(
                value: true,
                width: 120,
                textOn: 'Dark',
                textOnColor: Colors.white70,
                textOffColor: Colors.black,
                textOff: 'Light',
                colorOn: Colors.black,
                colorOff: Colors.white70,
                iconOn: Icons.dark_mode_outlined,
                iconOff: Icons.light_mode_outlined,
                animationDuration: const Duration(milliseconds: 300),
                onChanged: (bool state) {
                  print('turned ${(state) ? 'on' : 'off'}');
                },
                onDoubleTap: () {},
                onSwipe: () {},
                onTap: () {},
              ),
              const SizedBox(height: 10),
              // Align(
              //   alignment: !_isCollapsed
              //       ? Alignment.bottomRight
              //       : Alignment.bottomCenter,
              //   child: IconButton(
              //     splashColor: Colors.transparent,
              //     icon: Icon(
              //       _isCollapsed
              //           ? Icons.arrow_back_ios
              //           : Icons.arrow_forward_ios,
              //       color: Colors.black,
              //       size: 16,
              //     ),
              //     onPressed: () {
              //       setState(() {
              //         _isCollapsed = !_isCollapsed;
              //       });
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
