import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? id;
  String? phone;
  String? name;
  String? email;

  UserModel({this.id, this.email, this.phone, this.name});

  UserModel.fromSnapshot(DataSnapshot snap) {
    id = snap.key;
    phone = (snap.value as dynamic)['phone'];
    name = (snap.value as dynamic)['name'];
    email = (snap.value as dynamic)['email'];
  }
}
