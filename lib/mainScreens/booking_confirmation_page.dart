
import 'package:amo_cabs/global/global.dart';
import 'package:amo_cabs/mainScreens/main_screen.dart';
import 'package:amo_cabs/widgets/amo_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../infoHandler/app_info.dart';
import '../widgets/progress_dialog.dart';

class BookingConfirmation extends StatefulWidget {
  int price, distanceInMeters, bagsCount, seatsCount, index;
  bool isOneWay;
  BookingConfirmation({required this.price, required this.distanceInMeters, required this.bagsCount, required this.seatsCount, required this.index, required this.isOneWay});

  @override
  State<BookingConfirmation> createState() => _BookingConfirmationState();
}

class _BookingConfirmationState extends State<BookingConfirmation> {
  DateTime? _selectedDatePickUp = DateTime.now();
  TimeOfDay _selectedTimePickUp = TimeOfDay.now();

  DateTime? _selectedDateReturnPickUp = DateTime.now();
  TimeOfDay _selectedTimeReturnPickUp = TimeOfDay.now();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final successSnackBar = SnackBar(
    content: const Text('Request sent sucessfully!'),

  );



  sendRideRequest() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Sending ride requests, please wait..",
      ),
    );
    var origin = Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destination = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String>? userDetails = prefs.getStringList('userCurrentInfo');
    //var pickUpMap = {'sourceName' : origin!.locationName, 'userPickupLatitude': origin!.locationLatitude, 'use' }
    var currentRideDetails = {
        "pickUp": {"pickUpName": origin!.locationName!,
                    "pickUpId": origin.locationId,
                    "pickUpLatitude":origin.locationLatitude,
                      "pickUpLongitude": origin.locationLatitude,
                      "pickUpHumanReadableAddress": origin.humanReadableAddress },
        "dropOff": {"dropOffName": destination!.locationName!,
                    "dropOffId": destination.locationId,
                  "dropOffLatitude":destination.locationLatitude,
                    "dropOffLongitude": destination.locationLatitude,
                    "dropOffHumanReadableAddress": destination.humanReadableAddress },
        "distanceInMeters": widget.distanceInMeters,
        "customerName": userDetails != null ?  userDetails[2]+ " " + userDetails[3] : "",
        "pickUpDate": _selectedDatePickUp,
        "pickUpTime": _selectedTimePickUp.hour.toString() + ":" + _selectedTimePickUp.minute.toString(),
        "returnPickUpDate" : widget.isOneWay ? '': _selectedDateReturnPickUp,
        "returnPickUpTime" : widget.isOneWay ? '': _selectedTimeReturnPickUp.hour.toString() + ":" + _selectedTimeReturnPickUp.minute.toString(),
        "waitingTime" : widget.isOneWay ? 0 : 'Yet to implement',
        "noOfBagsRequest": widget.bagsCount,
        "noOfSeatsRequest": widget.seatsCount,
        "price": widget.price.toDouble(),
        "carType": carTypes[widget.index],
        "rideByKm": "km",
        "isOneWay": widget.isOneWay,
        "status": "Pending",
        "customerId": userDetails!=null ? userDetails[0] : '',
        "specialNotes": txtSpecialNotesTextEditingController.text,
        "createdAt": DateTime.now(),

    };

    // _firestore.collection("rideRequest").doc(userModelCurrentInfo!.id!).set(currentRideDetails, SetOptions(merge: true));

    var id = await _firestore.collection("rideRequests").add(currentRideDetails).then((documentSnapshot) {
      debugPrint("Added Data with ID: ${documentSnapshot.id}");





      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
      Provider.of<AppInfo>(context, listen: false).userDropOffLocation = null;

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => MainScreen()));

    }
        ).catchError((e){
          AmoToast.showAmoToast("Something went wrong", context);
          debugPrint("Something went wrong $e");
          Navigator.pop(context);
    });




    }


  TextEditingController txtSpecialNotesTextEditingController = TextEditingController();
  TextEditingController txtCouponTextEditingController = TextEditingController();

  _selectPickUpTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: _selectedTimePickUp,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if(timeOfDay != null && timeOfDay != _selectedTimePickUp)
    {
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
    if(timeOfDay != null && timeOfDay != _selectedTimeReturnPickUp)
    {
      setState(() {
        _selectedTimeReturnPickUp = timeOfDay;
      });
    }
  }

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
  Widget build(BuildContext context) {
    int index = widget.index;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
              width: double.infinity,
              height: 200,
              color: Color(0xff2B2A2A),
              child: SizedBox(width: 50,height: 50,
                  child: Image.asset("images/img_31.png",height: 10,)
              )
          ),
          Padding(padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              // titles
              Row(
                children: [
                  Text(
                    carTypes[index],
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 25),
                  ),
                ],
              ),


              const SizedBox(height: 15,),

              // description
              Text(
                  "The ${carTypes[index]} is a ${noOfSeatsAvailableByCarType[index] + 1} seater car with luggage capacity of ${noOfBagStorageAvailableByCarType[index]}. All our vehicles are eVehicles, leaving behind no carbon footprint."),

              Container(
                // padding: EdgeInsets.only(left: 20, top: 10),
                alignment: Alignment.centerLeft,
                child: Text("Features", style: TextStyle(fontFamily: "Poppins")),
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
                              border: Border.all(width: 2, color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          width: 50,
                          height: 50,
                          child: Column(
                            children: [
                              Expanded(child: Image.asset("images/img_32.png")),
                              Expanded(child: Text(noOfSeatsAvailableByCarType[index].toString())),
                            ],
                          ))),
                  // box-2
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      width: 50,
                      height: 50,
                      child: Column(
                        children: [
                          Expanded(child: Image.asset("images/img_33.png")),
                          Expanded(child: Text(noOfBagStorageAvailableByCarType[index].toString()))
                        ],
                      ),),),
                ],
              ),



              // location bar

              Container(

                alignment: Alignment.centerLeft,
                child:
                Text("Pickup Location", style: TextStyle(fontFamily: "Poppins")),
              ),

              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only( bottom: 10),
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
                                  padding: EdgeInsets.only(left: 10),
                                  child: Center(
                                    child: Text(
                                      Provider.of<AppInfo>(context)
                                          .userPickUpLocation!
                                          .locationName!
                                          .length >
                                          30
                                          ? "${(Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0, 29)}..."
                                          : "${(Provider.of<AppInfo>(context).userPickUpLocation!.locationName!)}",
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
                ],
              ),

              //Drop Location
              Container(
                alignment: Alignment.centerLeft,
                child:
                Text("Drop Location", style: TextStyle(fontFamily: "Poppins")),
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
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset("images/img_28.png"),
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
                ),
              ),

              //  pick-- date and time
              Container(
                alignment: Alignment.centerLeft,
                child:
                Text("Pick Up Time", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              const SizedBox(height: 16,),
              Row(
                children: [
                  // Pick a date
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
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
                              onTap: (){
                                _pickUpDatePicker();
                              },
                              child: Container(
                                height: 40,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(_selectedDatePickUp.toString().split(" ")[0], style: TextStyle(color: Colors.white),),
                                    const SizedBox(width: 10,),
                                    Icon(Icons.calendar_month, color: Colors.white,),
                                  ],
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  ),

                  //Pick a time
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
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
                            onTap: (){
                              _selectPickUpTime(context);
                            },
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.all(10.0),
                              child: Row(

                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Text("${_selectedTimePickUp.hour}:${_selectedTimePickUp.minute}", style: TextStyle(color: Colors.white),),

                                  const SizedBox(width: 10,),
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
                    const SizedBox(height: 16,),
                    Container(
                      alignment: Alignment.centerLeft,
                      child:
                      Text("Return Pick Up Time", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, fontSize: 20)),
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
                              child: Text(
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
                                onTap: (){
                                  _returnPickUpDatePicker();
                                },
                                child: Container(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(_selectedDateReturnPickUp.toString().split(" ")[0], style: TextStyle(color: Colors.white),),
                                      const SizedBox(width: 10,),
                                      Icon(Icons.calendar_month, color: Colors.white,),
                                    ],
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),
                    ),

                    //Pick a time
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
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
                              onTap: (){
                                _selectReturnPickUpTime(context);
                              },
                              child: Container(
                                height: 40,
                                padding: const EdgeInsets.all(10.0),
                                child: Row(

                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    Text("${_selectedTimeReturnPickUp.hour}:${_selectedTimeReturnPickUp.minute}", style: TextStyle(color: Colors.white),),

                                    const SizedBox(width: 10,),
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
                ),),


              //special notes textfield
              Card(
                child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      children:  <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: TextField(
                              controller: txtSpecialNotesTextEditingController,
                              decoration: InputDecoration(
                                labelText: 'Special Notes:',
                              ),
                              maxLines: 2, // <-- SEE HERE
                               // <-- SEE HERE
                            ),
                          ),
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
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: TextField(
                              controller: txtCouponTextEditingController,
                              decoration: InputDecoration(
                                labelText: 'Enter Coupon code:',
                              ),
                              maxLines: 5, // <-- SEE HERE
                              minLines: 1, // <-- SEE HERE
                            ),
                          ),
                        ),
                        Card(
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
                                child: Center(
                                    child: Text(
                                      "Apply",
                                      style: TextStyle(
                                          color: Colors.white, fontFamily: 'Poppins'),
                                    )))),
                      ],
                    )),
              ),

              const SizedBox(height: 15,),
              Container(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Estimated fare : ', style: TextStyle(fontSize: 18),),
                      TextSpan(text: '₹${widget.price}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    ],
                  ),
                ),
              ),

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
                        primary: const Color(0xff009B4E),
                        // Background color
                        textStyle: const TextStyle(
                          fontSize: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),),
                      onPressed: () {

                        sendRideRequest();
                        //    Navigator.push(context,MaterialPageRoute(builder: (context) =>OtpScreen()),);
                      },
                      child: const Text("Confirm"),
                    ),
                  ),
                ),
              ),
            ],
          ),),
        ]),
      ),
    );
  }
}
