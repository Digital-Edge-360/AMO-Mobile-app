import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';
import '../splashScreen/splash_screen.dart';
import '../widgets/progress_dialog.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  FToast toast = FToast();

  validateForms() {
    //print(emailTextEditingController.text.contains("@"));
    if (nameTextEditingController.text.length < 3) {
      // Fluttertoast.showToast(
      //   msg: 'Name must be atleast 3 characters',
      // );
      toast.showToast(
        child: const Text(
          'Name must be atleast 3 characters',
          style: TextStyle(color: Colors.white54),
        ),
      );
    } else if (!emailTextEditingController.text.contains("@")) {
      toast.showToast(
        child: const Text(
          'Email id is invalid',
          style: TextStyle(color: Colors.white54),
        ),
      );
    } else if (phoneTextEditingController.text.length < 10) {
      toast.showToast(
        child: const Text(
          'Phone Number invalid',
          style: TextStyle(color: Colors.white54),
        ),
      );
    } else if (passwordTextEditingController.text.length < 6) {
      toast.showToast(
        child: const Text(
          'Password must be atleast 6 characters',
          style: TextStyle(color: Colors.white54),
        ),
      );
    } else {
      saveUserInfoNow();
    }
  }

  saveUserInfoNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(message: 'Signing up, please wait..');
        });

    final User? firebaseUser = (await fAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text.trim(),
                password: passwordTextEditingController.text.trim())
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Error: $msg');
      return msg;

      ///Always add return statements while handling errors
    }))
        .user;
    if (firebaseUser != null) {
      Map userMap = {
        'id': firebaseUser.uid,
        'name': nameTextEditingController.text.trim(),
        'email': emailTextEditingController.text.trim(),
        'phone': phoneTextEditingController.text.trim(),
      };

      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users');
      userRef.child(firebaseUser.uid).set(userMap);

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: 'Account created sucessfully.');

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (c) => const MySplashScreen(),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Account has not been created.');
    }
  }

  @override
  void initState() {
    super.initState();
    toast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset('images/logo.png'),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Register as a user',
                style: TextStyle(
                    fontSize: 26,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: nameTextEditingController,
                style: const TextStyle(color: Colors.grey),
                decoration: const InputDecoration(
                  label: Text('Name'),
                  hintText: "Name",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.grey),
                decoration: const InputDecoration(
                  label: Text('Email'),
                  hintText: "Email",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              TextField(
                controller: phoneTextEditingController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.grey),
                decoration: const InputDecoration(
                  label: Text('Phone'),
                  hintText: "Phone",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              TextField(
                controller: passwordTextEditingController,
                obscureText: true,
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.grey),
                decoration: const InputDecoration(
                  label: Text('Password'),
                  hintText: "Password",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreenAccent),
                  onPressed: () {
                    validateForms();
                  },
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18.0,
                    ),
                  )),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  LoginScreen(isAgent: false,),
                    ),
                  );
                },
                child: const Text(
                  'Already have an account. Login here',
                  style: TextStyle(
                    color: Colors.grey,
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
