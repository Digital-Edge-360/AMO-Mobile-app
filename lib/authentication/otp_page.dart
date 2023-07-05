import 'dart:convert';

import 'package:amo_cabs/authentication/registration_screen.dart';
import 'package:amo_cabs/mainScreens/main_screen.dart';
import 'package:amo_cabs/widgets/amo_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:pinput/pinput.dart';

import '../../global/global.dart';
import '../models/user_model.dart';




class OtpPage extends StatefulWidget {
  String verificationId;
  String phoneNumber;
  OtpPage({required this.verificationId, required this.phoneNumber});
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {

  String? otpCode;
  String? phoneNumber;

  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // verify otp
  void verifyOtp(
      String verificationId,
      String userOtp,
      ) async {
    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
      User? firebaseUser = (await auth.signInWithCredential(creds)).user;
      if (firebaseUser != null) {
        
        final snapshot = await _db.collection("userDetails").where("phoneNumber", isEqualTo: phoneNumber).get();

        try{
          final userData = snapshot.docs.map(
                  (e) => UserModel.fromSnapshot(e)).single;
          print(userData.toString());

          userModelCurrentInfo = userData;
          debugPrint("take to login page");
          Fluttertoast.showToast(msg: 'Logging in..');

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => MainScreen(),
            ),
          );
        }
        catch(e){
          debugPrint(e.toString());

          debugPrint("taking to registration page");
          Fluttertoast.showToast(msg: 'Taking to registration page..');

          Navigator.push(context, MaterialPageRoute(builder: (c) => RegistrationScreen(phoneNumber: phoneNumber!,)));

          // Get.to(RegistrationScreen(), arguments: [phoneNumber]);

        }


      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: 'Error occured during sign in.');
      }

    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());

    }
  }

  @override
  void initState() {
    phoneNumber = widget.phoneNumber;
    super.initState();
  }


  void _login() {
    if (otpCode != null) {
      verifyOtp(widget.verificationId, otpCode!);
    } else {

      AmoToast.showAmoToast("Enter 6-Digit code", context);

    }
  }

  final ButtonStyle style = ElevatedButton.styleFrom(
      minimumSize: Size(188, 48),
      backgroundColor: const Color(0xff009B4E),
      elevation: 6,
      textStyle: const TextStyle(fontSize: 16),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          )));

  Widget buildText(String text) => Center(
    child: Text(
      text,
      style: TextStyle(fontSize: 24, fontFamily: "Poppins",color: Colors.black),
    ),
  );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      // backgroundColor: Color(0xff0F2B2F),
      // backgroundColor: Color(0xff215D5F),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 200),
              buildText('Enter 6 digit OTP'),
              buildText('sent to your number'),
              const SizedBox(height: 50),
              Pinput(
                length: 6,
                showCursor: true,
                defaultPinTheme: PinTheme(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: const Color(0xff2C474A),
                    ),
                  ),
                  textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                ),
                onCompleted: (value) {
                  setState(() {
                    otpCode = value;
                  });
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                  style: style,
                  onPressed: _login,
                  child: const Text(
                    'SIGN IN',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  )),
              const SizedBox(height: 80),
              const Text(
                "Didn't receive any code?",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _login,
                child: const Text(
                  "Resend new code",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}