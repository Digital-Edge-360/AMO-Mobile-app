import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'onboarding_screen3.dart';

class OnboardingScreen2 extends StatelessWidget {
  OnboardingScreen2({Key? key}) : super(key: key);

  final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xff009B4E),
      // Background color
      textStyle: const TextStyle(
        fontSize: 20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ));

  @override
  Widget build(BuildContext context) {
    int a = 10;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(

        alignment: Alignment.center,

        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 100, left: 20, right: 20),
              child: Center(
                child: Row(
                  children: [
                    Text(" Select Your",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 30,
                            color: Colors.black)),
                    Text(" Route",
                        style: TextStyle(

                            fontFamily: "Poppins",
                            fontSize: 30,
                            color: Color(0xff009B4E))),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Container(
                alignment: Alignment.center,

                child: const Text(
                    "Get quick access to frequent locations, and save them as a favritos",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 15,
                        color: Color(0xff739AF0))),
              ),
            )
            ,
            SizedBox(
              height: MediaQuery.of(context).size.width,
              child: Container(
                height:  MediaQuery.of(context).size.width,
                width: double.infinity,
                decoration: const BoxDecoration(
                  // borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      // fit: BoxFit.cover,
                      fit: BoxFit.fitWidth,

                      image: AssetImage('images/img_4.png'),
                    )),
              ),
            ),



            Padding(
              padding: const EdgeInsets.only(left: 260,bottom: 10),
              child: Card(
                elevation: 6.0,
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Container(
                    height: 40,
                    width: 100,
                    decoration: const BoxDecoration(
                        color:Color(0xff009B4E),
                        borderRadius: BorderRadius.horizontal(
                        )),
                    child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: ElevatedButton.icon(
                          style: style,
                          onPressed: () {

                            Navigator.pushReplacement(context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                duration: const Duration(milliseconds: 100),
                                child:  OnboardingScreen3(),
                              ),
                              // MaterialPageRoute(builder: (context) =>OnboardingScreen3(),),

                            );
                          },
                          icon: const Icon(
                            Icons.arrow_back,size: 20,
                          ),
                          label: const Text("Next"),
                          //.........
                        ))
                ),
              ),
            ),
          ],

        ),
      ),
    );
  }
}
