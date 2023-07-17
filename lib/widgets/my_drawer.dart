import 'package:amo_cabs/onboardingScreens/login_as_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication/login_screen.dart';
import '../global/global.dart';

// ignore: must_be_immutable
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
                              '${widget.name} ${widget.lastName}',
                              style: const TextStyle(
                                  fontSize: 20, fontFamily: ("Poppins")),
                            ),
                            Text(widget.phone.toString(),
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
          GestureDetector(
            onTap: () {},
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
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.white,
              ),
              title: Text(
                "About",
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
                      builder: (BuildContext context) => LogInAsScreen()),
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
