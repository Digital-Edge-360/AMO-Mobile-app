import 'package:amo_cabs/global/global.dart';
import 'package:amo_cabs/models/ride_request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../infoHandler/app_info.dart';

class BookingConfirmation extends StatefulWidget {
  int price, distanceInMeters, bagsCount, seatsCount;
  BookingConfirmation({required this.price, required this.distanceInMeters, required this.bagsCount, required this.seatsCount});

  @override
  State<BookingConfirmation> createState() => _BookingConfirmationState();
}

class _BookingConfirmationState extends State<BookingConfirmation> {
  DateTime? _selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  sendRideRequest() async {
    var origin = Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destination = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

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
        "customerName": userModelCurrentInfo!.firstName! + " " + userModelCurrentInfo!.lastName!,
        "pickUpDate": _selectedDate,
        "pickUpTime": selectedTime.hour.toString() + ":" + selectedTime.minute.toString(),
        "noOfBagsRequest": widget.bagsCount,
        "noOfSeatsRequest": widget.seatsCount,
        "price": widget.price.toDouble(),
        "carType": "Hatchback",
        "rideByKm": false,
        "status": "Pending",
        "customerId": userModelCurrentInfo!.id!,
        "specialNotes": txtSpecialNotesTextEditingController.text};

    // _firestore.collection("rideRequest").doc(userModelCurrentInfo!.id!).set(currentRideDetails, SetOptions(merge: true));

    await _firestore.collection("rideRequest").add(currentRideDetails).then((documentSnapshot) =>
        print("Added Data with ID: ${documentSnapshot.id}"));
  }

  TextEditingController txtSpecialNotesTextEditingController = TextEditingController();
  TextEditingController txtCouponTextEditingController = TextEditingController();

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if(timeOfDay != null && timeOfDay != selectedTime)
    {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }

  void _presentDatePicker() {
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
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(children: [
          // todo -- image car
          Container(
              width: double.infinity,
              height: 200,
              color: Color(0xff2B2A2A),
              child: SizedBox(width: 50,height: 50,
                  child: Image.asset("images/img_31.png",height: 10,)
              )
          ),
          // text-1
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: const [
                Text(
                  "Swift Dzire",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 25),
                ),
              ],
            ),
          ),

          // text-2

          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
                "The Dzire is a 5 seater 4 cylinder car and has length of 3995mm,width of 1735 and a wheelbase of 2450."),
          ),

          Container(
            padding: EdgeInsets.only(left: 20, top: 10),
            alignment: Alignment.centerLeft,
            child: Text("Features", style: TextStyle(fontFamily: "Poppins")),
          ),

          //
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
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
                            Expanded(child: Text("3"))
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
                            Expanded(child: Text("3"))
                          ],
                        ),),),
              ],
            ),
          ),



          // location bar

          Container(
            padding: EdgeInsets.only(left: 12),
            alignment: Alignment.centerLeft,
            child:
            Text("Pickup Location", style: TextStyle(fontFamily: "Poppins")),
          ),

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only( left: 10, right: 10, bottom: 10),
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
            padding: EdgeInsets.only(left: 12),
            alignment: Alignment.centerLeft,
            child:
            Text("Drop Location", style: TextStyle(fontFamily: "Poppins")),
          ),

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
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
                              child: Image.asset("images/img_28.png"),
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
            ],
          ),

          //  pick-- date and time
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
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
                            _presentDatePicker();
                          },
                          child: Container(
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_selectedDate.toString().split(" ")[0], style: TextStyle(color: Colors.white),),
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
                            _selectTime(context);
                          },
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.all(10.0),
                            child: Row(

                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Text("${selectedTime.hour}:${selectedTime.minute}", style: TextStyle(color: Colors.white),),

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
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Card(
              child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    children:  <Widget>[
                      Expanded(
                        // <-- SEE HERE
                        child: Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: TextField(
                            controller: txtSpecialNotesTextEditingController,
                            decoration: InputDecoration(
                              labelText: 'Special Notes:',
                            ),
                            maxLines: 2, // <-- SEE HERE
                            minLines: 1, // <-- SEE HERE
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Card(
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
          ),
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
        ]),
      ),
    );
  }
}
