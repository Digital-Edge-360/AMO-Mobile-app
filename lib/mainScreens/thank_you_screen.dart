import 'package:amo_cabs/global/global.dart';
import 'package:amo_cabs/mainScreens/home_screen.dart';
import 'package:flutter/material.dart';

import '../models/directions.dart';

class ThankYouScreen extends StatelessWidget {
  String commission, price;
  DateTime pickUpDate;
  Directions? origin, dropOff;
  int index;
  ThankYouScreen({
    required this.commission,
    required this.price,
    required this.index,
    required this.pickUpDate,
    required this.origin,
    required this.dropOff,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen()),
                  ModalRoute.withName('/'));
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  height: 300,
                  padding: const EdgeInsets.only(top: 50),
                  child: Image.asset(
                    "images/img_35.png",
                    height: 10,
                  )),

              const Text(
                "Thank You",
                style: TextStyle(
                    fontFamily: "Poppins", color: Colors.black, fontSize: 20),
              ),

              // text
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 20, left: 10),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      const TextSpan(
                        text: "You have booked a ",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.black26,
                            fontSize: 16),
                      ),
                      TextSpan(
                        text:
                            "${evCarCategories[index].name!.toUpperCase()} car",
                        style: const TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.black,
                            fontSize: 16),
                      ),
                      TextSpan(
                        text:
                            " for ${pickUpDate.day}-${pickUpDate.month}-${pickUpDate.year} from ${origin?.locationName}.",
                        style: const TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.black26,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pickup Date: ",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.black,
                              fontSize: 16),
                        ),
                        Text(
                          "Pickup Time: ",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.black,
                              fontSize: 16),
                        ),
                        Text(
                          "Source: ",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.black,
                              fontSize: 16),
                        ),
                        Text(
                          "Destination: ",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.black,
                              fontSize: 16),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${pickUpDate.day}-${pickUpDate.month}-${pickUpDate.year}",
                          style: const TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.black26,
                              fontSize: 16),
                        ),
                        Text(
                          "${pickUpDate.hour}:${pickUpDate.minute}",
                          style: const TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.black26,
                              fontSize: 16),
                        ),
                        Text(
                          origin!.locationName!.length <= 20
                              ? "${origin?.locationName.toString()}"
                              : "${origin?.locationName.toString().substring(0, 20)}",
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontFamily: "Poppins",
                              color: Colors.black26,
                              fontSize: 16),
                        ),
                        Text(
                          dropOff == null
                              ? 'Booked by km'
                              : dropOff!.locationName!.length <= 20
                                  ? "${dropOff?.locationName.toString()}"
                                  : "${dropOff?.locationName.toString().substring(0, 20)}",
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontFamily: "Poppins",
                              color: Colors.black26,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //text Rs 330/-

              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      const TextSpan(
                        text: "Estimate fare ",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.black54,
                            fontSize: 16),
                      ),
                      TextSpan(
                        text: "Rs ${price}/-",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.black,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const Text("*Parking Charge will be aditional",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.black,
                      fontSize: 10)),

              //button

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
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    HomeScreen()),
                            ModalRoute.withName('/'));
                      },
                      child: const Text("Back to Home"
                          ""),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
