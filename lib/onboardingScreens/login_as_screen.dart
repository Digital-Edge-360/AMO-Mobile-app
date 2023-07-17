import 'package:amo_cabs/authentication/login_screen.dart';
import 'package:flutter/material.dart';

class LogInAsScreen extends StatelessWidget {
  const LogInAsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "Welcome to",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 30,
                        color: Colors.black),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Image.asset(
                      "images/img_7.png",
                      height: 50,
                      width: 50,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Select an AMO account type to continue..',
                style: TextStyle(
                    fontFamily: "Poppins", fontSize: 14, color: Colors.blue),
              ),
              const SizedBox(
                height: 10,
              ),


              //login as customer card
              GestureDetector(
                onTap: (){
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen(isAgent: false)),
                      ModalRoute.withName('/'));
                  
                },
                child: Card(
                  elevation: 5,
                  color: Color(0xffF2FFF9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Login as Customer',
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 10,),
                        CircleAvatar(
                          radius: 60,
                          child: Image.asset("images/agent.png", height: 90,),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18,),


              //login as agent card
              GestureDetector(
                onTap: (){
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen(isAgent: true)),
                      ModalRoute.withName('/'));
                },
                child: Card(
                  elevation: 5,
                  color: Color(0xffE4EDFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [


                        CircleAvatar(
                          radius: 60,
                          child: Image.asset("images/agent.png", height: 90,),
                        ),
                        const SizedBox(width: 10,),

                        const Text(
                          'Login as Agent',
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
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
