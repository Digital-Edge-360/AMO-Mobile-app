import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';


final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;


var carTypes = ['SUV', 'Sedan','Hatchback',];
var perKmMultiplier = [
  0.018, //for suv, 18rs per km
  0.015, //for sedan, 15rs per km
  0.013,  //for hatchback, 13rs per km


];
var carTypesImages = [
  'images/suv.png',
  'images/img_24.png',
  'images/hatchback.png',


];

var noOfSeatsAvailableByCarType = [6,3,3];
var noOfBagStorageAvailableByCarType = [5,4,2];

double basePrice = 100;