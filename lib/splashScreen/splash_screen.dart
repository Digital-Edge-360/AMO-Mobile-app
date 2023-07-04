import 'dart:async';

import 'package:flutter/material.dart';

import '../assistants/assistant_methods.dart';
import '../authentication/login_screen.dart';
import '../global/global.dart';
import '../mainScreens/main_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  void startTimer() {
    fAuth.currentUser != null
        ? AssistantMethods.readCurrentOnlineUserInfo()
        : null;
    Timer(const Duration(seconds: 3), () async {
      //take the user to a main screen

      if (await fAuth.currentUser != null) {
        currentFirebaseUser = fAuth.currentUser;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => MainScreen(),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => LoginScreen(),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 70, left: 10),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: const [
                      Text(
                        "Let's ",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 64,
                            color: Color(0xff73D477)),
                      ),
                      Text(
                        "Ride",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 64,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 81),
                child: Center(
                    child: Container(
                        child: Image.asset(
                          "images/img.png",
                          height: 215,
                          width: 215,
                        ))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 72, bottom: 5.0, left: 50),
                child: Container(
                  child: Image.asset(
                    "images/img_1.png",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
