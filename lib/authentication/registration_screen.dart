import 'dart:developer';

import 'package:amo_cabs/splashScreen/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../global/global.dart';
import '../../widgets/amo_toast.dart';
import '../models/user_model.dart';

// ignore: must_be_immutable
class RegistrationScreen extends StatefulWidget {
  String phoneNumber;
  User firebaseUser;
  RegistrationScreen(
      {super.key, required this.phoneNumber, required this.firebaseUser});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String? phoneNumber;
  TextEditingController txtFirstNameTextEditingController =
  TextEditingController();
  TextEditingController txtLastNameTextEditingController =
  TextEditingController();
  TextEditingController txtEmailTextEditingController = TextEditingController();

  checkInputFields() async {
    if (txtFirstNameTextEditingController.text.isEmpty) {
      AmoToast.showAmoToast('First name can\'t be empty.', context);
    } else if (txtFirstNameTextEditingController.text.length < 3) {
      AmoToast.showAmoToast('Invalid first name.', context);
    } else if (txtLastNameTextEditingController.text.isEmpty) {
      AmoToast.showAmoToast('Last name can\'t be empty.', context);
    } else if (txtLastNameTextEditingController.text.length < 3) {
      AmoToast.showAmoToast('Invalid last name.', context);
    } else {
      String firstName = txtFirstNameTextEditingController.text;
      String lastName = txtLastNameTextEditingController.text;
      String email = txtEmailTextEditingController.text.isEmpty
          ? ""
          : txtEmailTextEditingController.text;

      // var collectionRef = FirebaseFirestore.instance.collection("users");
      var collectionRef = FirebaseFirestore.instance.collection("allUsers").doc('customer').collection('customers');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userRole = prefs.getString('userType');
      log("===============");
      log(prefs.getString('userType').toString());
      try {
        await collectionRef.add({
          "active": true,
          "email": email,
          "firstName": firstName,
          "lastName": lastName,
          "fullName": "$firstName $lastName",
          "rideIds": [],
          "phoneNumber": phoneNumber,
          "role":"Customer",
          "totalRides": 0,
          "offer":"0",
          //your data which will be added to the collection and collection will be created after this
        }).then((_) async {
          log("collection created");
          AmoToast.showAmoToast('Registered succesfully.', context);
          final snapshot = await collectionRef
              .where("phoneNumber", isEqualTo: phoneNumber)
              .get();
          final userData =
              snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;

          userModelCurrentInfo = userData;
          currentFirebaseUser = widget.firebaseUser;
          await prefs.setStringList("userCurrentInfo", [
            userModelCurrentInfo!.id!,
            userModelCurrentInfo!.phoneNumber!,
            userModelCurrentInfo!.firstName!,
            userModelCurrentInfo!.lastName!,
            userModelCurrentInfo!.email!
          ]);

          debugPrint("take to login page");
          // ignore: use_build_context_synchronously
          AmoToast.showAmoToast('Loggin in..', context);

          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => const MySplashScreen(),
            ),
          );
        }).catchError((e) {
          log("$e an error occured");
        });
      } catch (e) {
        // ignore: use_build_context_synchronously
        AmoToast.showAmoToast('Something went wrong.', context);
      }
    }
  }

  final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xff009B4E),
      // Background color
      textStyle: const TextStyle(
        fontSize: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ));

  @override
  void initState() {
    phoneNumber = widget.phoneNumber;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60, left: 10),
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
                    "Register to AMO account to continue.",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        color: Color(0xff739AF0)),
                  ),
                ],
              ),
            ),

            //First Name text
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 30),
              child: Row(
                children: [
                  RichText(
                    text: const TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "First Name",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              color: Colors.black),
                        ),
                        TextSpan(
                            text: "*",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 16,
                                color: Color(0xff019EE3))),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Text  field

            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1, left: 22, right: 22),
                  child: Card(
                      elevation: 6.0,
                      color: Colors.white,
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Container(
                        height: 64,
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: TextField(
                                  controller: txtFirstNameTextEditingController,
                                  decoration: const InputDecoration(
                                    hintText: "Enter your first name",
                                    hintStyle: TextStyle(
                                        fontSize: 14, color: Color(0xffC1C1C1)),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),

                //last name text

                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 30),
                  child: Row(
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Last Name",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            TextSpan(
                                text: "*",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 16,
                                    color: Color(0xff019EE3))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //text field

                Padding(
                  padding: const EdgeInsets.only(top: 1, left: 22, right: 22),
                  child: Card(
                      elevation: 6.0,
                      color: Colors.white,
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Container(
                        height: 64,
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: TextField(
                                  controller: txtLastNameTextEditingController,
                                  decoration: const InputDecoration(
                                    hintText: "Enter your last name ",
                                    hintStyle: TextStyle(
                                        fontSize: 14, color: Color(0xffC1C1C1)),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),

                //Email address text
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 30),
                  child: Row(
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Email address",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            TextSpan(
                                text: "(Optional)",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14,
                                    color: Color(0xff009B4E))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 1, left: 22, right: 22),
                  child: Card(
                      elevation: 6.0,
                      color: Colors.white,
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Container(
                        height: 64,
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding:
                                const EdgeInsets.only(top: 10, left: 18),
                                child: TextField(
                                  controller: txtEmailTextEditingController,
                                  decoration: const InputDecoration(
                                    hintText: "Enter your Email address",
                                    hintStyle: TextStyle(
                                        fontSize: 14, color: Color(0xffC1C1C1)),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),

                //
              ],
            ),

            // registration button

            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Card(
                elevation: 6.0,
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  height: 50,
                  width: 218,
                  decoration: const BoxDecoration(
                      color: Color(0xff009B4E),
                      borderRadius: BorderRadius.horizontal()),
                  child: ElevatedButton(
                    style: style,
                    onPressed: () {
                      checkInputFields();
                    },
                    child: const Text("Register"),
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
