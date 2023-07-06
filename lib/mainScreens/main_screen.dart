import 'dart:async';
import 'dart:developer';

import 'package:amo_cabs/mainScreens/prices_page.dart';
import 'package:amo_cabs/mainScreens/search_places_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../assistants/assistant_methods.dart';
import '../global/global.dart';
import '../infoHandler/app_info.dart';
import '../widgets/amo_toast.dart';
import '../widgets/my_drawer.dart';
import '../widgets/progress_dialog.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();

  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  GoogleMapController? newGoogleMapController;
  Position? userCurrentPosition;
  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 360;

  List<LatLng> pLineCoordinatesList = [];
  Set<Polyline> polyLineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  String userName = "Name";
  String userEmail = "Email";

  bool openNavigationDrawer = true;

  checkIfLocationPermissionAllowed() async{
    _locationPermission = await Geolocator.requestPermission();
    if(_locationPermission == LocationPermission.denied){
      _locationPermission = await Geolocator.requestPermission();
    }
}


  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  blackThemeGoogleMap() {
    newGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }


  //0 for ride by destination
  //1 for ride by kilometer
  int currentSelectedCard = 0;
  int km = 0;

  int seatsCount = 1;
  int bagsCount = 1;

  locateUserPosition() async{
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;


    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition),);
    
    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoOrdinates(userCurrentPosition!, context);
    log('This is your address $humanReadableAddress');

    userName = userModelCurrentInfo!.firstName!;
    userEmail =  userModelCurrentInfo!.email!;

  }

  double searchLocationContainerHeight = 350.0;

  @override
  void initState() {
    super.initState();
    checkIfLocationPermissionAllowed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sKey,
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.black,
        ),
        child: MyDrawer(
          name: userName,
          email: userEmail,
        ),
      ),
      body: currentSelectedCard == 0 ?Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            markers: markersSet,
            circles: circlesSet,
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap, top: 20),
            zoomGesturesEnabled: true,
            initialCameraPosition: _kGooglePlex,
            polylines: polyLineSet,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              // blackThemeGoogleMap();

              setState(() {
                bottomPaddingOfMap = 360;
              });

              locateUserPosition();
            },
          ),

          //custom hamburger button for drawer
          Positioned(
            top: 30,
            left: 14,
            child: GestureDetector(
              onTap: () {
                if(openNavigationDrawer){
                  sKey.currentState!.openDrawer();
                }
                else{
                  //restart- refresh- minimize app progamitacally
                  SystemNavigator.pop();
                }
              },
              child: Icon(
                openNavigationDrawer ? Icons.menu : Icons.close,
                color: Colors.black54,
              ),
            ),
          ),

          //ui for searching location
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSize(
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 120),
              child: Container(
                height: searchLocationContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    children: [

                      //ride by destination or ride by km
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    currentSelectedCard = 0;
                                  });
                                },
                                child: Card(
                                  //  elevation: 6.0,
                                  color: currentSelectedCard == 0 ?  const Color(0xff739AEF) : Colors.white,
                                  clipBehavior: Clip.hardEdge,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 180,
                                        child: Column(
                                          children: [
                                             Text(
                                              "Ride by destination",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  color: currentSelectedCard == 0 ? Colors.white : const Color(0xff739AEF),),
                                            ),
                                            //image
                                            Expanded(
                                                child: Image.asset(
                                                  currentSelectedCard == 0 ? "images/img_23.png" : "images/img_24.png",
                                                  height: 30,
                                                  width: 40,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),


                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    currentSelectedCard = 1;
                                  });
                                },
                                child: Card(
                                  //  elevation: 6.0,
                                  color: currentSelectedCard == 1 ?  const Color(0xff739AEF): Colors.white ,
                                  clipBehavior: Clip.hardEdge,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 180,
                                        child: Column(
                                          children: [
                                            Text(
                                              "Ride by kilometer",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  color: currentSelectedCard ==1 ?  Colors.white: Color(0xff739AEF) ),
                                            ),
                                            //image
                                            Expanded(
                                                child: Image.asset(
                                                  currentSelectedCard == 1 ?   "images/img_23.png" : "images/img_24.png",
                                                  height: 30,
                                                  width: 40,
                                                ),),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 10,),
                        child: Card(
                          elevation: 8.0,
                          color: Colors.white,
                          clipBehavior: Clip.hardEdge,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Color(0xffD0D0D0)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //text1
                                      Row(

                                        children:  [
                                          const Text("Seats Count",style: TextStyle(color: Color(0xff019EE3)),),
                                          Image.asset('images/seats.png',height: 15,)
                                        ],
                                      ),
                                      // todo -- dropdown1
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(3),
                                                color: Color(0xff019EE3)),
                                            // width: 80,
                                            height: 20,
                                            child: DropdownButton<int>(
                                              icon: Row(
                                                // mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(seatsCount.toString(), style: TextStyle(color: Colors.white),),
                                                  
                                                  Icon(Icons.arrow_drop_down_sharp, color: Colors.white,),
                                                ],
                                              ),

                                              items: <int>[1, 2, 3, 4, 5, 6].map((int value) {
                                                return DropdownMenuItem<int>(
                                                  value: value,
                                                  child: Text(value.toString(),),
                                                );
                                              }).toList(),
                                              onChanged: (newVal) {
                                                setState(() {
                                                  seatsCount = newVal!;
                                                });
                                              },
                                            ),
                                        ),
                                      ),
                                    ],
                                  )),

                              //
                              // todo -- line
                              Padding(
                                padding: const EdgeInsets.only(right: 10, left: 80),
                                child: Container(

                                  height: 70,
                                  width: 1,
                                  color: Color(0xffD0D0D0),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children:  [
                                        Text("Bags Count",style: TextStyle(color: Color(0xff019EE3)),),
                                        Image.asset('images/bags.png',height: 15,)
                                      ],
                                    ),


                                    // todo -- dropdown2
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(3),
                                              color: Color(0xff019EE3)),
                                          // width: 80,
                                          height: 20,
                                          child: DropdownButton<int>(
                                            icon: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(bagsCount.toString(), style: TextStyle(color: Colors.white),),

                                                Icon(Icons.arrow_drop_down_sharp, color: Colors.white,),
                                              ],
                                            ),

                                            items: <int>[1, 2, 3, 4, 5].map((int value) {
                                              return DropdownMenuItem<int>(
                                                value: value,
                                                child: Text(value.toString(),),
                                              );
                                            }).toList(),
                                            onChanged: (newVal) {
                                              setState(() {
                                                bagsCount = newVal!;
                                              });
                                            },
                                          ),

                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10,),
                      //from
                      Row(
                        children: [
                          const Icon(
                            Icons.add_location_alt_outlined,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'From',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                Provider.of<AppInfo>(context).userPickUpLocation!=null ?
                                '${(Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0,24)}...' :
                                'Your current location',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      //to
                      GestureDetector(
                        onTap: () async {
                          //go to search places screen
                          var responseFromSearchScreen = await Navigator.push(context, MaterialPageRoute(builder: (c)=> SearchPlacesScreen(),),);

                          if(responseFromSearchScreen == "obtainedDropOff"){
                            //draw poly line between pick up and drop off locations.
                            await drawPolyLineFromOriginToDestination();

                            setState(() {
                              openNavigationDrawer = false;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add_location_alt_outlined,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'To',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  Provider.of<AppInfo>(context).userDropOffLocation != null
                                  ? Provider.of<AppInfo>(context).userDropOffLocation!.locationName!
                                      : 'Where to go?',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      ElevatedButton(
                        onPressed: () {
                          print("this happens..");
                          print(Provider.of<AppInfo>(context,listen: false).userDropOffLocation.toString);
                          if(Provider.of<AppInfo>(context, listen: false).userDropOffLocation != null){
                            Navigator.push(context, MaterialPageRoute(builder: (c) => PricesPage(seatsCount: seatsCount, bagsCount: bagsCount,distanceInMeters: distance,),), );
                          }
                          else{
                            AmoToast.showAmoToast("Please select the destination..", context);
                          }
                        },
                        child: Text('Request a Ride'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ) : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          currentSelectedCard = 0;
                        });
                      },
                      child: Card(
                        //  elevation: 6.0,
                        color: currentSelectedCard == 0 ?  const Color(0xff739AEF) : Colors.white,
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: 50,
                              width: 180,
                              child: Column(
                                children: [
                                  Text(
                                    "Ride by destination",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: currentSelectedCard == 0 ? Colors.white : const Color(0xff739AEF),),
                                  ),
                                  //image
                                  Expanded(
                                      child: Image.asset(
                                        currentSelectedCard == 0 ? "images/img_23.png" : "images/img_24.png",
                                        height: 30,
                                        width: 40,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),


                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          currentSelectedCard = 1;
                        });
                      },
                      child: Card(
                        //  elevation: 6.0,
                        color: currentSelectedCard == 1 ?  const Color(0xff739AEF): Colors.white ,
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: 50,
                              width: 180,
                              child: Column(
                                children: [
                                  Text(
                                    "Ride by kilometer",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: currentSelectedCard ==1 ?  Colors.white: Color(0xff739AEF) ),
                                  ),
                                  //image
                                  Expanded(
                                    child: Image.asset(
                                      currentSelectedCard == 1 ?   "images/img_23.png" : "images/img_24.png",
                                      height: 30,
                                      width: 40,
                                    ),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

// Drop Location --

              Container(
                alignment: Alignment.topLeft,
                child: const Text("Kilometer Range",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        color: Colors.black)),
              ),


              Slider(
                  value: km.toDouble()/200.0,
                  divisions: 100,
                  onChanged: (val){
                    setState(() {
                    km = (val*200).toInt();
                });
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Card(

                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("$km kilometers", style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 10,
                          color: Colors.black),),
                    ),
                  ),
                ],
              ),


              // todo-- Seats Count & bags count
              Padding(
                padding: const EdgeInsets.only(top: 10,),
                child: Card(
                  elevation: 8.0,
                  color: Colors.white,
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Color(0xffD0D0D0)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            children: [
                              //text1
                              Row(
                                children:  [
                                  const Text("Seats Count",style: TextStyle(color: Color(0xff019EE3)),),
                                  Image.asset('images/seats.png',height: 15,)
                                ],
                              ),
                              // todo -- dropdown1
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: Color(0xff019EE3)),
                                    width: 80,
                                    height: 20,
                                     child: null),
                              ),
                            ],
                          )),

                      //
                      // todo -- line
                      Padding(
                        padding: const EdgeInsets.only(right: 30, left: 80),
                        child: Container(

                          height: 70,
                          width: 1,
                          color: Color(0xffD0D0D0),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children:  [
                                Text("Bags Count",style: TextStyle(color: Color(0xff019EE3)),),
                                Image.asset('images/bags.png',height: 15,)
                              ],
                            ),


                            // todo -- dropdown2
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: Color(0xff019EE3)),
                                  width: 80,
                                  height: 20,
                                  child: null),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              const SizedBox(height: 14,),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => PricesPage(seatsCount: seatsCount,bagsCount: bagsCount,distanceInMeters: (distance * 2),),), );
                },
                child: Text('Request a Ride'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  int distance = 0;

  Future<void> drawPolyLineFromOriginToDestination() async {
    var originPosition = Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var originLatLng = LatLng(originPosition!.locationLatitude!, originPosition!.locationLongitude!);
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!, destinationPosition!.locationLongitude!);
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(message: "Please wait..",),

    );



    var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(originLatLng, destinationLatLng);

    Navigator.pop(context);
    distance = directionDetailsInfo!.distance_value!;
    
    log("these are points = ");
    log(directionDetailsInfo!.e_points!.toString());

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePointsResultList = pPoints.decodePolyline(directionDetailsInfo!.e_points!);

    pLineCoordinatesList.clear();
    if(decodedPolylinePointsResultList.isNotEmpty){
      decodedPolylinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoordinatesList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polyLineSet.clear();
   setState(() {
     Polyline polyline = Polyline(
       color: Colors.purpleAccent,
       polylineId: const PolylineId("PolylineID"),
       jointType: JointType.round,
       points: pLineCoordinatesList,
       startCap: Cap.roundCap,
       endCap: Cap.roundCap,
       geodesic: true,

     );

     polyLineSet.add(polyline);
   });

   LatLngBounds boundsLatLng;
   if(originLatLng.latitude > destinationLatLng.latitude && originLatLng.longitude > destinationLatLng.longitude){
     boundsLatLng = LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
   }
   else if(originLatLng.longitude > destinationLatLng.longitude){
     boundsLatLng = LatLngBounds(
         southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
         northeast: LatLng(destinationLatLng.latitude,originLatLng.longitude),
     );
   }

   else if(originLatLng.latitude > destinationLatLng.latitude && originLatLng.longitude > destinationLatLng.longitude){
     boundsLatLng = LatLngBounds(
       southwest: LatLng(destinationLatLng.latitude,originLatLng.longitude),
       northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
     );
   }
   else{
     boundsLatLng = LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
   }
   
   newGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65),);

   Marker originMarker = Marker(
     markerId: const MarkerId("originId"),
     infoWindow: InfoWindow(title: originPosition.locationName, snippet: 'Origin'),
     position: originLatLng,
     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
   );
    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinaitonId"),
      infoWindow: InfoWindow(title: destinationPosition.locationName, snippet: 'Destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );



    Circle originCircle = Circle(
        circleId: const CircleId('originId'),
        fillColor: Colors.green,
        radius: 12,
        strokeWidth: 3,
        strokeColor: Colors.white,
        center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId('destinationId'),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );

    setState(() {
      markersSet.add(originMarker);
      markersSet.add(destinationMarker);
      circlesSet.add(originCircle);
      circlesSet.add(destinationCircle);
    });



  }
}
