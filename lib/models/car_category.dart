import 'package:cloud_firestore/cloud_firestore.dart';

class CarCategory {
  String? id;
  int? baseFare;
  List<dynamic>? cars;
  int? farePerKm;
  int? waiting;
  String? name;
  String? description;

  CarCategory(
      {required this.id,
      required this.baseFare,
      required this.cars,
      required this.farePerKm,
      required this.waiting,
      required this.name,
      required this.description});

  CarCategory.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data()!;
    id = snap.id;
    baseFare = data['baseFare'];
    cars = data['cars'];
    farePerKm = data['farePerKm'];
    waiting = data['waiting'];
    name = data['name'];
    description = data['description'];
  }
}
