import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../authentication/login_screen.dart';
class OnboardingScreen5 extends StatelessWidget {
  OnboardingScreen5({Key? key}) : super(key: key);

  final ButtonStyle style = ElevatedButton.styleFrom(
      primary: Color(0xff009B4E),
      // Background color
      textStyle: const TextStyle(
        fontSize: 20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,

          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
                child: Center(
                  child: Container(
                    child: Row(
                      children: [

                        Text(" Saelect Your",
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
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: Container(
                  alignment: Alignment.center,

                  child: Text(
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
                padding: const EdgeInsets.only(top:00,left: 260),
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

                              Navigator.pushReplacement(

                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 100),
                                  child: LoginScreen(),
                                ),



                              );

                            },
                            icon: Icon(
                              Icons.arrow_back,size: 20,
                            ),
                            label: Text("Next"),
                            //.........
                          ))
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
