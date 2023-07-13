import 'package:flutter/material.dart';

import '../global/global.dart';
import '../mainScreens/booking_confirmation_page.dart';
import 'package:intl/intl.dart';

class CarTypeWidget extends StatelessWidget {
  final int distanceInMeters, bagsCount, seatsCount, index;
  final bool isOneWay, rideByKm;
  const CarTypeWidget(
      {super.key,
      required this.distanceInMeters,
      required this.seatsCount,
      required this.bagsCount,
      required this.index,
      required this.isOneWay,
      required this.rideByKm});

  String formatPrice(double price) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return formatter.format(price);
  }

  String calculatePrices() {
    double price = distanceInMeters * perKmMultiplier[index] * 2;
    if (price < 500) {
      price += basePrice;
    }

    return formatPrice(price);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => BookingConfirmation(
                index: index,
                isOneWay: isOneWay,
                price: calculatePrices(),
                distanceInMeters: distanceInMeters,
                bagsCount: bagsCount,
                seatsCount: seatsCount,
                rideByKm: rideByKm,
              ),
            ),
          );
        },
        leading: Image.asset(
          carTypesImages[index],
          height: 20,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 4,
              child: Text(
                carTypes[index],
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
                    '${noOfSeatsAvailableByCarType[index]}',
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
                    '${noOfBagStorageAvailableByCarType[index]}',
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
          '₹${calculatePrices()}',
          style: const TextStyle(
              fontFamily: "Poppins", fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }
}
