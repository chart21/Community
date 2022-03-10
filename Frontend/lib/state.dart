import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

//Global singleton that handles Global appstate
class AppState extends StatelessWidget {
  AppState({Key key}) : super(key: key);

  bool signedIn = false; //***local file read */
  int reserved = -1; //***Blockchain read */

  double balance = 50; //***Blockchain read */

  var verifiedRenter = [1, -1, 1, 1, 1]; //***Blockchain read */
  var verifiedLessor = [1, 1, 1, 0, 1]; //***Blockchain read */

  Trip reservedTrip = new Trip(); //reservedTrip //***Blockchain read */

  Trip startedTrip = new Trip(); //started trip //***Blockchain read */

  DateTime latestStartTrip;
  bool openedReservationField = false;
  bool openedStartedField = false;
  //_AppStateState createState() => _AppStateState();

  AnimationController
      controller; //filter slide in animation controller Animaiton

  Completer<GoogleMapController> mapsController =
      Completer(); //Google Maps controller
/*
 bool getSignedIn() {
    return signedIn;
  }
 */

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

/** 
class _AppStateState extends State<AppState> {
  // bool signedIn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.signedIn = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  setSignedIn(bool val) {
    if (val = widget.signedIn) return;
    setState(() {
      widget.signedIn = val;
    });
  }
}
*/
class Trip {
  int id = -1;
  String icon;
  String date;
  double price;
  String description;
  LatLng pickUpLocation;
  LatLng dropOffLocation;
  int latDroOff;
  int dropOffRange;
  String reservedAddress;
  bool reserved;
  int started = -1;
  int index;
  DateTime startTime;
  //int manufacturer;
  String address;

  static Trip copy(Trip trip) {
    Trip copiedTrip = new Trip();
    copiedTrip.id = trip.id;
    copiedTrip.icon = trip.icon;
    copiedTrip.date = trip.date;
    copiedTrip.price = trip.price;
    copiedTrip.description = trip.description;
    copiedTrip.pickUpLocation = trip.pickUpLocation;
    copiedTrip.dropOffLocation = trip.dropOffLocation;
    copiedTrip.reservedAddress = trip.reservedAddress;
    copiedTrip.reserved = trip.reserved;
    copiedTrip.started = trip.started;
    copiedTrip.index = trip.index;
    copiedTrip.startTime = trip.startTime;
    copiedTrip.address = trip.address;

    return copiedTrip;
  }
}

/**
  address carOwnerAddress; 
    int64 startTime;
    int64 endDate; //repeat to let the client know
    int32 endTime; //hours - was added by 1000 to ensure 0000 is not possible
    int64 latpickupLocation;
    int64 longpickupLocation;
    int64 latdropofflocation;
    int64 longdropOffLocation;
    int32 dropoffRange;
    address reservedAdress;
    bool reserved;
    uint256 started; //Block number of start time
    uint256 index;
    int32 id;
    uint256 price; //next


 */
