// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:amo_cabs/mainScreens/home_screen.dart';
import 'package:amo_cabs/onboardingScreens/onboarding_screen1.dart';
import 'package:flutter/material.dart';

import '../assistants/assistant_methods.dart';
import '../global/global.dart';

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
      if (fAuth.currentUser != null) {
        currentFirebaseUser = fAuth.currentUser;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (c) => HomeScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (c) => const OnboardingScreen(),
          ),
        );
      }
    });
  }

  @override
  void initState() {
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
                  child: const Column(
                    children: [
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
                    child: Image.asset(
                      "images/img.png",
                      height: 215,
                      width: 215,
                    )),
              ),
              Padding(
                padding:  EdgeInsets.only(top: MediaQuery.of(context).size.width*0.07, left: 50),
                child: Image.asset(
                  "images/img_1.png",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
