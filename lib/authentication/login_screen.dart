import 'package:amo_cabs/authentication/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';
import '../splashScreen/splash_screen.dart';
import '../widgets/progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  FToast toast = FToast();
  validateForms() {
    //print(emailTextEditingController.text.contains("@"));

    if (!emailTextEditingController.text.contains("@")) {
      toast.showToast(
        child: Text(
          'Email id is invalid',
          style: TextStyle(color: Colors.white54),
        ),
      );
    } else if (passwordTextEditingController.text.isEmpty) {
      toast.showToast(
        child: Text(
          'Password can\'t be empty.',
          style: TextStyle(color: Colors.white54),
        ),
      );
    } else {
      loginUserNow();
    }
  }

  loginUserNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(message: 'Logging in, please wait..');
        });

    final User? firebaseUser = (await fAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text.trim(),
                password: passwordTextEditingController.text.trim())
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Error: ' + msg.toString());
    }))
        .user;
    if (firebaseUser != null) {
      DatabaseReference driverRef =
          FirebaseDatabase.instance.ref().child('users');
      driverRef.child(firebaseUser.uid).once().then((driverKey) {
        final snap = driverKey.snapshot;
        if (snap.value != null) {
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: 'Logged in.');

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => const MySplashScreen(),
            ),
          );
        } else {
          Fluttertoast.showToast(msg: 'No record exist with this email');
          fAuth.signOut();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => const MySplashScreen(),
            ),
          );
        }
      });
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Error occured during sign in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset('images/logo.png'),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Login as a User',
                style: TextStyle(
                    fontSize: 26,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
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
                style:
                    ElevatedButton.styleFrom(primary: Colors.lightGreenAccent),
                onPressed: () {
                  validateForms();
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18.0,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(),
                    ),
                  );
                },
                child: Text(
                  'Don\'t have an account. Register here',
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
