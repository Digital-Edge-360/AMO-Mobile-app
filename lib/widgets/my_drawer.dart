import 'package:flutter/material.dart';

import '../global/global.dart';
import '../splashScreen/splash_screen.dart';

class MyDrawer extends StatefulWidget {
  String? name;
  String? email;

  MyDrawer({this.name, this.email});
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
                              padding: const EdgeInsets.only(
                                  top: 30, left: 30),
                              child: Image.asset(
                                "images/img_12.png",
                                height: 120,
                                width: 120,
                              ),
                            ),
                          ),
                        ]),

                    // Text name ---
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
                            Text(
                              widget.name.toString(),
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: ("Poppins")),
                            ),
                            Text(widget.email.toString(),
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


          const SizedBox(height: 12,),

          //drawer body
          GestureDetector(
            onTap: (){

            },
            child: const ListTile(
              leading: Icon(Icons.history, color: Colors.white,),
              title: Text(
                "History",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){

            },
            child: const ListTile(
              leading: Icon(Icons.person, color: Colors.white,),
              title: Text(
                "Visit Profile",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){

            },
            child: const ListTile(
              leading: Icon(Icons.info, color: Colors.white,),
              title: Text(
                "About",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){
              fAuth.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (c) => MySplashScreen()),);
            },
            child: const ListTile(
              leading: Icon(Icons.logout, color: Colors.white,),
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
