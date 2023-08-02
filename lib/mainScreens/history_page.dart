import 'dart:developer';

import 'package:amo_cabs/global/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool _isLoading = false;

  Stream<QuerySnapshot<Map<String, dynamic>>>? _data;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>>? get data => _data;

  bool get hasData => _data != null;

  void fetchHistory() async {
    try {
      _isLoading = true;
      _data = _firestore
          .collection("rideRequests")
          .where("customerId", isEqualTo: userModelCurrentInfo!.id)
          .orderBy("pickUpDate")
          .get()
          .asStream();
    } catch (e) {
      log(e.toString());
    } finally {
      _isLoading = false;
    }
  }

  List<String> filterOptions = [
    "all",
    "upcoming",
    "completed",
    "Pending",
    "rejected"
  ];

  String filter = "all";
  int filterIndex = 0;

  @override
  String? get location => null;

  @override
  String get screenName => "/ride_history";

  @override
  void initState() {
    fetchHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size windowSize = MediaQuery.sizeOf(context);

    Widget child;
    if (_isLoading) {
      child = Center(
        child: SizedBox(
          height: windowSize.height * 0.3,
          child: Lottie.asset("assets/lottie/cab_loading.json"),
        ),
      );
    } else if (hasData) {
      child = StreamBuilder(
          stream: data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data != null) {
              var docs = snapshot.data?.docs;
              log(docs.toString());
              return Column(
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.05,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.normal),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                filterIndex = 0;
                                filter = filterOptions[filterIndex];
                              });
                            },
                            child: Card(
                              color: filterIndex == 0
                                  ? Color(0xff009B4E)
                                  : Colors.white,
                              elevation: 4,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                child: Text(
                                  'All',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                filterIndex = 1;
                                filter = filterOptions[filterIndex];
                              });
                            },
                            child: Card(
                              color: filterIndex == 1
                                  ? Color(0xff009B4E)
                                  : Colors.white,
                              elevation: 4,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                child: Text('Upcoming'),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                filterIndex = 2;
                                filter = filterOptions[filterIndex];
                              });
                            },
                            child: Card(
                              color: filterIndex == 2
                                  ? Color(0xff009B4E)
                                  : Colors.white,
                              elevation: 4,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                child: Text('Completed'),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                filterIndex = 3;
                                filter = filterOptions[filterIndex];
                              });
                            },
                            child: Card(
                              color: filterIndex == 3
                                  ? Color(0xff009B4E)
                                  : Colors.white,
                              elevation: 4,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                child: Text('Pending'),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                filterIndex = 4;
                                filter = filterOptions[filterIndex];
                              });
                            },
                            child: Card(
                              color: filterIndex == 4
                                  ? Color(0xff009B4E)
                                  : Colors.white,
                              elevation: 4,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                child: Text('Cancelled'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.83,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: docs?.length,
                      itemBuilder: (context, index) {
                        log(docs?.elementAt(index).data()["status"]);
                        if (filter == "upcoming" &&
                            docs?.elementAt(index).data()["status"] ==
                                "upcoming") {
                          log("inside upcoming");

                          return _RideDetailsTile(
                            docs: docs,
                            index: index,
                          );
                        } else if (filter == "completed" &&
                            docs?.elementAt(index).data()["status"] ==
                                "completed") {
                          log("inside completed");
                          return _RideDetailsTile(
                            docs: docs,
                            index: index,
                          );
                        } else if (filter == "Pending" &&
                            docs?.elementAt(index).data()["status"] ==
                                "Pending") {
                          log("inside rejected");
                          return _RideDetailsTile(
                            docs: docs,
                            index: index,
                          );
                        } else if (filter == "completed" &&
                            docs?.elementAt(index).data()["status"] ==
                                "completed") {
                          log("inside completed");
                          return _RideDetailsTile(
                            docs: docs,
                            index: index,
                          );
                        } else if (filter == "all") {
                          log("inside all");
                          return _RideDetailsTile(
                            docs: docs,
                            index: index,
                          );
                        } else {
                          log("inside nothing");
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Container(
                  color: Colors.transparent,
                  height: windowSize.height * 0.3,
                  child: Lottie.asset("assets/lottie/cab_loading.json"),
                ),
              );
            }
          });
    } else {
      child = const Center(
        child: Text('data'),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: child,
    );
  }
}

