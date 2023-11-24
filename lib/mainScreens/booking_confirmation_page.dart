import 'dart:developer';

import 'package:amo_cabs/global/global.dart';
import 'package:amo_cabs/mainScreens/thank_you_screen.dart';
import 'package:amo_cabs/models/user_model.dart';
import 'package:amo_cabs/widgets/amo_toast.dart';
import 'package:amo_cabs/widgets/car_type_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../infoHandler/app_info.dart';
import '../models/directions.dart';
import '../widgets/progress_dialog.dart';

// ignore: must_be_immutable
class BookingConfirmation extends StatefulWidget {
  int distanceInMeters, bagsCount, seatsCount, index;
  double price;

  double realPrice;


  bool isOneWay, rideByKm, isEv;

  String getoffer;


  BookingConfirmation(
      {super.key,
        required this.price,
        required this.realPrice,
        required this.isEv,
        required this.distanceInMeters,
        required this.bagsCount,
        required this.seatsCount,
        required this.index,
        required this.isOneWay,
        required this.rideByKm,
        required this.getoffer});

  @override
  State<BookingConfirmation> createState() => _BookingConfirmationState();
}

class _BookingConfirmationState extends State<BookingConfirmation> {
  DateTime? _selectedDatePickUp = DateTime.now();
  TimeOfDay _selectedTimePickUp = TimeOfDay.now();

  DateTime? _selectedDateReturnPickUp = DateTime.now();
  TimeOfDay _selectedTimeReturnPickUp = TimeOfDay.now();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final successSnackBar = const SnackBar(
    content: Text('Request sent sucessfully!'),
  );
  String dropdownValue= "Cash";


  late String price;

  double priceInDouble = 0;
  String? addedRideId;

  Directions? pickUp;
  Directions? dropOff;

  //coupon one time run method

  int couponRun = 0;

  //wrong coupon code
  int wrongCoupon=0;

  int offCutText =0;


  //offfer -500


