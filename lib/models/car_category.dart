import 'package:cloud_firestore/cloud_firestore.dart';

class CarCategory {
  // baseFare
  // 500
  // cars
  // 0
  // " qnfEFTMrTt8j7wcjswC1"
  // farePerKm
  // 16
  // name
  // "go"
  // waiting
  // 6

  String? id;
  int? baseFare;
  List<dynamic>? cars;
  int? farePerKm;
  int? waiting;
  String? name;

  CarCategory(
      {required this.id,
      required this.baseFare,
      required this.cars,
      required this.farePerKm,
      required this.waiting,
      required this.name});

  CarCategory.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data()!;
    id = snap.id;
    baseFare = data['baseFare'];
    cars = data['cars'];
    farePerKm = data['farePerKm'];
    waiting = data['waiting'];
    name = data['name'];
  }
}
