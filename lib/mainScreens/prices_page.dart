import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

import '../infoHandler/app_info.dart';

class PricesPage extends StatefulWidget {
  int seatsCount, bagsCount;
  PricesPage({required this.seatsCount,required this.bagsCount});

  @override
  State<PricesPage> createState() => _PricesPageState();
}

class _PricesPageState extends State<PricesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [



            //todo -- button
            Padding(
              padding: const EdgeInsets.only(right: 5, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.horizontal()),
                        child: const Center(
                            child: Text( "One Way",
                              style: TextStyle(
                                  color: Color(0xff739AEF),
                                  fontSize: 14,
                                  fontFamily: "Poppins"),
                            )),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 6.0,
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Container(
                      height: 29,
                      width: 94,
                      decoration: const BoxDecoration(
                          color: Color(0xff019EE3),
                          borderRadius: BorderRadius.horizontal()),
                      child: const Center(
                          child: Text(
                            "Return",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: "Poppins"),
                          )),
                    ),
                  ),
                ],
              ),
            ),


// source location
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                alignment: Alignment.topLeft,
                child: const Text("Source Location",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        color: Colors.black)),
              ),
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
                                padding:  EdgeInsets.only(left: 1),
                                child: Icon(Icons.location_on, color: Colors.white,),
                              ),
                               Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Center(
                                  child: Text(
                                    (Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).length > 30 ?
                                    "${(Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0,29)}..." :
                                    "${(Provider.of<AppInfo>(context).userPickUpLocation!.locationName!)}",
                                    style: const TextStyle(color: Colors.white,
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

            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                alignment: Alignment.topLeft,
                child: const Text("Drop Location",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        color: Colors.black)),
              ),
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
                            child: Icon(Icons.location_on, color: Colors.white,),
                          ),
                           Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Center(
                              child: Text(
                                  Provider.of<AppInfo>(context).userDropOffLocation!.locationName!.length > 30 ?
                                "${(Provider.of<AppInfo>(context).userDropOffLocation!.locationName!).substring(0,29)}...":
                                "${(Provider.of<AppInfo>(context).userDropOffLocation!.locationName!)}",
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
                          children: [
                            //text1
                            Row(
                              children:  [
                                const Text("Seats Count",style: TextStyle(color: Color(0xff019EE3)),),
                                Image.asset('images/seats.png',height: 15,)
                              ],
                            ),
                            // todo -- dropdown1
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: Color(0xff019EE3)),
                                  width: 80,
                                  height: 20,
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
                            children:  [
                              Text("Bags Count",style: TextStyle(color: Color(0xff019EE3)),),
                              Image.asset('images/bags.png',height: 15,)
                            ],
                          ),


                          // todo -- dropdown2
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: Color(0xff019EE3)),
                                width: 80,
                                height: 20,
                              child: DropdownButtonExample(),
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
      ),
    );
  }
}


class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  static List<int> list = <int>[ 1, 2, 3, 4, 5];
  static List<String> countries = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8"
  ];
  int dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: dropdownValue,
      dropdownColor: Color(0xff019EE3),
      //<-- SEE HERE

      icon: Expanded(
        child: Transform.rotate(
          angle: 90 * math.pi / 180,
          child: IconButton(
            icon: Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.white,
              size: 14,
            ),
            onPressed: null,
          ),
        ),
      ),
      elevation: 16,

      style: const TextStyle(color: Colors.white),
      underline: Container(),
      onChanged: (int? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },

      items: list.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(countries[value],),
          ),
        );
      }).toList(),
    );

  }
}

