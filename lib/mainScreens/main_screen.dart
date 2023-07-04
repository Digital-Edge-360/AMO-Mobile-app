import 'dart:async';

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
  double bottomPaddingOfMap = 0;

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

  locateUserPosition() async{
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;


    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition),);
    
    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoOrdinates(userCurrentPosition!, context);
    print('This is your address $humanReadableAddress');

    userName = userModelCurrentInfo!.name!;
    userEmail =  userModelCurrentInfo!.email!;

  }

  double searchLocationContainerHeight = 220.0;

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
      body: Stack(
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
              blackThemeGoogleMap();

              setState(() {
                bottomPaddingOfMap = 240;
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
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  openNavigationDrawer ? Icons.menu : Icons.close,
                  color: Colors.black54,
                ),
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
                  color: Colors.black54,
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
                        onPressed: () {},
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
      ),
    );
  }

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
    
    print("these are points = ");
    print(directionDetailsInfo!.e_points!.toString());

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