  sendRideRequest() async{


    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Sending ride requests, please wait..",
      ),
    );
    var origin =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    pickUp = origin;
    var destination =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    dropOff = destination;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String>? userDetails = prefs.getStringList('userCurrentInfo');
    //var pickUpMap = {'sourceName' : origin!.locationName, 'userPickupLatitude': origin!.locationLatitude, 'use' }
    var currentRideDetails = {
      "pickUp": {
        "pickUpName": origin!.locationName!,
        "pickUpId": origin.locationId,
        "pickUpLatitude": origin.locationLatitude,
        "pickUpLongitude": origin.locationLongitude,
        "pickUpHumanReadableAddress": origin.humanReadableAddress
      },
      "dropOff": widget.rideByKm
          ? {
        "dropOffName": '',
        "dropOffId": '',
        "dropOffLatitude": '',
        "dropOffLongitude": '',
        "dropOffHumanReadableAddress": ''
      }
          : {
        "dropOffName": destination!.locationName!,
        "dropOffId": destination.locationId,
        "dropOffLatitude": destination.locationLatitude,
        "dropOffLongitude": destination.locationLongitude,
        "dropOffHumanReadableAddress": destination.humanReadableAddress
      },
      "distanceInMeters": widget.distanceInMeters,
      "customerName":
      userDetails != null ? "${userDetails[2]} ${userDetails[3]}" : "",
      "pickUpDate": _selectedDatePickUp,
      "pickUpTime": "${_selectedTimePickUp.hour}:${_selectedTimePickUp.minute}",
      "returnPickUpDate": widget.isOneWay ? '' : _selectedDateReturnPickUp,
      "returnPickUpTime": widget.isOneWay
          ? ''
          : "${_selectedTimeReturnPickUp.hour}:${_selectedTimeReturnPickUp.minute}",
      "waitingTime": widget.isOneWay ? 0 : 'Yet to implement',
      "noOfBagsRequest": widget.bagsCount,
      "noOfSeatsRequest": widget.seatsCount,
      "price": widget.price,
      "commission": txtCommisionAmountTextEditingController.text.isNotEmpty?txtCommisionAmountTextEditingController.text:"0",
      "carType": carTypes[widget.index],
      "rideByKm": widget.rideByKm ? "km" : "destination",
      "isOneWay": widget.isOneWay,
      "status": "Pending",
      "customerId": userDetails != null ? userDetails[0] : '',
      "specialNotes": txtSpecialNotesTextEditingController.text,
      "createdAt": DateTime.now(),
      "customerPhoneNumber": userModelCurrentInfo!.phoneNumber,
      "driverPhoneNumber": "",
      "isEv": widget.isEv,
      "driverId":"",
      "paymentIs":dropdownValue,

    };

    // _firestore.collection("rideRequest").doc(userModelCurrentInfo!.id!).set(currentRideDetails, SetOptions(merge: true));

    // ignore: unused_local_variable
    await _firestore
        .collection("rideRequests")
        .add(currentRideDetails)
        .then((documentSnapshot) {
      debugPrint("Added Data with ID: ${documentSnapshot.id}");
      addedRideId = documentSnapshot.id;
      addRideId();
    }).catchError((e) {
      AmoToast.showAmoToast("Something went wrong", context);
      debugPrint("Something went wrong $e");
      Navigator.pop(context);
    });
  }

  void addRideId() async {
    final snapshot = await _firestore
        .collection("allUsers")
        .doc("customer")
        .collection("customers")
        .where("phoneNumber", isEqualTo: userModelCurrentInfo!.phoneNumber!)
        .get();

    UserModel userData =
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    log("User Data : $userData");

    log("user id is${userData.id}");
    List prevRideIds = userData.rideIds;
    log(prevRideIds.toString());
    log("ride id is :$addedRideId");

    prevRideIds.add(addedRideId);
    log(prevRideIds.toString());

    log("appending ride ids");

    await _firestore
        .collection('allUsers')
        .doc("customer")
        .collection("customers")
        .doc(userData.id)
        .update({
      "rideIds": prevRideIds,
      "totalRides": userData.totalRides! + 1
    }).then((result) {
      log("ride Id appended");

      ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
      Provider.of<AppInfo>(context, listen: false).userDropOffLocation = null;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (c) => ThankYouScreen(
            commission: txtCommisionAmountTextEditingController.text.toString(),
            price:widget.getoffer==0&&1000<widget.price?"not show":price,
            index: widget.index,
            pickUpDate: _selectedDatePickUp!,
            dropOff: widget.rideByKm ? null : dropOff!,
            origin: pickUp!,
          ),
        ),
      );
    }).catchError((onError) {
      print("something went wrong");
    });
  }

  TextEditingController txtSpecialNotesTextEditingController =
  TextEditingController();
  TextEditingController txtCouponTextEditingController =
  TextEditingController();

  TextEditingController txtCustomerMobileNumberTextEditingController =
  TextEditingController();

  TextEditingController txtCommisionAmountTextEditingController =
  TextEditingController();

  _selectPickUpTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: _selectedTimePickUp,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != _selectedTimePickUp) {
      setState(() {
        _selectedTimePickUp = timeOfDay;
      });
    }
  }

  _selectReturnPickUpTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: _selectedTimeReturnPickUp,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != _selectedTimeReturnPickUp) {
      setState(() {
        _selectedTimeReturnPickUp = timeOfDay;
      });
    }
  }

  String? userRole = "Customer";

  void _pickUpDatePicker() {
    // showDatePicker is a pre-made funtion of Flutter
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2030))
        .then((pickedDate) {
      // Check if no date is selected
      if (pickedDate == null) {
        return;
      }
      setState(() {
        // using state so that the UI will be rerendered when date is picked
        _selectedDatePickUp = pickedDate;
      });
    });
  }

  void _returnPickUpDatePicker() {
    // showDatePicker is a pre-made funtion of Flutter
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2030))
        .then((pickedDate) {
      // Check if no date is selected
      if (pickedDate == null) {
        return;
      }
      setState(() {
        // using state so that the UI will be rerendered when date is picked
        _selectedDateReturnPickUp = pickedDate;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

  }


  //String st =  getOfferPref();


  @override
  Widget build(BuildContext context) {
    priceInDouble = widget.price;
    price = CarTypeWidget.formatPrice(widget.price);
    int index = widget.index;


    // getOfferPref() async {
    //
    //   dynamic shared = await SharedPreferences.getInstance();
    //   dynamic IsLogin =  shared.getString("offer");
    //
    //    return IsLogin;
    //
    //   //log("sett$IsLogin");
    //
    // }


    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                // titles
                Row(
                  children: [
                    Text(
                           evCarCategories[index]!.name!.toUpperCase(),
                      style:
                      const TextStyle(fontFamily: 'Poppins', fontSize: 25),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 15,
                ),

                // description
                Text(widget.isEv
                    ? evCarCategories[index]!.description!
                    : evCarCategories[index]!.description!),

                // Text(
                //     "The ${carTypes[index]} is a ${noOfSeatsAvailableByCarType[index] + 1} seater car with luggage capacity of ${noOfBagStorageAvailableByCarType[index]}. All our vehicles are eVehicles, leaving behind no carbon footprint."),

                const SizedBox(
                  height: 10,
                ),
                Container(
                  // padding: EdgeInsets.only(left: 20, top: 10),
                  alignment: Alignment.centerLeft,
                  child: const Text("Features",
                      style: TextStyle(fontFamily: "Poppins")),
                ),

                //
                Row(
                  children: [
                    // box -1
                    Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Container(
                            decoration: BoxDecoration(
                                border:
                                Border.all(width: 2, color: Colors.black),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                            width: 50,
                            height: 50,
                            child: Column(
                              children: [
                                Expanded(
                                    child: Image.asset("images/img_32.png")),
                                Expanded(
                                  child: Text(
                                    noOfSeatsAvailableByCarType[index]
                                        .toString(),
                                  ),
                                ),
                              ],
                            ))),
                    // box-2
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.black),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                        width: 50,
                        height: 50,
                        child: Column(
                          children: [
                            Expanded(child: Image.asset("images/img_33.png")),
                            Expanded(
                                child: Text(
                                    noOfBagStorageAvailableByCarType[index]
                                        .toString()))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // location bar

                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text("Pickup Location",
                      style: TextStyle(fontFamily: "Poppins")),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
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
                              Image.asset("images/img_34.png"),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Center(
                                  child: Text(
                                    Provider.of<AppInfo>(context)
                                        .userPickUpLocation!
                                        .locationName!
                                        .length >
                                        30
                                        ? "${(Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0, 29)}..."
                                    // ignore: unnecessary_string_interpolations
                                        : "${(Provider.of<AppInfo>(context).userPickUpLocation!.locationName!)}",
                                    style: const TextStyle(color: Colors.white),
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

                //Drop Location
                !widget.rideByKm

                    ? Container(
                  alignment: Alignment.centerLeft,
                  child: const Text("Drop Location",
                      style: TextStyle(fontFamily: "Poppins")),
                )
                    : Container(),

                !widget.rideByKm
                    ? Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    elevation: 6.0,
                    color: const Color(0xff009B4E),
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset("images/img_28.png"),
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
                                style:
                                const TextStyle(color: Colors.white),
                                //like app --
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                    : Container(),

                //  pick-- date and time
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text("Pick Up Time",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ),

                const SizedBox(
                  height: 16,
                ),

                Row(
                  children: [
                    // Pick a date
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "Pick a date",
                                style: TextStyle(fontFamily: "Poppins"),
                              )),
                          Card(
                              elevation: 6.0,
                              color: const Color(0xff009B4E),
                              clipBehavior: Clip.hardEdge,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  _pickUpDatePicker();
                                },
                                child: SizedBox(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _selectedDatePickUp
                                            .toString()
                                            .split(" ")[0],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Icon(
                                        Icons.calendar_month,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),

                    //Pick a time
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "Pick a time",
                                style: TextStyle(fontFamily: "Poppins"),
                              )),
                          Card(
                            elevation: 6.0,
                            color: const Color(0xff009B4E),
                            clipBehavior: Clip.hardEdge,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _selectPickUpTime(context);
                              },
                              child: Container(
                                height: 40,
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _selectedTimePickUp.hour < 10
                                          ? "0${_selectedTimePickUp.hour}"
                                          : "${_selectedTimePickUp.hour}",
                                      style:
                                      const TextStyle(color: Colors.white),
                                    ),
                                    const Text(
                                      ":",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      _selectedTimePickUp.minute < 10
                                          ? "0${_selectedTimePickUp.minute}"
                                          : "${_selectedTimePickUp.minute}",
                                      style:
                                      const TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Icon(Icons.access_time_filled_sharp,
                                        color: Colors.white),
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

                Visibility(
                  visible: !(widget.isOneWay),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text("Return Pick Up Time",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                      ),
                    ],
                  ),
                ),

                Visibility(
                  visible: !(widget.isOneWay),
                  child: Row(
                    children: [
                      // Pick a date
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Pick a date",
                                  style: TextStyle(fontFamily: "Poppins"),
                                )),
                            Card(
                                elevation: 6.0,
                                color: const Color(0xff009B4E),
                                clipBehavior: Clip.hardEdge,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    _returnPickUpDatePicker();
                                  },
                                  child: SizedBox(
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _selectedDateReturnPickUp
                                              .toString()
                                              .split(" ")[0],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Icon(
                                          Icons.calendar_month,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),

                      //Pick a time
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Pick a time",
                                  style: TextStyle(fontFamily: "Poppins"),
                                )),
                            Card(
                              elevation: 6.0,
                              color: const Color(0xff009B4E),
                              clipBehavior: Clip.hardEdge,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  _selectReturnPickUpTime(context);
                                },
                                child: Container(
                                  height: 40,
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Text(_selectedTimeReturnPickUp.hour<10? "0${_selectedTimeReturnPickUp.hour}":"${_selectedTimeReturnPickUp.hour}", style: TextStyle(color: Colors.white),),
                                      // const Text(":", style: TextStyle(color: Colors.white),),
                                      // Text(_selectedTimeReturnPickUp.minute<10? "0${_selectedTimeReturnPickUp.minute}":"${_selectedTimeReturnPickUp.minute}", style: TextStyle(color: Colors.white),),
                                      //
                                      Text(
                                        _selectedTimeReturnPickUp.hour < 10
                                            ? "0${_selectedTimeReturnPickUp.hour}"
                                            : "${_selectedTimeReturnPickUp.hour}",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      const Text(
                                        ":",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        _selectedTimeReturnPickUp.minute < 10
                                            ? "0${_selectedTimeReturnPickUp.minute}"
                                            : "${_selectedTimeReturnPickUp.minute}",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),

                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Icon(Icons.access_time_filled_sharp,
                                          color: Colors.white),
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

                //special notes textfield
                Card(
                  child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: TextField(
                                controller:
                                txtSpecialNotesTextEditingController,
                                decoration: const InputDecoration(
                                  labelText: 'Special Notes:',
                                ),
                                maxLines: 2, //
                              ),
                            ),
                          ),
                        ],
                      )),
                ),

                //todo -- dropdown menu
                Card(
                  child: Container(
                      color: Color(0xff009B4E),
                      width: double.infinity,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.mobile_friendly_rounded,color: Colors.white,),
                          Expanded(
                            child:   DropdownButton<String>(
                              elevation: 4,
                              underline: Container(),
                              icon:  Row(

                                children: [
                                  Text(
                                    dropdownValue,
                                    style:
                                    const TextStyle(
                                        color: Colors.white,fontFamily:"Poppins"),
                                  ),
                                  const Icon(
                                    Icons
                                        .arrow_drop_down_sharp,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              items: <String>[
                                "Cash",
                                "Online"

                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value:value,
                                  child: Text( value),
                                );
                              }).toList(),
                              onChanged: (newVal) {
                                setState(() {
                                  dropdownValue = newVal!;
                                });

                                //  log("$value");
                              },
                            )
                            ,
                            // <-- SEE HERE
                          ),
                        ],
                      )),
                ),

                //coupon code textfield
                Card(
                  child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            // <-- SEE HERE
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: TextField(
                                controller: txtCouponTextEditingController,
                                decoration:  InputDecoration(
                                  labelText:wrongCoupon ==2?'Enter Coupon code: ✔️':"Enter Coupon code:",
                                    focusedBorder:  UnderlineInputBorder(
                                      borderSide: wrongCoupon==1? BorderSide( color: Colors.red): BorderSide( color: Colors.blueAccent), //<-- SEE HERE
                                    )
                                ),
                                maxLines: 1,

                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              log ("coupon ${txtCouponTextEditingController.text}");
                              couponSet();
                            },
                            child: Card(
                                elevation: 6.0,
                                color: const Color(0xff009B4E),
                                clipBehavior: Clip.hardEdge,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Container(
                                    width: 100,
                                    height: 40,

                                    color: const Color(0xff009B4E),
                                    child: const Center(
                                        child: Text(
                                          "Apply",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Poppins'),
                                        )))),
                          ),
                        ],
                      )),
                ),

                const SizedBox(
                  height: 15,
                ),

                Visibility(
                  visible: userRole != "Customer",
                  child: Column(
                    children: [
                      //customer mobile app
                      Container(

                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Customer Mobile Number",
                          style: TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),

                      TextField(
                        maxLength: 10,
                        autofocus: true,
                        enableSuggestions: true,
                        controller:
                        txtCustomerMobileNumberTextEditingController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            color: Colors.black),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Customer Phone",
                          counterText: "",
                          hintStyle: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 18,
                              color: Colors.grey),
                        ),
                      ),

                      //Add commision
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Add Commission",
                          style: TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),

                      TextField(
                        maxLength: 4,
                        autofocus: true,
                        enableSuggestions: true,
                        onChanged: (newVal) {
                          double commission = double.parse(newVal);
                          setState(() {
                            priceInDouble += commission;
                            price = CarTypeWidget.formatPrice(priceInDouble);
                          });
                        },
                        controller: txtCommisionAmountTextEditingController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            color: Colors.black),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Commission Amount",
                          counterText: "",
                          hintStyle: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 18,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),

                //estimated fare text
                // todo - price offer
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Estimated fare : ',
                        style: TextStyle(fontSize: 18),
                      ),

                      TextSpan(
                        text:'₹${price}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),TextSpan(
                        text:offCutText ==1?"₹${widget.realPrice}":"",
                        style: const TextStyle(decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.normal, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                //confirm button
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Card(
                    elevation: 6.0,
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      height: 45,
                      width: 210,
                      decoration: const BoxDecoration(
                          color: Color(0xff009B4E),
                          borderRadius: BorderRadius.horizontal()),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff009B4E),
                          // Background color
                          textStyle: const TextStyle(
                            fontSize: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          sendRideRequest();

                          setOfferPref();
                          //    Navigator.push(context,MaterialPageRoute(builder: (context) =>OtpScreen()),);
                        },
                        child: const Text("Confirm"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  // offeradd_price() {
  //
  //     if (widget.getoffer==0&&1000<int.parse(price)) {
  //
  //       // add-- offer code value
  //
  //       log("Successfully Offer code add");
  //       return int.parse(price)-500;
  //
  //     }else{
  //       log("Error add offer_code ");
  //
  //       return widget.price;
  //
  //     }
  //
  //
  //     // log("Error add offer_code try ");
  //
  //
  //
  // }


  //todo-- offer set shared-pref

  // data put--
  void setOfferPref() async {

    var data =  FirebaseFirestore.instance.collection('allUsers').doc('customer').collection('customers').doc(userModelCurrentInfo!.id!);
    data.update({'offer':'1'});

    dynamic shared = await SharedPreferences.getInstance();
    shared.setString("offer","1");

  }

   couponSet()async {

     // todo --test firebase
     QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("coupon").get();
//sub-patch
     for (int i = 0; i < querySnapshot.size; i++) {
       var a = querySnapshot.docs[i];

       String sts=txtCouponTextEditingController.text;
       //log("firstName: ${a['image']}");

       log(a.id);
       if ( sts==a["code"]&& couponRun==0&&double.parse(a['upto'])<widget.price){
         //log(st!);
      //   setState((){});
         log("firstCoupon: ${a['off']}");

         double coupon_minus = widget.price * double.parse(a['off'])/100;


         log ("copon=${widget.price * double.parse(a['off']) / 100}");

       double  couponprice = widget.price-coupon_minus;

         widget.price = couponprice;
         setState(() {});
         couponRun = 1;
         wrongCoupon =2;
         offCutText=1;
         break;
       }else{
         log ("coupon dose not exist");
         wrongCoupon =1;
         setState(() {});
         // WRong_Coupon = 1;
       }
     }

  }

}
