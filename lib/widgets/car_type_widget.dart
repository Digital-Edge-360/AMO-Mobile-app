import 'dart:developer';

import 'package:amo_cabs/models/car_category.dart';
import 'package:amo_cabs/widgets/amo_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../global/global.dart';
import '../mainScreens/booking_confirmation_page.dart';

class CarTypeWidget extends StatefulWidget {
  final int distanceInMeters, bagsCount, seatsCount, index;
  final bool rideByKm, isEv;
  final bool? isOneWay;
  CarTypeWidget(
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

  static Future<int?> getCategoryDetails() async {
    log("inside getCategoryDetails");
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("isNotEv")
          .orderBy("baseFare")
          .get();
      nonEvCarCategories = [];
      for (int i = 0; i < querySnapshot.size; i++) {
        var a = querySnapshot.docs[i];
        CarCategory tempCategory = CarCategory(
          id: a.id,
          baseFare: a['baseFare'],
          cars: a['cars'],
          farePerKm: a['farePerKm'],
          name: a['name'],
          waiting: a['waiting'],
        );

        log("id :" + a.id);
        // log("baseFare: ${a['baseFare']}");
        // log("cars: ${a['cars']}");
        // log("fare per km: ${a['farePerKm']}");
        // log("name: ${a['name']}");
        // log("waiting: ${a['waiting']}");

        nonEvCarCategories.add(tempCategory);
      }

      QuerySnapshot querySnapshotForEv = await FirebaseFirestore.instance
          .collection("isEv")
          .orderBy("baseFare")
          .get();
      evCarCategories = [];
      for (int i = 0; i < querySnapshotForEv.size; i++) {
        var b = querySnapshotForEv.docs[i];
        CarCategory tempCategory = CarCategory(
          id: b.id,
          baseFare: b['baseFare'],
          cars: b['cars'],
          farePerKm: b['farePerKm'],
          name: b['name'],
          waiting: b['waiting'],
        );

        // log("======================");
        // log("Ev id :" + a.id);
        // log("Ev baseFare: ${a['baseFare']}");
        // log("Ev cars: ${a['cars']}");
        // log("Ev fare per km: ${a['farePerKm']}");
        // log("Ev name: ${a['name']}");
        // log("Ev waiting: ${a['waiting']}");

        evCarCategories.add(tempCategory);
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
      log("Error: $e");
    }
    return 0;
  }

  @override
  State<CarTypeWidget> createState() => _CarTypeWidgetState();
}

class _CarTypeWidgetState extends State<CarTypeWidget> {
  double calculatePrices() {
    log("ev farePerKm ${evCarCategories[widget.index].farePerKm!}");
    log("non ev farePerKm ${nonEvCarCategories[widget.index].farePerKm!}");
    var kmMultiplier = widget.isEv
        ? evCarCategories[widget.index].farePerKm!
        : nonEvCarCategories[widget.index].farePerKm!;
    var baseFare = widget.isEv
        ? evCarCategories[widget.index].baseFare!
        : nonEvCarCategories[widget.index].baseFare!;
    double price = (widget.distanceInMeters / 1000) * kmMultiplier * 2;

    price += baseFare;

    return price;
    // if(isOneWay){
    //   //TODO:
    // }
    // else{
    //   //TODO: return ui need to be done
    // }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.isEv ? Colors.blue : const Color(0xff009B4E),
      elevation: 5,
      shadowColor: Colors.black,
      borderOnForeground: true,
      semanticContainer: true,
      child: ListTile(
        onTap: () {
          if (widget.isOneWay == null) {
            AmoToast.showAmoToast(
                "Please select either one way or return as trip type.",
                context);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => BookingConfirmation(
                  isEv: widget.isEv,
                  index: widget.index,
                  isOneWay: widget.isOneWay!,
                  price: calculatePrices(),
                  distanceInMeters: widget.distanceInMeters,
                  bagsCount: widget.bagsCount,
                  seatsCount: widget.seatsCount,
                  rideByKm: widget.rideByKm,
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
                    '${noOfSeatsAvailableByCarType[widget.index]}',
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
                    '${noOfBagStorageAvailableByCarType[widget.index]}',
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
