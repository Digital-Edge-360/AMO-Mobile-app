import 'dart:developer';

import 'package:amo_cabs/authentication/registration_screen.dart';
import 'package:amo_cabs/mainScreens/main_screen.dart';
import 'package:amo_cabs/widgets/amo_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../global/global.dart';
import '../models/user_model.dart';
import '../onboardingScreens/login_as_screen.dart';
import '../widgets/progress_dialog.dart';

// ignore: must_be_immutable
class OtpPage extends StatefulWidget {
  String verificationId;
  String phoneNumber;
  bool? isAgent;

  OtpPage(
      {super.key,
      required this.verificationId,
      required this.phoneNumber,
      required this.isAgent});

  @override
  // ignore: library_private_types_in_public_api
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String? otpCode;
  String? phoneNumber;

  // final box = GetStorage('userDetails');

  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  saveUserTypeData() async {
    final SharedPreferences perfs = await SharedPreferences.getInstance();
    await perfs.setString("userType", widget.isAgent! ? "Agent" : "Customer");
  }

  // verify otp
  void verifyOtp(
    String verificationId,
    String userOtp,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Verifying OTP, please wait..",
      ),
    );

    try {
      final SharedPreferences perfs = await SharedPreferences.getInstance();
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
      User? firebaseUser = (await auth.signInWithCredential(creds)).user;
      // box.write('id', firebaseUser);
      // print(box.read('id'));
      if (firebaseUser != null) {
        // final snapshot = await _db
        //     .collection("users")
        //     .where("phoneNumber", isEqualTo: phoneNumber)
        //     .get();
        final snapshot = await _db
            .collection("allUsers")
            .doc('customer')
            .collection('customers')
            .where("phoneNumber", isEqualTo: phoneNumber)
            .get();

        try {
          final userData =
              snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
          log("User Data : $userData");

          userModelCurrentInfo = userData;
          currentFirebaseUser = firebaseUser;
          log(userModelCurrentInfo!.id!);
          await perfs.setStringList("userCurrentInfo", [
            userModelCurrentInfo!.id!,
            userModelCurrentInfo!.phoneNumber!,
            userModelCurrentInfo!.firstName!,
            userModelCurrentInfo!.lastName!,
            userModelCurrentInfo!.email!
          ]);

          final String? userRole = widget.isAgent! ? "Agent" : "Customer";

          if (userModelCurrentInfo!.active!) {
            await saveUserTypeData();
            debugPrint("take to login page");
            Fluttertoast.showToast(msg: 'Logging in..');

            // ignore: use_build_context_synchronously

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(),
              ),
              ModalRoute.withName('/'),
            );
          } else {
            debugPrint("user is blocked");
            Fluttertoast.showToast(
                msg: 'Your Id is not active. Please contact support.');

            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => LogInAsScreen()),
                ModalRoute.withName('/'));
          }

          debugPrint("Invalid user role. Aborting..");
          Fluttertoast.showToast(
              msg: 'Invalid role. Already registered with a different role.');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LogInAsScreen()),
              ModalRoute.withName('/'));
        } catch (e) {
          debugPrint(e.toString());
          debugPrint("taking to registration page");
          await saveUserTypeData();
          Fluttertoast.showToast(msg: 'Taking to registration page..');

          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => RegistrationScreen(
                phoneNumber: phoneNumber!,
                firebaseUser: firebaseUser,
              ),
            ),
          );

          // Get.to(RegistrationScreen(), arguments: [phoneNumber]);
        }
      } else {
        Fluttertoast.showToast(msg: 'Error occured during sign in.');
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: "${e.message.toString().substring(0, 60)}..");
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    phoneNumber = widget.phoneNumber;
    super.initState();
  }

  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Resending OTP, please wait..",
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
        // Navigator.push(context, MaterialPageRoute(builder: (c) => OtpPage(verificationId: verificationId, phoneNumber: phoneNumber)));
        await auth.signInWithCredential(credential);
        // authentication successful, do something
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void _login() {
    if (otpCode != null) {
      verifyOtp(widget.verificationId, otpCode!);
    } else {
      AmoToast.showAmoToast("Enter 6-Digit code", context);
    }
  }

  final ButtonStyle style = ElevatedButton.styleFrom(
      minimumSize: const Size(188, 48),
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
          style: const TextStyle(
              fontSize: 24, fontFamily: "Poppins", color: Colors.black),
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                onTap: () {
                  AmoToast.showAmoToast(
                      'Resending OTP, Please wait..', context);
                  signInWithPhoneNumber(widget.phoneNumber);
                },
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
