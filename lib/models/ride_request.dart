import 'package:amo_cabs/models/directions.dart';

class RideRequest{

  Directions? pickUp;
  Directions? dropOff;
  int distanceInMeters;
  String customerName;
  String pickUpDate;
  String pickUpTime;
  int noOfSeatsRequest;
  int noOfBagsRequest;
  double price;
  String carType;
  bool rideByKm;
  String status;
  String customerId;
  String specialNotes;


  RideRequest({
    required this.pickUp,
    required this.dropOff,
    required this.distanceInMeters,
    required this.customerName,
    required this.pickUpDate,
    required this.pickUpTime,
    required this.noOfBagsRequest,
    required this.noOfSeatsRequest,
    required this.price,
    required this.carType,
    required this.rideByKm,
    required this.status,
    required this.customerId,
    required this.specialNotes,


  });
}