class _RideDetailsTile extends StatelessWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>>? docs;
  final int index;
  const _RideDetailsTile({
    Key? key,
    required this.docs,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size windowSize = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: windowSize.height * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "On ${DateFormat.yMMMd().add_jm().format((docs?.elementAt(index).data()["pickUpDate"] as Timestamp).toDate())}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: windowSize.height * 0.008),
          Stack(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                child: Container(
                  height: windowSize.height * 0.35,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 13.0, vertical: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.ideographic,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: windowSize.width * 0.06,
                                  backgroundColor: Colors.blue,
                                  child: Icon(
                                    Icons.car_rental,
                                    color: Colors.white,
                                    size: windowSize.width * 0.1,
                                  ),
                                ),
                                SizedBox(width: windowSize.width * 0.02),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("4ABC123"),
                                    Text('Audi Q7'),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Booking ID:',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(docs!.elementAt(index)!.id!.toString()),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25.0),
                                        topRight: Radius.circular(25.0),
                                      ),
                                    ),
                                    context: context,
                                    builder: (context) => _SupportSheet(
                                      docs: docs,
                                      index: index,
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.info_outline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: windowSize.height * 0.029),
                        docs?.elementAt(index).data()["isOneWay"] == true
                            ? Text(
                                "One Way Trip",
                              )
                            : Text(
                                "Round Trip",
                              ),
                        Expanded(
                          child: Row(
                            children: [
                              IconStepper(
                                enableNextPreviousButtons: false,
                                enableStepTapping: false,
                                direction: Axis.vertical,
                                stepRadius: 10,
                                stepPadding: 2,
                                activeStepBorderPadding: 0,
                                lineLength: windowSize.height * 0.079,
                                icons: const [
                                  Icon(Icons.location_pin, color: Colors.white),
                                  Icon(Icons.location_pin, color: Colors.black),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14.0),
                                child: SizedBox(
                                  width: windowSize.width * 0.5,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    ///Ride by km or ride by destination
                                    ///one way or two way
                                    children: [
                                      docs
                                                  ?.elementAt(index)
                                                  .data()["pickUp"]
                                                      ["pickUpName"]
                                                  .length >
                                              45
                                          ? Text(
                                              "${"${docs?.elementAt(index).data()["pickUp"]["pickUpName"]}".substring(0, 45)}...")
                                          : Text(
                                              "${docs?.elementAt(index).data()["pickUp"]["pickUpName"]}"),
                                      SizedBox(
                                          height: windowSize.height * 0.02),
                                      docs
                                                  ?.elementAt(index)
                                                  .data()["dropOff"]
                                                      ["dropOffName"]
                                                  .toString() !=
                                              ""
                                          ? docs
                                                      ?.elementAt(index)
                                                      .data()["dropOff"]
                                                          ["dropOffName"]
                                                      .length >
                                                  45
                                              ? Text(
                                                  "${"${docs?.elementAt(index).data()["dropOff"]["dropOffName"]}".substring(0, 45)}...")
                                              : Text(
                                                  "${docs?.elementAt(index).data()["dropOff"]["dropOffName"]}")
                                          : Text(
                                              "${((int.tryParse(docs!.elementAt(index).data()["distanceInMeters"].toString()))! / 1000).toDouble()} kms",
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "Total Fare: ₹${double.tryParse(docs!.elementAt(index).data()["price"].toString())?.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SupportSheet extends StatelessWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>>? docs;
  final int index;
  const _SupportSheet({
    Key? key,
    required this.docs,
    required this.index,
  }) : super(key: key);

  static Future<void> makePhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: "7811822499",
    );
    await launchUrl(launchUri);
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    String appleUrl = 'https://maps.apple.com/?sll=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      log("Launching Google maps");
      await launchUrl(
        Uri.parse(googleUrl),
        mode: LaunchMode.externalApplication,
      );
    } else if (await canLaunchUrl(Uri.parse(appleUrl))) {
      log("Launching apple maps");
      await launchUrl(
        Uri.parse(appleUrl),
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size windowSize = MediaQuery.sizeOf(context);
    return SizedBox(
      height: windowSize.height * 0.4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: windowSize.width * 0.1),
                Text(
                  "${docs?.elementAt(index).data()["customerName"]}",
                ),
                const CloseButton(),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  IconStepper(
                    enableNextPreviousButtons: false,
                    enableStepTapping: false,
                    direction: Axis.vertical,
                    stepRadius: 10,
                    stepPadding: 2,
                    activeStepBorderPadding: 0,
                    lineLength: windowSize.height * 0.1,
                    icons: const [
                      Icon(Icons.location_pin, color: Colors.white),
                      Icon(Icons.location_pin, color: Colors.black),
                    ],
                  ),
                  SizedBox(
                    width: windowSize.width * 0.8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 29.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "${docs?.elementAt(index).data()["pickUp"]["pickUpName"]}"),
                          Text(
                            "${((int.tryParse(docs!.elementAt(index).data()["distanceInMeters"].toString()))! / 1000).toDouble()} kms",
                          ),
                          Text(
                              "${docs?.elementAt(index).data()["dropOff"]["dropOffName"]}"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        makePhoneCall();
                      },
                      child: Container(
                        width: windowSize.width * 0.45,
                        child: Row(
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.call,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(
                                'Contact Support',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => ReportDialogBox(),
                        );
                      },
                      child: Container(
                        width: windowSize.width * 0.45,
                        child: Row(
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.report,
                                color: Colors.red,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Report Rider",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportDialogBox extends StatefulWidget {
  ReportDialogBox({
    super.key,
  });

  @override
  State<ReportDialogBox> createState() => _ReportDialogBoxState();
}

class _ReportDialogBoxState extends State<ReportDialogBox> {
  bool checkedViolence = false;

  bool checkedHateSpeech = false;

  bool checkedGotIntoAFight = false;

  bool checkedAbuse = false;

  @override
  Widget build(BuildContext context) {
    Size windowSize = MediaQuery.sizeOf(context);

    return AlertDialog(
      title: const Text("Please select a reason to report"),
      titleTextStyle: TextStyle(
        color: Colors.black,
      ),
      content: SizedBox(
        height: windowSize.height * 0.25,
        width: windowSize.width * 0.7,
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  activeColor: Colors.green,
                  value: checkedViolence,
                  onChanged: (bool? value) {
                    setState(() {
                      checkedViolence = value ?? false;
                    });
                  },
                ),
                const Text('Violence'),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  activeColor: Colors.green,
                  value: checkedHateSpeech,
                  onChanged: (bool? value) {
                    setState(() {
                      checkedHateSpeech = value ?? false;
                    });
                  },
                ),
                const Text('Hate Speech'),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  activeColor: Colors.green,
                  value: checkedAbuse,
                  onChanged: (bool? value) {
                    setState(() {
                      checkedAbuse = value ?? false;
                    });
                  },
                ),
                const Text('Abuse'),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  activeColor: Colors.green,
                  value: checkedGotIntoAFight,
                  onChanged: (bool? value) {
                    setState(() {
                      checkedGotIntoAFight = value ?? false;
                    });
                  },
                ),
                const Text('Got into a fight'),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Center(
            child: Text("Report"),
          ),
        ),
      ],
    );
  }
}
