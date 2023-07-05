import 'dart:developer';

import 'package:amo_cabs/mainScreens/booking_confirmation_page.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

import '../infoHandler/app_info.dart';

class PricesPage extends StatefulWidget {
  int seatsCount, bagsCount, distanceInMeters;

  PricesPage({required this.seatsCount, required this.bagsCount, required this.distanceInMeters});

  @override
  State<PricesPage> createState() => _PricesPageState();
}

class _PricesPageState extends State<PricesPage> {
  bool oneWay = true;

  double perKmMultiplierHatchBack = 0.01;
  double perKmMultiplierSedan = 0.012;
  double perKmMultiplierSuv = 0.015;




  @override
  Widget build(BuildContext context) {
    log("distance = ${widget.distanceInMeters}");
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              //todo -- button
              Padding(
                padding: const EdgeInsets.only(right: 5, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Card(
                        elevation: 5.0,
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Container(
                          height: 29,
                          width: 94,
                          decoration: BoxDecoration(
                              color: oneWay ? Color(0xff019EE3) : Colors.white,
                              borderRadius: BorderRadius.horizontal()),
                          child: Center(
                              child: Text(
                            "One Way",
                            style: TextStyle(
                                color: oneWay ? Colors.white : Color(0xff019EE3),
                                fontSize: 14,
                                fontFamily: "Poppins"),
                          )),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          oneWay = true;
                        });
                      },
                    ),
                    GestureDetector(
                      child: Card(
                        elevation: 6.0,
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Container(
                          height: 29,
                          width: 94,
                          decoration: BoxDecoration(
                            color: oneWay ? Colors.white : Color(0xff019EE3),
                            borderRadius: BorderRadius.horizontal(),
                          ),
                          child: Center(
                            child: Text(
                              "Return",
                              style: TextStyle(
                                  color:
                                      oneWay ? Color(0xff019EE3) : Colors.white,
                                  fontSize: 14,
                                  fontFamily: "Poppins"),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          oneWay = false;
                          print(oneWay);
                        });
                      },
                    ),
                  ],
                ),
              ),

// source location
              Container(
                alignment: Alignment.topLeft,
                child: const Text("Source Location",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        color: Colors.black)),
              ),

              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Card(
                      elevation: 6.0,
                      color: const Color(0xff009B4E),
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 40,
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 1),
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Center(
                                    child: Text(
                                      (Provider.of<AppInfo>(context)
                                                      .userPickUpLocation!
                                                      .locationName!)
                                                  .length >
                                              30
                                          ? "${(Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0, 29)}..."
                                          : "${(Provider.of<AppInfo>(context).userPickUpLocation!.locationName!)}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          overflow: TextOverflow.ellipsis),
                                      //like app --
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
                ],
              ),

// Drop Location --

              Container(
                alignment: Alignment.topLeft,
                child: const Text("Drop Location",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        color: Colors.black)),
              ),

// todo ---- location bar

              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Card(
                  elevation: 6.0,
                  color: const Color(0xff009B4E),
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 40,
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 1),
                              child: Icon(
                                Icons.location_on,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Center(
                                child: Text(
                                  Provider.of<AppInfo>(context)
                                              .userDropOffLocation!
                                              .locationName!
                                              .length >
                                          30
                                      ? "${(Provider.of<AppInfo>(context).userDropOffLocation!.locationName!).substring(0, 29)}..."
                                      : "${(Provider.of<AppInfo>(context).userDropOffLocation!.locationName!)}",
                                  style: TextStyle(color: Colors.white),
                                  //like app --
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

              // todo-- Seats Count & bags count

              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
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
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.seatsCount.toString(),
                                  style: TextStyle(
                                      color: Color(0xff019EE3), fontSize: 16),
                                ),
                              ),
                            ],
                          )),

                      //
                      // todo -- line
                      Padding(
                        padding: const EdgeInsets.only(right: 30, left: 80),
                        child: Container(
                          height: 70,
                          width: 1,
                          color: Color(0xffD0D0D0),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
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
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.bagsCount.toString(),
                                style: TextStyle(
                                    color: Color(0xff019EE3), fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              const SizedBox(height: 12,),


              //total distance
              Container(
                alignment: Alignment.topLeft,
                child:  Text("Total Distance: ${(widget.distanceInMeters/1000).toString()} km",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        color: Colors.black)),
              ),


              const SizedBox(height: 12,),
              //Expected prices
              Container(
                alignment: Alignment.topLeft,
                child: const Text("Expected Prices:",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        color: Colors.black)),
              ),

              Card(
                elevation: 5,

                child: ListTile(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c) => BookingConfirmation(price: ((widget.distanceInMeters * perKmMultiplierHatchBack).toInt()),),),);
                  },
                  leading: Image.asset("images/hatchback.png", height: 20,),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Hatchback',
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        'images/seats.png',
                        height: 12,
                      ),
                      const Text(
                        '3',
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        'images/bags.png',
                        height: 12,
                      ),
                      const Text(
                        '3',
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            color: Colors.black),
                      ),

                      const SizedBox(width: 10,),



                    ],
                  ),
                  trailing:  Text(
                    '₹${(widget.distanceInMeters * perKmMultiplierHatchBack).toString().split('.')[0]}.',
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 18,
                        color: Colors.black),
                  ),
                ),
              ),
              Card(
                elevation: 5,

                child: ListTile(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c) => BookingConfirmation(price: ((widget.distanceInMeters * perKmMultiplierSedan).toInt()),),),);

                  },
                  leading: Image.asset("images/img_24.png", height: 20),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sedan',
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        'images/seats.png',
                        height: 12,
                      ),
                      const Text(
                        '3',
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        'images/bags.png',
                        height: 12,
                      ),
                      const Text(
                        '5',
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            color: Colors.black),
                      ),

                      const SizedBox(width: 10,),



                    ],
                  ),
                  trailing:  Text(
                    '₹${(widget.distanceInMeters * perKmMultiplierSedan).toInt().toString()}.',
                    style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 18,
                        color: Colors.black),
                  ),
                ),
              ),
              Card(
                elevation: 5,

                child: ListTile(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c) => BookingConfirmation(price: ((widget.distanceInMeters * perKmMultiplierSuv).toInt()),),),);

                  },
                  leading: Image.asset("images/suv.png", height: 20),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'SUV',
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        'images/seats.png',
                        height: 12,
                      ),
                      const Text(
                        '6',
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        'images/bags.png',
                        height: 12,
                      ),
                      const Text(
                        '5',
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            color: Colors.black),
                      ),

                      const SizedBox(width: 10,),



                    ],
                  ),
                  trailing:  Text(
                    '₹${(widget.distanceInMeters * perKmMultiplierSuv).toString().split('.')[0]}.',
                    style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 18,
                        color: Colors.black),
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

