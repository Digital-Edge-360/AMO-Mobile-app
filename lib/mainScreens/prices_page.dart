import 'dart:developer';

import 'package:amo_cabs/models/directions.dart';
import 'package:amo_cabs/widgets/car_type_widget.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../infoHandler/app_info.dart';

// ignore: must_be_immutable
class PricesPage extends StatefulWidget {
  int seatsCount, bagsCount, distanceInMeters;
  bool rideByKm;

  PricesPage({
    super.key,
    required this.seatsCount,
    required this.bagsCount,
    required this.distanceInMeters,
    required this.rideByKm,
  });

  @override
  State<PricesPage> createState() => _PricesPageState();
}

class _PricesPageState extends State<PricesPage> {
  bool oneWay = true;

  double perKmMultiplierHatchBack = 0.01;
  double perKmMultiplierSedan = 0.012;
  double perKmMultiplierSuv = 0.015;

  var carTypes = ['Hatchback', 'Sedan', 'SUV'];

  var carTypesImages = [
    'images/hatchback.png',
    'images/img_24.png',
    'images/suv.png'
  ];

  var noOfSeatsAvailableByCarType = [3, 3, 6];
  var noOfBagStorageAvailableByCarType = [2, 4, 5];

  late Directions userPickUpLocation, userDropOffLocation;



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
                              color: oneWay
                                  ? const Color(0xff019EE3)
                                  : Colors.white,
                              borderRadius: const BorderRadius.horizontal()),
                          child: Center(
                              child: Text(
                            "One Way",
                            style: TextStyle(
                                color: oneWay
                                    ? Colors.white
                                    : const Color(0xff019EE3),
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
                            color:
                                oneWay ? Colors.white : const Color(0xff019EE3),
                            borderRadius: const BorderRadius.horizontal(),
                          ),
                          child: Center(
                            child: Text(
                              "Return",
                              style: TextStyle(
                                  color: oneWay
                                      ? const Color(0xff019EE3)
                                      : Colors.white,
                                  fontSize: 14,
                                  fontFamily: "Poppins"),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          oneWay = false;
                          log(oneWay.toString());
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
                                    // ignore: unnecessary_string_interpolations
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

// Drop Location --

              !widget.rideByKm
                  ? Container(
                      alignment: Alignment.topLeft,
                      child: const Text("Drop Location",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              color: Colors.black)),
                    )
                  : Container(),

              !widget.rideByKm
                  ? Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
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
                                        Provider.of<AppInfo>(context)
                                                    .userDropOffLocation!
                                                    .locationName!
                                                    .length >
                                                30
                                            ? "${(Provider.of<AppInfo>(context).userDropOffLocation!.locationName!).substring(0, 29)}..."
                                            // ignore: unnecessary_string_interpolations
                                            : "${(Provider.of<AppInfo>(context).userDropOffLocation!.locationName!)}",
                                        style: const TextStyle(
                                            color: Colors.white),
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
                    )
                  : Container(),

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
                      Expanded(
                        flex: 4,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //text1
                                Row(
                                  children: [
                                    const Text(
                                      "Seats Count",
                                      style: TextStyle(
                                        color: Color(0xff019EE3),
                                      ),
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
                                    style: const TextStyle(
                                        color: Color(0xff019EE3),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )),
                      ),

                      //
                      // todo -- line
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 30, left: 80),
                          child: Container(
                            height: 70,
                            width: 3,
                            color: const Color(0xffD0D0D0),
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 4,
                        child: Padding(
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.bagsCount.toString(),
                                  style: const TextStyle(
                                      color: Color(0xff019EE3),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 18,
              ),

              //total distance
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Total Distance: ${(widget.distanceInMeters / 1000).toString()} km",
                  style: const TextStyle(
                      fontFamily: "Poppins", fontSize: 16, color: Colors.black),
                ),
              ),

              const SizedBox(
                height: 18,
              ),

              //Expected prices
              Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  "Expected Prices:",
                  style: TextStyle(
                      fontFamily: "Poppins", fontSize: 16, color: Colors.black),
                ),
              ),

              SizedBox(
                height: 300,
                child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int i) {
                      log("index $i");
                      log("expected = ${widget.seatsCount}| available =${noOfSeatsAvailableByCarType[i]}");
                      log("expected = ${widget.bagsCount}| available =${noOfBagStorageAvailableByCarType[i]}");
                      // if(widget.seatsCount <= noOfSeatsAvailableByCarType[i] && widget.bagsCount <= noOfBagStorageAvailableByCarType[i]){
                      //   return null;
                      // }

                      return CarTypeWidget(
                        distanceInMeters: widget.distanceInMeters,
                        seatsCount: widget.seatsCount,
                        bagsCount: widget.seatsCount,
                        index: i,
                        isOneWay: oneWay,
                        rideByKm: widget.rideByKm,
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
