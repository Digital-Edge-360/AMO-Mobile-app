import 'dart:developer';

import 'package:amo_cabs/mainScreens/prices_page.dart';
import 'package:flutter/material.dart';

import '../global/global.dart';

class RideByKm extends StatefulWidget {
  const RideByKm({Key? key}) : super(key: key);

  @override
  State<RideByKm> createState() => _RideByKmState();
}

class _RideByKmState extends State<RideByKm> {
  int km = 0;
  bool openNavigationDrawer = true;
  GlobalKey<ScaffoldState> tKey = GlobalKey<ScaffoldState>();

  int seatsCount = 1;
  int bagsCount = 1;
  String? userName;
  String? userLastName;
  String? userPhone;

  assignUserName() async {
    try {
      userName = userModelCurrentInfo!.firstName!;
      userLastName = userModelCurrentInfo!.lastName!;
      userPhone = userModelCurrentInfo!.phoneNumber!;
      log("name is $userName");
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    assignUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: tKey,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 80,
            ),
// Drop Location --

            Container(
              alignment: Alignment.topLeft,
              child: const Text("Kilometer Range",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12,
                      color: Colors.black)),
            ),

            Slider(
                value: km.toDouble() / 500.0,
                divisions: 500,
                onChanged: (val) {
                  setState(() {
                    km = (val * 500).toInt();
                  });
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "$km kilometers",
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: Card(
                elevation: 8.0,
                color: Colors.white,
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Color(0xffD0D0D0)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //text1
                            Row(
                              children: [
                                const Text(
                                  "Seats Count",
                                  style: TextStyle(color: Color(0xff019EE3)),
                                ),
                                Image.asset(
                                  'images/seats.png',
                                  height: 15,
                                )
                              ],
                            ),
                            // todo -- dropdown1
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: const Color(0xff019EE3)),
                                // width: 80,
                                height: 20,
                                child: DropdownButton<int>(
                                  icon: Row(
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        seatsCount.toString(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down_sharp,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                  items:
                                      <int>[1, 2, 3, 4, 5, 6].map((int value) {
                                    return DropdownMenuItem<int>(
                                      value: value,
                                      child: Text(
                                        value.toString(),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newVal) {
                                    setState(() {
                                      seatsCount = newVal!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        )),

                    //
                    // todo -- line
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 80),
                      child: Container(
                        height: 70,
                        width: 1,
                        color: const Color(0xffD0D0D0),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Bags Count",
                                style: TextStyle(color: Color(0xff019EE3)),
                              ),
                              Image.asset(
                                'images/bags.png',
                                height: 15,
                              )
                            ],
                          ),

                          // todo -- dropdown2
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: const Color(0xff019EE3)),
                              // width: 80,
                              height: 20,
                              child: DropdownButton<int>(
                                icon: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      bagsCount.toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    const Icon(
                                      Icons.arrow_drop_down_sharp,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                items: <int>[1, 2, 3, 4, 5].map((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(
                                      value.toString(),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newVal) {
                                  setState(() {
                                    bagsCount = newVal!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Spacer(),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => PricesPage(
                      seatsCount: seatsCount,
                      bagsCount: bagsCount,
                      distanceInMeters: km * 1000,
                      rideByKm: true,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Request a Ride'),
            ),

            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
