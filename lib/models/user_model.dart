import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? id;
  String? phoneNumber;
  String? firstName;
  String? lastName;
  String? email;

  UserModel({this.id, this.phoneNumber, this.firstName, this.lastName, this.email});

  UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data()!;
    id = snap.id;
    phoneNumber = data['phoneNumber'];
    firstName = data['firstName'];
    lastName = data['lastName'];
    email = data['email'];
  }
}
