import 'dart:developer';

import 'package:amo_cabs/authentication/otp_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/amo_toast.dart';
import '../widgets/progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //phone number Screen
  TextEditingController txtCountryCodeTextEditingController =
  TextEditingController();
  TextEditingController txtPhoneTextEditingController = TextEditingController();

  final ButtonStyle style = ElevatedButton.styleFrom(
      elevation: 6,
      backgroundColor: const Color(0xff009B4E),
      // Background color
      textStyle: const TextStyle(
        fontSize: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ));

  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Sending OTP, please wait..",
      ),
    );

    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // authentication successful, do something
      },
      verificationFailed: (FirebaseAuthException e) {
        log("Something went wrong. $e");
      },
      codeSent: (String verificationId, int? resendToken) async {
        // code sent to phone number, save verificationId for later use
        String smsCode = ''; // get sms code from user
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => OtpPage(
              verificationId: verificationId,
              phoneNumber: phoneNumber,
            ),
          ),
        );
        await auth.signInWithCredential(credential);
        // authentication successful, do something
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  void initState() {
    txtCountryCodeTextEditingController.text = "+91";
    super.initState();
  }

  bool checkNumber() {
    if (txtPhoneTextEditingController.text.isEmpty) {
      AmoToast.showAmoToast('Phone number can\'t be empty.', context);
    } else if (txtPhoneTextEditingController.text.length < 10) {
      AmoToast.showAmoToast('Invalid Phone number.', context);
    } else if (txtPhoneTextEditingController.text.length == 10) {
      return true;
    } else {
      AmoToast.showAmoToast('Something went wrong.', context);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 120, left: 10),
              child: Row(
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
            ),

            const Padding(
              padding: EdgeInsets.only(left: 10, top: 20),
              child: Row(
                children: [
                  Text(
                    "Enter your phone number to continue..",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        color: Color(0xff739AF0)),
                  ),
                ],
              ),
            ),

            //phone text
            Padding(
              padding: const EdgeInsets.only(top: 60, left: 26),
              child: Row(
                children: [
                  RichText(
                    text: const TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "Phone Number:",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              color: Colors.black),
                        ),
                        TextSpan(
                            text: "*",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 20,
                                color: Color(0xff86DD8A))),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                height: 60,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  elevation: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 40,
                        child: TextField(
                          controller: txtCountryCodeTextEditingController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(4),
                          ],
                          style: const TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              color: Colors.black),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const Text(
                        "|",
                        style: TextStyle(fontSize: 33, color: Colors.grey),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: TextField(
                            maxLength: 10,
                            autofocus: true,
                            enableSuggestions: true,
                            controller: txtPhoneTextEditingController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 18,
                                color: Colors.black),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Phone",
                              counterText: "",
                              hintStyle: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 18,
                                  color: Colors.grey),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),

            //todo---button

            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Card(
                elevation: 6.0,
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  height: 45,
                  width: 210,
                  decoration: const BoxDecoration(
                      color: Color(0xff009B4E),
                      borderRadius: BorderRadius.horizontal()),
                  child: ElevatedButton(
                    style: style,
                    onPressed: () async {
                      if (checkNumber()) {
                        signInWithPhoneNumber(
                            txtCountryCodeTextEditingController.text +
                                txtPhoneTextEditingController.text);

                        // Navigator.push(
                        //   context,
                        //   PageTransition(
                        //     type: PageTransitionType.theme,
                        //     duration: Duration(milliseconds: 500),
                        //     child: OtpScreen(),
                        //     isIos: true,
                        //   ),
                        // );
                      }
                    },
                    child: const Text("Login"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
