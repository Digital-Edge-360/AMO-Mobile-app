import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? phoneNumber;
  String? firstName;
  String? lastName;
  String? email;
  String? userRole;
  bool? active;
  int? totalRides;
  List<dynamic> rideIds = [];
  String?offer;


  UserModel(
      {this.id,
        this.phoneNumber,
        this.firstName,
        this.lastName,
        this.email,
        this.offer,
        this.userRole,
        this.active,
        this.totalRides
      });

  UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data()!;
    id = snap.id;
    log(data.toString());
    phoneNumber = data['phoneNumber'];
    userRole = data['role'];
    active = data['active'];
    totalRides = data['totalRides'];
    firstName = data['firstName'];
    lastName = data['lastName'];
    email = data['email'];
    rideIds = data['rideIds'];
    offer = data['offer'];




  }
}
