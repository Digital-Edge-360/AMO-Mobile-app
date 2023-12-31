import 'dart:developer';
import 'package:amo_cabs/authentication/login_screen.dart';
import 'package:amo_cabs/infoHandler/app_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../global/global.dart';

class MyDrawer extends StatefulWidget {
  String? name;
  String? phone;
  String? lastName;

  MyDrawer({super.key, this.name, this.phone, this.lastName});
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xff029EE2),
      child: ListView(
        children: [
          //drawer header
          SizedBox(
            height: 250,
            child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                'images/img_11.png',
                                height: 60,
                              ),
                            ],
                          ),

                          //  ],
                          Expanded(
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 30, left: 30),
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.black54,
                                  child: Text(
                                    '${widget.name!.substring(0, 1)}${widget.lastName!.substring(0, 1)}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 44,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                          ),
                        ]),

                    // Text name ---
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${userModelCurrentInfo!.firstName} ${userModelCurrentInfo!.lastName}',
                              style: const TextStyle(
                                  fontSize: 20, fontFamily: ("Poppins")),
                            ),
                            Text(userModelCurrentInfo!.phoneNumber.toString(),
                                style: const TextStyle(
                                    fontFamily: ("Poppins"),
                                    color: Color(0xff019EE3)))
                          ],
                        ),
                      ],
                    )
                  ],
                )),
          ),

          const SizedBox(
            height: 12,
          ),

          //drawer body

          //MainScreen
          GestureDetector(
            onTap: () {
              Provider.of<AppInfo>(context, listen: false)
                  .changeCurrentIndex(0);
              log("Main page got clicked");
              Navigator.pop(context);
            },
            child: const ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.white,
              ),
              title: Text(
                "Home",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),

          //history
          GestureDetector(
            onTap: () {
              Provider.of<AppInfo>(context, listen: false)
                  .changeCurrentIndex(1);
              log("history page got clicked");
              Navigator.pop(context);
            },
            child: const ListTile(
              leading: Icon(
                Icons.history,
                color: Colors.white,
              ),
              title: Text(
                "History",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Provider.of<AppInfo>(context, listen: false)
                  .changeCurrentIndex(2);
              log("history page got clicked");
              Navigator.pop(context);
            },
            child: const ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.white,
              ),
              title: Text(
                "Support",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () async {
              await fAuth.signOut();
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.remove("userCurrentInfo");
              await prefs.remove('userType');

              // ignore: use_build_context_synchronously
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginScreen()),
                  ModalRoute.withName('/'));
            },
            child: const ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
