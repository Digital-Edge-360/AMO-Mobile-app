import 'dart:async';
import 'dart:developer';

import 'package:amo_cabs/mainScreens/prices_page.dart';
import 'package:amo_cabs/mainScreens/ride_by_km.dart';
import 'package:amo_cabs/mainScreens/search_places_screen.dart';
import 'package:amo_cabs/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../assistants/assistant_methods.dart';
import '../global/global.dart';
import '../infoHandler/app_info.dart';
import '../widgets/amo_toast.dart';
import '../widgets/car_type_widget.dart';
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
  double bottomPaddingOfMap = 270;

  List<LatLng> pLineCoordinatesList = [];
  Set<Polyline> polyLineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  String userName = "First Name";
  String userLastName = "Last name";
  String userPhone = "Phone";

  bool openNavigationDrawer = true;

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  static CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(22.545468, 88.342013),
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

  int _index = 0;
  int seatsCount = 1;
  int bagsCount = 1;
  bool isLoading = false;

  // ads url
  dynamic adurl ="";
  dynamic adtitle = "";

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;
    _kGooglePlex = CameraPosition(
      target: LatLng(cPosition.latitude, cPosition.longitude),
      zoom: 14.4746,
    );

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String>? userDetails = prefs.getStringList('userCurrentInfo');

    if (userDetails != null) {
      UserModel userModel = UserModel(
          id: userDetails[0],
          phoneNumber: userDetails[1],
          firstName: userDetails[2],
          lastName: userDetails[3],
          email: userDetails[4],
          offer: userDetails[4]);
      userModelCurrentInfo = userModel;
    }

    LatLng latLngPosition =
    LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition =
    CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController!.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );

    // ignore: use_build_context_synchronously
    String humanReadableAddress =
    // ignore: use_build_context_synchronously
    await AssistantMethods.searchAddressForGeographicCoOrdinates(
        userCurrentPosition!, context);
    log('This is your address $humanReadableAddress');
    userName = userModelCurrentInfo!.firstName!;
    userLastName = userModelCurrentInfo!.lastName!;
    userPhone = userModelCurrentInfo!.phoneNumber!;
  }

  double searchLocationContainerHeight = 260.0;

  void initialTask() async {
    await checkIfLocationPermissionAllowed();
    await CarTypeWidget.getCategoryDetails();

    setState(() {
      setState(() {
        isLoading = false;
      });
    });
    await locateUserPosition();
    // CarTypeWidget.getCategoryDetails();
  }

  @override
  void initState() {
    isLoading = true;
    super.initState();

    initialTask();

    // todo - ads Section
    addstwo();

  }

  int?st;

  // PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: sKey,
        bottomNavigationBar: BottomNavigationBar(
          elevation: 5,
          enableFeedback: true,
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color(0xff000000),
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 11,
            color: Colors.black,
          ),
          selectedIconTheme: const IconThemeData(
            size: 24,
            color: Colors.white,
          ),
          unselectedIconTheme: const IconThemeData(
            size: 18,
            color: Color(0xff000000),
          ),
          backgroundColor: Colors.white,
          currentIndex: _index,
          onTap: (index) {
            setState(() {
              _index = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              backgroundColor: Color(0xff009B4E),
              icon: Icon(
                Icons.location_on,
              ),
              label: 'Ride by destination',
            ),
            BottomNavigationBarItem(
                backgroundColor: Colors.blue,
                icon: Icon(Icons.social_distance_sharp),
                label: 'Ride by km'),
          ],
        ),
        body: isLoading
            ? Center(
          child: Container(
            color: Colors.white,
            height: MediaQuery.sizeOf(context).height,
            child: lottie.Lottie.asset(
              "assets/lottie/cab_loading.json",
            ),
          ),
        )
            : IndexedStack(
          key: ValueKey<int>(_index),
          sizing: StackFit.expand,
          index: _index,
          children: [
            Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  myLocationButtonEnabled: true,
                  rotateGesturesEnabled: true,
                  myLocationEnabled: true,
                  zoomControlsEnabled: true,
                  markers: markersSet,
                  circles: circlesSet,
                  padding: EdgeInsets.only(
                    top: MediaQuery.sizeOf(context).height * 0.3,
                    bottom: bottomPaddingOfMap,
                  ),
                  zoomGesturesEnabled: true,
                  initialCameraPosition: _kGooglePlex,
                  polylines: polyLineSet,
                  onMapCreated: (GoogleMapController controller) {
                    _controllerGoogleMap.complete(controller);
                    newGoogleMapController = controller;
                    // blackThemeGoogleMap();

                    setState(() {
                      bottomPaddingOfMap =
                          MediaQuery.sizeOf(context).height * 0.32;
                    });

                    locateUserPosition();
                  },
                ),

                //custom hamburger button for drawer
                // Positioned(
                //   top: 30,
                //   left: 14,
                //   child: GestureDetector(
                //     onTap: () {
                //       if (openNavigationDrawer) {
                //         sKey.currentState!.openDrawer();
                //       } else {
                //         //restart- refresh- minimize app progamitacally
                //         // SystemNavigator.pop();
                //         setState(() {
                //           openNavigationDrawer = true;
                //           pLineCoordinatesList = [];
                //           Provider.of<AppInfo>(context, listen: false)
                //               .userDropOffLocation = null;
                //
                //           polyLineSet = {};
                //
                //           markersSet = {};
                //           circlesSet = {};
                //         });
                //       }
                //     },
                //     child: Icon(
                //       // Icons.menu,
                //       openNavigationDrawer ? Icons.menu : Icons.close,
                //       color: Colors.black54,
                //     ),
                //   ),
                // ),
                Positioned(
                  top: 0,
                  child: GestureDetector(
                    onTap: () async {
                      var responseFromSearchScreen = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => SearchPlacesScreen(
                            isSource: true,
                          ),
                        ),
                      );

                      if (responseFromSearchScreen == "obtainedDropOff") {
                        await drawPolyLineFromOriginToDestination();
                      }
                    },
                    child: Container(
                      width: MediaQuery.sizeOf(context).width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: Card(
                        elevation: 5,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.add_location_alt_outlined,
                                color: Colors.green,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'From',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    Provider.of<AppInfo>(context)
                                        .userPickUpLocation !=
                                        null
                                        ? (Provider.of<AppInfo>(context)
                                        .userPickUpLocation!
                                        .locationName!)
                                        .length >
                                        20
                                        ? '${(Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0, 20)}...'
                                        : '${(Provider.of<AppInfo>(context).userPickUpLocation!.locationName!)}'
                                        : 'Your current location',
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
                    duration: const Duration(milliseconds: 120),
                    child: Container(
                      height: MediaQuery.sizeOf(context).height * 0.29,
                      decoration: const BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                        ),
                        child: Column(
                          children: [
                            //ride by destination or ride by km

                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                              ),
                              child: Card(
                                elevation: 8.0,
                                color: Colors.white,
                                clipBehavior: Clip.hardEdge,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Color(0xffD0D0D0)),
                                  borderRadius:
                                  BorderRadius.circular(10.0),
                                ),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            //text1
                                            Row(
                                              children: [
                                                const Text(
                                                  "Seats Count",
                                                  style: TextStyle(
                                                      color: Color(
                                                          0xff019EE3)),
                                                ),
                                                Image.asset(
                                                  'images/seats.png',
                                                  height: 15,
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  top: 5),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(3),
                                                    color: const Color(
                                                        0xff019EE3)),
                                                // width: 80,
                                                height: 20,
                                                child:
                                                DropdownButton<int>(
                                                  elevation: 4,
                                                  underline: Container(),
                                                  icon: Row(
                                                    // mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        seatsCount
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors
                                                                .white),
                                                      ),
                                                      const Icon(
                                                        Icons
                                                            .arrow_drop_down_sharp,
                                                        color:
                                                        Colors.white,
                                                      ),
                                                    ],
                                                  ),
                                                  items: <int>[
                                                    1,
                                                    2,
                                                    3,
                                                    4,
                                                    5,
                                                    6,
                                                    7,
                                                    8,
                                                    9,
                                                    10,
                                                  ].map((int value) {
                                                    return DropdownMenuItem<
                                                        int>(
                                                      value: value,
                                                      child: Text(
                                                        value.toString(),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (newVal) {
                                                    setState(() {
                                                      seatsCount =
                                                      newVal!;
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
                                      padding: const EdgeInsets.only(
                                          right: 10, left: 80),
                                      child: Container(
                                        height: 70,
                                        width: 1,
                                        color: const Color(0xffD0D0D0),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                "Bags Count",
                                                style: TextStyle(
                                                    color: Color(
                                                        0xff019EE3)),
                                              ),
                                              Image.asset(
                                                'images/bags.png',
                                                height: 15,
                                              )
                                            ],
                                          ),

                                          // todo -- dropdown2
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                top: 5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(3),
                                                  color: const Color(
                                                      0xff019EE3)),
                                              // width: 80,
                                              height: 20,
                                              child: DropdownButton<int>(
                                                elevation: 4,
                                                underline: Container(),
                                                icon: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    Text(
                                                      bagsCount
                                                          .toString(),
                                                      style:
                                                      const TextStyle(
                                                          color: Colors
                                                              .white),
                                                    ),
                                                    const Icon(
                                                      Icons
                                                          .arrow_drop_down_sharp,
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                                items: <int>[
                                                  1,
                                                  2,
                                                  3,
                                                  4,
                                                  5
                                                ].map((int value) {
                                                  return DropdownMenuItem<
                                                      int>(
                                                    value: value,
                                                    child: Text(
                                                      value.toString(),
                                                    ),
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

                            //to
                            GestureDetector(
                              onTap: () async {
                                //go to search places screen
                                var responseFromSearchScreen =
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (c) => SearchPlacesScreen(
                                      isSource: false,
                                    ),
                                  ),
                                );

                                if (responseFromSearchScreen ==
                                    "obtainedDropOff") {
                                  //draw poly line between pick up and drop off locations.
                                  await drawPolyLineFromOriginToDestination();

                                  // setState(() {
                                  //   openNavigationDrawer = false;
                                  // });
                                }
                              },
                              child: Card(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.add_location_alt_outlined,
                                        color: Color(0xff009B4E),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'To',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            Provider.of<AppInfo>(context)
                                                .userDropOffLocation !=
                                                null
                                                ? Provider.of<AppInfo>(
                                                context)
                                                .userDropOffLocation!
                                                .locationName!
                                                : 'Where to go?',
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            ElevatedButton(
                              onPressed: () {
                                log("Request a ride button on maps page got clicked..");
                                if (Provider.of<AppInfo>(context,
                                    listen: false)
                                    .userDropOffLocation !=
                                    null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (c) => PricesPage(
                                        seatsCount: seatsCount,
                                        bagsCount: bagsCount,
                                        distanceInMeters: distance,
                                        rideByKm: false,
                                      ),
                                    ),
                                  );
                                } else {
                                  AmoToast.showAmoToast(
                                      "Please select the destination..",
                                      context);
                                }
                              },
                              child: Text('Request a Ride'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff009B4E),
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
            const RideByKm(),
          ],
        ));
  }

  int distance = 0;

  Future<void> drawPolyLineFromOriginToDestination() async {
    var originPosition =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var originLatLng = LatLng(
        originPosition!.locationLatitude!, originPosition.locationLongitude!);
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!,
        destinationPosition.locationLongitude!);
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Please wait..",
      ),
    );

    var directionDetailsInfo =
    await AssistantMethods.obtainOriginToDestinationDirectionDetails(
        originLatLng, destinationLatLng);

    // ignore: use_build_context_synchronously
    Navigator.pop(context);

    distance = directionDetailsInfo!.distance_value!;

    log("these are points = ");
    log(directionDetailsInfo.e_points!.toString());

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePointsResultList =
    pPoints.decodePolyline(directionDetailsInfo!.e_points!);

    pLineCoordinatesList.clear();
    if (decodedPolylinePointsResultList.isNotEmpty) {
      decodedPolylinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoordinatesList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polyLineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        color: Colors.blue,
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
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    newGoogleMapController!.animateCamera(
      CameraUpdate.newLatLngBounds(boundsLatLng, 65),
    );

    Marker originMarker = Marker(
      markerId: const MarkerId("originId"),
      infoWindow:
      InfoWindow(title: originPosition.locationName, snippet: 'Origin'),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );
    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinaitonId"),
      infoWindow: InfoWindow(
          title: destinationPosition.locationName, snippet: 'Destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    Circle originCircle = Circle(
      circleId: const CircleId('originId'),
      fillColor: Colors.lightGreenAccent,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId('destinationId'),
      fillColor: Colors.redAccent,
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

  //add - pop up logic-1
  setads()async{
    DateTime now = DateTime.now();

    String formattedDate = DateFormat('EEEE,MMM,d,yyyy').format(now);
    //log("set log ads${now}");
    // SharedPreferences
    final SharedPreferences perfs = await SharedPreferences.getInstance();



    if (perfs.getString("adsDate") == null) {
      //show ads
      st=0;
      perfs.setString("adsDate",formattedDate);
      log("set log null ads$formattedDate");
      setState((){});

      perfs.setString("TwoCount","1");


      // todo --test firebase
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("ads").get();
//sub-patch
      for (int i = 0; i < querySnapshot.size; i++) {
        var a = querySnapshot.docs[i];

        String sts="855A1MOu8D4GvI56O5Vv";
        //log("firstName: ${a['image']}");
        log(a.id);
        if ( sts==a.id){
          //log(st!);
          setState((){});
          adurl="${a['image']}";
          adtitle = "${a['title']}";

          //log(adurl);
          log("firstName: ${a['image']}");
        }
      }
//end test

      Dialogs.materialDialog(
          customView: Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(adurl),
              ),
            ),
          ),
          context: context,
          actions: [
            IconsOutlineButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: 'close',
              iconData: Icons.cancel_outlined,
              textStyle: TextStyle(color: Colors.grey,fontFamily: "Poppins"),
              iconColor: Colors.grey,
            ),
          ]);

      // void setToast(BuildContext context){
      //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text("Sending Message"),
      //   ));
      // }
      //  return st;
    } else if (perfs.getString("adsDate")!= formattedDate){

      perfs.setString("TwoCount","1");


      // todo --test firebase
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("ads").get();
//sub-patch
      for (int i = 0; i < querySnapshot.size; i++) {
        var a = querySnapshot.docs[i];

        String sts="855A1MOu8D4GvI56O5Vv";

        //log("firstName: ${a['image']}");

        log(a.id);

        if ( sts==a.id){
          //log(st!);

          setState((){});
          adurl="${a['image']}";
          adtitle = "${a['title']}";
          log(adurl);

          log("firstName: ${a['image']}");
        }
      }
      //show ads
      // one time
      perfs.setString("adsDate",formattedDate);
      log("set log ads$formattedDate");
      log(perfs.getString("adsDate").toString());
      st=0;
      setState(() {
      });

      Dialogs.materialDialog(
          customView: Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(adurl),
              ),
            ),
          ),
          context: context,
          actions: [
            IconsOutlineButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: 'close',
              iconData: Icons.cancel_outlined,
              textStyle: TextStyle(color: Colors.grey,fontFamily: "Poppins"),
              iconColor: Colors.grey,
            ),
          ]);

      //return st;

    }else if(perfs.getString("adsDate")==formattedDate){

      perfs.setString("TwoCount","1");

      // todo --test firebase
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("ads").get();
//sub-patch
      for (int i = 0; i < querySnapshot.size; i++) {
        var a = querySnapshot.docs[i];

        String sts="855A1MOu8D4GvI56O5Vv";
        //log("firstName: ${a['image']}");
        log(a.id);
        if ( sts==a.id){
          //log(st!);
          setState((){});
          adurl="${a['image']}";
          adtitle = "${a['title']}";
          //log(adurl);
          log("firstName: ${a['image']}");
        }
      }

      st=1;
      log("set log not ads$formattedDate");
      log(perfs.getString("adsDate").toString());
      log("$st");
//don't use this

      // Dialogs.materialDialog(
      //     customView: Container(
      //       width: MediaQuery.of(context).size.width,
      //       height: 200,
      //       decoration: BoxDecoration(
      //         image: DecorationImage(
      //           fit: BoxFit.fill,
      //           image: NetworkImage(adurl),
      //         ),
      //       ),
      //     ),
      //     context: context,
      //     actions: [
      //       IconsOutlineButton(
      //         onPressed: () {
      //           Navigator.of(context).pop();
      //         },
      //         text: 'close',
      //         iconData: Icons.cancel_outlined,
      //         textStyle: TextStyle(color: Colors.grey,fontFamily: "Poppins"),
      //         iconColor: Colors.grey,
      //       ),
      //     ]);


      setState(() {
      });
      // return st;
    }

  }
  setads2()async{
    DateTime now = DateTime.now();

    String formattedDate = DateFormat('EEEE,MMM,d,yyyy').format(now);
    //log("set log ads${now}");
    // SharedPreferences
    final SharedPreferences perfs = await SharedPreferences.getInstance();



    if (perfs.getString("adsDate2") == null) {
      //show ads
      st=0;
      perfs.setString("adsDate2",formattedDate);
      log("set log null ads$formattedDate");
      setState((){});

      perfs.setString("TwoCount","0");


      // todo --test firebase
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("ads").get();
//sub-patch
      for (int i = 0; i < querySnapshot.size; i++) {
        var a = querySnapshot.docs[i];

        String sts="855A1MOu8D4GvI56O5Vv";
        //log("firstName: ${a['image']}");
        log(a.id);
        if ( sts==a.id){
          //log(st!);
          setState((){});
          adurl="${a['image']}";
          adtitle = "${a['title']}";
          //log(adurl);
          log("firstName: ${a['image']}");

        }
      }
//end test/>
      Dialogs.materialDialog(
          customView: Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(adurl),
              ),
            ),
          ),
          context: context,
          actions: [
            IconsOutlineButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: 'close',
              iconData: Icons.cancel_outlined,
              textStyle: TextStyle(color: Colors.grey,fontFamily: "Poppins"),
              iconColor: Colors.grey,
            ),
          ]);

      // void setToast(BuildContext context){
      //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text("Sending Message"),
      //   ));
      // }
      //  return st;
    } else if (perfs.getString("adsDate2")!= formattedDate){

      perfs.setString("TwoCount","0");


      // todo --test firebase
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("ads").get();
//sub-patch
      for (int i = 0; i < querySnapshot.size; i++) {
        var a = querySnapshot.docs[i];

        String sts="855A1MOu8D4GvI56O5Vv";

        perfs.setString("TwoCount","0");
        //log("firstName: ${a['image']}");

        log(a.id);

        if ( sts==a.id){
          //log(st!);
          setState((){});
          adurl="${a['image']}";
          adtitle = "${a['title']}";
        }
      }

      //show ads
      // one time
      perfs.setString("adsDate2",formattedDate);
      log("set log ads$formattedDate");
      log(perfs.getString("adsDate2").toString());
      st=0;
      setState(() {
      });

      Dialogs.materialDialog(
          customView: Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(adurl),
              ),
            ),
          ),
          context: context,
          actions: [
            IconsOutlineButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: 'close',
              iconData: Icons.cancel_outlined,
              textStyle: TextStyle(color: Colors.grey,fontFamily: "Poppins"),
              iconColor: Colors.grey,
            ),
          ]);

      //return st;

    }else if(perfs.getString("adsDate2")==formattedDate){

      perfs.setString("TwoCount","0");

      //  firebase get
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("ads").get();
//sub-patch
      for (int i = 0; i < querySnapshot.size; i++) {
        var a = querySnapshot.docs[i];

        String sts="855A1MOu8D4GvI56O5Vv";
        //log("firstName: ${a['image']}");
        log(a.id);
        if ( sts==a.id){
          //log(st!);
          setState((){});
          adurl="${a['image']}";
          adtitle = "${a['title']}";
          //log(adurl);
          log("firstName: ${a['image']}");
        }
      }
      st=1;
      log("set log not ads$formattedDate");
      log(perfs.getString("adsDate2").toString());
      log("$st");
//don't use this only test
//       Dialogs.materialDialog(
//           customView: Container(
//             width: MediaQuery.of(context).size.width,
//             height: 200,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 fit: BoxFit.fill,
//                 image: NetworkImage(adurl),
//               ),
//             ),
//           ),
//           context: context,
//           actions: [
//             IconsOutlineButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               text: 'close',
//               iconData: Icons.cancel_outlined,
//               textStyle: TextStyle(color: Colors.grey,fontFamily: "Poppins"),
//               iconColor: Colors.grey,
//             ),
//           ]);
       setState(() {
       });
      // return st;
    }

  }
  //two ads-- Show logic
  addstwo() async {

    final SharedPreferences perfs = await SharedPreferences.getInstance();

    if (perfs.getString("TwoCount")==null){

      setads();

    }else if(perfs.getString("TwoCount")=="0"){

      setads();


    }else if (perfs.getString("TwoCount")=="1"){

      setads2();

    }

  }

}
