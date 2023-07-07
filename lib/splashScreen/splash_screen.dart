import 'dart:async';
import 'package:flutter/material.dart';

import '../onboardingScreens/onboarding_screen1.dart';

class MySplashScreen extends StatelessWidget {
  const MySplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}
class MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer( const Duration(seconds: 2),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                    const OnboardingScreen()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 70, left: 10),
              child: Container(
                alignment: Alignment.topLeft,
                child: const Column(
                  children:  [
                    Text(
                      "Let's ",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 54,
                          color: Color(0xff73D477)),
                    ),
                    Text(
                      "Ride",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 54,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 51),
              child: Center(
                  child: Image.asset(
                    "images/img.png",
                    height: 200,
                    width: 215,
                  )),
              ),
            Image.asset(
              "images/img_1.png",
              alignment: Alignment.bottomLeft,
            ),
          ],
        ),
      ),

    );

  }
}
