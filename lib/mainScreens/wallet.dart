import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../global/global.dart';

class WallatPage extends StatefulWidget {
  const WallatPage({super.key});

  @override
  State<WallatPage> createState() => _WallatPageState();
}

class _WallatPageState extends State<WallatPage> {
  @override
  void initState() {
    super.initState();
    getride();
  }

  static const _backgroundColor = Colors.white;
  //static const _backgroundColor = Color(0xFFF15BB5);

  static const _colors = [
    Color(0xF1131E5),
    Color(0xFF00BBF9),
  ];

  static const _durations = [
    5000,
    4000,
  ];

  static const _heightPercentages = [
    0.65,
    0.66,
  ];

  int walletAdd = 0;
  @override
  Widget build(BuildContext context) {

    return Material(
      child: Scaffold(
        body: Padding(
          padding:  EdgeInsets.only(top: 60, left: 20, right: 20),
          child: Card(
            elevation: 6.0,
            color: Color(0xFF00BBF9),
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              height: 400,
              width: MediaQuery.of(context).size.width,
              decoration:  const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(20),
                  )),
              child: Column(
                children: [
                  Expanded(
                    child: Lottie.network(
                        'https://lottie.host/d2b6ec6e-fce5-4da7-87df-bf5788d5dd93/IhMnIEU0XN.json'),
                  ),
                  Text(
                    "Wallet: $walletAdd",
                    style: const TextStyle(fontFamily: "Poppins", fontSize: 20),
                  ),
                  Expanded(
                    child: WaveWidget(
                      config: CustomConfig(
                        colors: _colors,
                        durations: _durations,
                        heightPercentages: _heightPercentages,
                      ),
                      size: Size(double.infinity, double.infinity),
                      waveAmplitude: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),

        ),
      ),
    );
  }

  getride() async {
    //userModelCurrentInfo
    log("Ride Requests");
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("rideRequests").get();
//sub-patch
    for (int i = 0; i < querySnapshot.size; i++) {
      var a = querySnapshot.docs[i];
      String? uid = userModelCurrentInfo!.id;
      log(a.id);
      String cutomerId = a["customerId"];
      log(cutomerId);

      if (uid == cutomerId) {
        int addnum = int.parse(a['commission']);
        walletAdd += addnum;
        log("wallet: ${a['commission']}");

        setState(() {});
      } else {
        log("Not Show");
      }
    }
  }
}
