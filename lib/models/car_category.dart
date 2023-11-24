import 'package:cloud_firestore/cloud_firestore.dart';

class CarCategory {
  String? id;
  String? baseFare;
  // List<dynamic>? cars;
  String? farePerKm;
  //int? waiting;
  String? name;
  String? description;
  String? seats;



  CarCategory(
      {required this.id,
        required this.baseFare,
        //  required this.cars,
        required this.farePerKm,
        //required this.waiting,
        required this.name,
        required this.description,
       required this.seats
      });

  CarCategory.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data()!;
    id = snap.id;
    baseFare = data['baseFare'];
    //cars = data['cars'];
    farePerKm = data['farePerKm'];
    //waiting = data['waiting'];
    name = data['name'];
    description = data['description'];
    seats = data['sets'];
  }
}
