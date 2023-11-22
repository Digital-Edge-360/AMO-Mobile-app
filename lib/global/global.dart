import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../models/car_category.dart';
import '../models/user_model.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;

List<CarCategory> evCarCategories = [];
// List<CarCategory> nonEvCarCategories = [];
var carTypes = [
  'SUV',
  'Sedan',
  'Hatchback',
  'Sedan',
  'Hatchback',
  "Sedan"
];
var perKmMultiplier = [
  0.018, //for suv, 18rs per km
  0.015, //for sedan, 15rs per km
  0.013, //for hatchback, 13rs per km
];
var carTypesImages = [
  'images/suv.png',
  'images/suv.png',
  'images/img_24.png',
  'images/hatchback.png',
  'images/suv.png',
  'images/suv.png',
];
var noOfSeatsAvailableByCarType = [3, 4, 6, 7,8,9];
var noOfBagStorageAvailableByCarType = [2, 3, 4, 5,6,7];
double basePrice = 100;
late int?sett;

var items = [
  'Item 1',
  'Item 2',
];
// test apk
class NameProvider extends ChangeNotifier {
  String _name = "";

  String get getName => _name;

  saveName(String name) {
    _name = name;
    notifyListeners();
  }
}
