import 'package:flutter/material.dart';

class ThankYouScreen extends StatelessWidget {
  String commission, price;
  int index;
  ThankYouScreen({required this.commission, required this.price, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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

            const Text("Thank You",style: TextStyle(fontFamily:"Poppins",color: Colors.black,fontSize: 20),),

            // text
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 20,left:10),
              child: RichText(
                text: const TextSpan(

                  children: <TextSpan>[
                    TextSpan(
                      text: "You have booked a ",
                      style: TextStyle(fontFamily:"Poppins",color: Colors.black26,fontSize: 16),
                    ),
                    TextSpan(
                      text: "Swift Dzire",
                      style: TextStyle(fontFamily:"Poppins",color: Colors.black,fontSize: 16),
                    ),
                    TextSpan(
                      text: " for19th April at 08:30 PM at Chowrangi, Kolkata, West Bengal.",
                      style: TextStyle(fontFamily:"Poppins",color: Colors.black26,fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("Booking ID: ",style: TextStyle(fontFamily:"Poppins",color: Colors.black,fontSize: 16),),
                    Text("Seat: ",style: TextStyle(fontFamily:"Poppins",color: Colors.black,fontSize: 16),),
                    Text("Date: ",style: TextStyle(fontFamily:"Poppins",color: Colors.black,fontSize: 16),),
                    Text("Time: ",style: TextStyle(fontFamily:"Poppins",color: Colors.black,fontSize: 16),),
                    Text("Coupon : ",style: TextStyle(fontFamily:"Poppins",color: Colors.black,fontSize: 16),),

                  ],),

                  Column( children: [
                    Text("16464523",style: TextStyle(fontFamily:"Poppins",color: Colors.black26,fontSize: 16),),
                    Text("5",style: TextStyle(fontFamily:"Poppins",color: Colors.black26,fontSize: 16),),
                    Text("19-04-2023",style: TextStyle(fontFamily:"Poppins",color: Colors.black26,fontSize: 16),),
                    Text("08:30 PM",style: TextStyle(fontFamily:"Poppins",color: Colors.black26,fontSize: 16),),
                    Text("320W25",style: TextStyle(fontFamily:"Poppins",color: Colors.black26,fontSize: 16),),
                  ],),


                ],
              ),
            ),

            //text Rs 330/-

            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: RichText(
                text:  TextSpan(
                  children: <TextSpan>[

                    TextSpan(
                      text: "Estimate fare ",
                      style: TextStyle(fontFamily:"Poppins",color: Colors.black54,fontSize: 16),
                    ),
                    TextSpan(
                      text: "Rs ${price}/-",
                      style: TextStyle(fontFamily:"Poppins",color: Colors.black,fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const Text("*Parking Charge will be aditional",style: TextStyle(fontFamily:"Poppins",color: Colors.black,fontSize: 10)),

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
                      //    Navigator.push(context,MaterialPageRoute(builder: (context) =>OtpScreen()),);
                    },
                    child: const Text("Back to Home"
                        ""),
                  ),
                ),
              ),
            ),

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
                      color: Color(0xff029EE2),
                      borderRadius: BorderRadius.horizontal()),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff029EE2),
                      // Background color
                      textStyle: const TextStyle(
                        fontSize: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      //    Navigator.push(context,MaterialPageRoute(builder: (context) =>OtpScreen()),);
                    },
                    child: const Text("Cancel Booking"
                        ""),
                  ),
                ),
              ),
            ),



          ],
        ),
      )

    );
  }
}
