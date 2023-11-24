import 'dart:developer';

import 'package:amo_cabs/models/car_category.dart';
import 'package:amo_cabs/widgets/amo_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global/global.dart';
import '../mainScreens/booking_confirmation_page.dart';

class
CarTypeWidget extends StatefulWidget {


  final  int distanceInMeters, bagsCount, seatsCount, index;
  final bool rideByKm, isEv;
  final bool? isOneWay;


  const  CarTypeWidget(
      {super.key,
        required this.isEv,
        required this.distanceInMeters,
        required this.seatsCount,
        required this.bagsCount,
        required this.index,
        required this.isOneWay,
        required this.rideByKm});


  static String formatPrice(double price) {

    final formatter = NumberFormat('#,##0.00', 'en_US');
    return formatter.format(price);
  }

  static  Future<int?> getCategoryDetails() async {
    log("inside getCategoryDetails");

    try {
      //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("isNotEv")
      //         .orderBy("baseFare").get();
      // //    nonEvCarCategories = [];
      //     for (int i = 0; i < querySnapshot.size; i++) {
      //       dynamic a = querySnapshot.docs[i];
      //       CarCategory tempCategory = CarCategory(
      //         id:a.id,
      //         baseFare:a['baseFare'].toString(),
      //         //  // cars: a['cars'],
      //         farePerKm: a['farePerKm'].toString(),
      //         //
      //         name: a['name'],
      //         //  // waiting: a['waiting'],
      //         description: a['description'],
      //       );
      //
      //       log("idss :" + a.id);
      //       log("base"+a['baseFare'].toString());
      //       log("name" + a['name']);
      //       //  log("wait"+a['waiting']);
      //       // log("baseFare: ${a['baseFare']}");
      //       // log("cars: ${a['cars']}");
      //       // log("fare per km: ${a['farePerKm']}");
      //       // log("name: ${a['name']}");
      //       // log("waiting: ${a['waiting']}");
      //
      //     //  nonEvCarCategories.add(tempCategory);
      //     }

//isEv section
      //only isEv section work
      QuerySnapshot querySnapshotForEv = await FirebaseFirestore.instance.collection("isEv").get();
      evCarCategories = [];
      for (int i = 0; i < querySnapshotForEv.size; i++) {
        dynamic b = querySnapshotForEv.docs[i];

        CarCategory ?tempCategory;

        tempCategory = CarCategory(
            id: b.id,
            baseFare: b['baseFare'].toString(),
            //  // cars: a['cars'],
            farePerKm: b['farePerKm'].toString(),
            //
            name: b['name'],
            //  // waiting: a['waiting'],
            description: b['description'],
            seats: b['sets'].toString(),
            bags: b['bags'].toString()
        );

        log("nxt ${b['sets'].toString()}");
        evCarCategories.add(tempCategory!);
      }
      log("======");
      log(evCarCategories.toString());
      // await FirebaseFirestore.instance
      //     .collection('isNotEv')
      //     .snapshots()
      //     .forEach((element) {
      //   log(element.docs.);
      // });
    } catch (e) {
      log("Errord: $e");
    }
    return 0;
  }

  @override
  State<CarTypeWidget> createState() => _CarTypeWidgetState();
}

// late String getoffer;
//
// void getOfferPref() async {
//
//   dynamic shared = await SharedPreferences.getInstance();
//   getoffer =  shared.getString("offer");
//
//   // return IsLogin;
// }
// calculation - price
class _CarTypeWidgetState extends State<CarTypeWidget> {
  double calculatePrices() {
    log("ev farePerKm ${evCarCategories[widget.index].farePerKm!}");
    // log("non ev farePerKm ${nonEvCarCategories[widget.index].farePerKm!}");
    var kmMultiplier =
    evCarCategories[widget.index].farePerKm!;
    var baseFare =
    evCarCategories[widget.index].baseFare!;
    double price = (widget.distanceInMeters / 1000) * int.parse(kmMultiplier) * 2;

    price += int.parse(baseFare);



    return price;


    //int.parse(b['baseFare'])  ..kmMultiplier

    // if(isOneWay){
    //   //
    // }
    // else{
    // }
  }

  @override
  void initState() {
    super.initState();
    //  setOfferPref();
    getOfferPref();

  }
//todo-- offer set shared-pref
//   void setOfferPref() async {
//
//     dynamic shared = await SharedPreferences.getInstance();
//     shared.setString("offer","0");
//     //log("sett$IsLogin");
//   }
//todo-- offer get shared-pref

  late String getoffer;

  void getOfferPref() async {

    dynamic shared = await SharedPreferences.getInstance();
    getoffer =  shared.getString("offer");

    // return IsLogin;
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      // color: widget.isEv ? Colors.blue : const Color(0xff009B4E),
      color: Colors.white70,
      elevation: 5,
      shadowColor: Colors.black,
      borderOnForeground: true,
      semanticContainer: true,
      child: ListTile(
        onTap: () async{
          if (widget.isOneWay == null) {
            AmoToast.showAmoToast(
                "Please select either one way or return as trip type.",
                context);
          } else {
            // final SharedPreferences prefs = await SharedPreferences.getInstance();

            final SharedPreferences perfs = await SharedPreferences.getInstance();
            final List<String>? userDetails = perfs.getStringList('userCurrentInfo');



            getOfferPref();

            // double setprice= calculatePrices();



            log("Getoffer+$getoffer");

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => BookingConfirmation(
                  isEv: widget.isEv,
                  index: widget.index,
                  isOneWay: widget.isOneWay!,
                  price:getoffer.toString()=="0"&& 1000<calculatePrices()?calculatePrices()-500:calculatePrices(),
                  realPrice:getoffer.toString()=="0"&& 1000<calculatePrices()?calculatePrices()-500:calculatePrices(),
                  distanceInMeters: widget.distanceInMeters,
                  bagsCount: widget.bagsCount,
                  seatsCount: widget.seatsCount,
                  rideByKm: widget.rideByKm,
                  getoffer: getoffer.toString(),
                ),
              ),
            );
          }
        },
        leading: Image.asset(
          carTypesImages[widget.index],
          height: 20,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 4,
              child: Text(
                evCarCategories[widget.index].name!,
                style: const TextStyle(
                    fontFamily: "Poppins", fontSize: 12, color: Colors.black),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'images/seats.png',
                    height: 12,
                  ),
                  Text(
                    '${evCarCategories[widget.index].seats}',
                    style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'images/bags.png',
                    height: 12,
                  ),
                  Text(
                    '${evCarCategories[widget.index].bags}',
                    style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
        trailing: Text(
          '₹${CarTypeWidget.formatPrice(calculatePrices())}',
          style: const TextStyle(
              fontFamily: "Poppins", fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }
}
