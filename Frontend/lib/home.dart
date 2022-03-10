import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maptest/myDrawer.dart';

import 'state.dart';

import 'WholeBottomView.dart';
import 'myMap.dart';
import 'datepicker.dart';
import 'bottomMarkerModalSheet.dart';

import 'swipe.dart';

//home screen of the app that displays the Map and all the icons on top
class HomePage extends StatefulWidget {
  final AppState appState;
  HomePage({Key key, this.appState})
      : super(key: key); //takes in the global Singleton Appstate as parameter

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //PermissionStatus _status;

  PersistentBottomSheetController
      _controllerBottomSheet; //controls the date schedule Bottom sheet
  double
      bottomHeight; //controls the hight of the widgets on the bottom (they have to move up if a bottom sheet is open)
  bool
      showScheduleResetButton; //if a schedule is set it shows a button to reset the schedule
  final _scaffoldKey = new GlobalKey<
      ScaffoldState>(); //identifies the Scaffold to be used in other widgets
  VoidCallback
      _showPersBottomSheetCallback; //shows the Bottomsheet after users tab on a trip
  //bool _filterPressed;

  DateTime selectedBeginningDate =
      DateTime.now(); //standard schedule is always at the current date
  DateTime selectedEndDate = DateTime.now();

  TimeOfDay selectedBeginningTime = TimeOfDay.now();
  TimeOfDay selectedEndTime;

  // bool countdownBottomSheetOpen = false;

  //bool _privateCar = true;
  //bool _fleetCar = true;
  //bool _bike = ;
  //bool _chargingStation;
  //bool _parklingLot;
  List<bool> filterValues = [
    //***read from local file */
    true,
    true,
    true,
    true,
    true
  ]; //filter Values wether all object types (car, charging station,...) should be displayed

  @override
  void initState() {
    super.initState();
    bottomHeight = 40;
    _showPersBottomSheetCallback = _showBottomSheet;

    _controller = widget.appState.mapsController;

    if (selectedBeginningTime.hour < 23)
      selectedEndTime = TimeOfDay(
          hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);
    else
      selectedEndTime = TimeOfDay(hour: 23, minute: 59);

    //  _filterPressed = false;
  }

  bool signedIn = false;

  Completer<GoogleMapController>
      _controller; //contoller that handles interactions with Google Map widget
  final Set<Polygon> _polygons =
      {}; //polygons that define drop off area of each sharing object

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          canvasColor: Colors.white,
          primaryColor: Colors.black,
          bottomSheetTheme:
              BottomSheetThemeData(backgroundColor: Colors.transparent)),
      home: Scaffold(
        key: _scaffoldKey,
        drawer: MyDrawer(
          // getSignedIn: getLogin,
          // setSignedIn: setLogin,
          //  signedIn: signedIn,
          appState: widget.appState,
        ),
        body: Stack(children: <Widget>[
          //Stack orders widgets on top of each other
          //Google Maps
          /*
        
         myMap(
            notifyParent: _showMarkerBottomSheet,
            notifyParentClosed: closePersMarkerBottomSheet,
            appState: widget.appState,
          )
        
        
        
         */
          myMap(
            //element on the bottom of the stack is the Google Map
            notifyParent: _showMarkerBottomSheet,
            notifyParentClosed: closePersMarkerBottomSheet,
            appState: widget.appState,
            controller: _controller,
            polygons: _polygons,
          ),

          //Menu

          Positioned(
            //menu button is placed on the top left corner of Google Maps
            top: 30,
            left: 5,
            child: IconButton(
              icon: Icon(MaterialIcons.getIconData("menu"), size: 40),
              onPressed: () {
                print('menu pressed');
                _scaffoldKey.currentState.openDrawer();
                //_showMarkerBottomSheet();
              },
            ),
          ),

          //temp marker
          /*
          Center(
            child: IconButton(
              onPressed: () {
                _showMarkerBottomSheet(
                    0.08, '27.06. 13:00', 'BMW car', 'car', '9845621');
              },
              icon: Icon(
                MaterialCommunityIcons.getIconData('car'),
                color: Colors.blue,
              ),
            ),
          ),
          	*/

          /*
             * 
             *
             * 
             *  Positioned(
            bottom: 300,
            left: 20,
            child: IconButton(
              onPressed: () {
                _showMarkerBottomSheet(0.02, '-', 'Daimler Charging Station',
                    'ev-station', 8452134);
              },
              icon: Icon(
                MaterialCommunityIcons.getIconData('ev-station'),
                color: Colors.green,
              ),
            ),
          ),
             * 
             * 





             */

          //BottomSheet
          Positioned(
            //Swipe Detector for showing the Schedule bottom sheet is placed all the way at the bottom
            bottom: 0,
            left: 0,
            right: 0,
            height: bottomHeight + 40,
            child: SwipeDetectorExample(
              onSwipeUp: () {
                print("SwipedUp");
                _planTripPresed();
              },
              onSwipeDown: () {
                print("SwipedDown");
                _planTripPresed();
              },

              //opacity: 0.0,
              child: Opacity(
                //invisible object
                opacity: 0,
                child: Text("Jo"),
              ),
            ),
          ),

          //All widgets on the Bottom
          WholeBottomView(
            //Contains all the buttons and field on the lower half of the screen
            appState: widget.appState,
            position: bottomHeight,
            notifyParent: refresh,
            notifyFilter: _updateFilterValues,
            notifyReservation: onReservationPressed,
            notifyStarted: onStartedTripPressed,
            filterValues: filterValues,
            //  reservationSheetOpened: countdownBottomSheetOpen,
          ),
          showScheduleResetButton ==
                  true //If schedule is set, a button is shown to reset the schedule
              ? Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.all(0),
                      child: Text('Reset Schedule'),
                      color: Colors.white,
                      textColor: Colors.black,
                      onPressed: () async {
                        refreshDateTimePicker(
                            DateTime.now(),
                            TimeOfDay.now(),
                            DateTime.now(),
                            TimeOfDay(
                                hour: TimeOfDay.now().hour + 1,
                                minute: TimeOfDay.now().minute));
                        setState(() {
                          showScheduleResetButton = false;
                        });
                      },
                    ),
                  ),
                )
              : Opacity(opacity: 1) //otherwise invisible object is hown
        ]),
      ),
    );
  }

// Section for the Schedule Bottom Sheet
  void _showBottomSheet() {
    setState(() {
      _showPersBottomSheetCallback = null;
      bottomHeight = 100;
      showScheduleResetButton = false;
    });
    _updateTime();
    _controllerBottomSheet =
        _scaffoldKey.currentState.showBottomSheet((context) {
      return Container(
        alignment: Alignment.center,
        height: 101,
        margin: EdgeInsets.only(left: 7, right: 5),
        color: Colors.white,
        child: MyDatePicker(
          notifyParent: refreshDateTimePicker,
          selectedBeginningDate: selectedBeginningDate,
          selectedBeginningTime: selectedBeginningTime,
          selectedEndDate: selectedEndDate,
          selectedEndTime: selectedEndTime,
        ),
      );
    });

    _controllerBottomSheet.closed.whenComplete(() {
      if (mounted) {
        setState(() {
          _showPersBottomSheetCallback = _showBottomSheet;
          bottomHeight = 40;
          _controllerBottomSheet = null;
        });
        if (scheduleSet() == true) {
          setState(() {
            showScheduleResetButton = true;
          });
        }
      }
    });
  }

  //Section for the tripÍnfo bottom sheet
  void _showMarkerBottomSheet(double price, String date, String description,
      String icon, int id, LatLng location, String address) async {
    closePersMarkerBottomSheet();
    if (_controllerBottomSheet != null) await _controllerBottomSheet.closed;
    setState(() {
      _showPersBottomSheetCallback = null;

      bottomHeight += 40;
    });

    _controllerBottomSheet =
        _scaffoldKey.currentState.showBottomSheet((context) {
      return BottomMarkerModalSheet(
        appState: widget.appState,
        icon: icon,
        price: price,
        date: date,
        description: description,
        id: id,
        pickUpLocation: location,
      );
    });
    if (id == widget.appState.reserved) {
      setState(() {
        widget.appState.openedReservationField = true;
      });
    } else {
      setState(() {
        widget.appState.openedReservationField = false;
      });
    }
    if (id == widget.appState.startedTrip.id) {
      setState(() {
        widget.appState.openedStartedField = true;
      });
    } else {
      setState(() {
        widget.appState.openedStartedField = false;
      });
    }

    _controllerBottomSheet.closed.whenComplete(() {
      if (mounted) {
        setState(() {
          _showPersBottomSheetCallback = _showBottomSheet;
          bottomHeight -= 40;
          _controllerBottomSheet = null;
          // countdownBottomSheetOpen = false;
        });
      }
      //if (id == widget.appState.reserved) {
      setState(() {
        widget.appState.openedReservationField = false;
        widget.appState.openedStartedField = false;
      });
      // }
    });

    void _showReservedTripBottomSheet(icon, description, id, price, date) {}

    /*
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomMarkerModalSheet(
            icon: icon,
            price: price,
            date: date,
            description: description,
            id: id,
          );
        });
        */
  }

  //when user descides to reserve a trip
  void onReservationPressed() async {
    // closePersMarkerBottomSheet();
    // if (_controllerBottomSheet != null) await _controllerBottomSheet.closed;
    await closePersMarkerBottomSheet();
    _showMarkerBottomSheet(
        widget.appState.reservedTrip.price,
        widget.appState.reservedTrip.date,
        widget.appState.reservedTrip.description,
        widget.appState.reservedTrip.icon,
        widget.appState.reservedTrip.id,
        widget.appState.reservedTrip.pickUpLocation,
        widget.appState.startedTrip.address);

    //vation();

    //final GoogleMapController controller = await _controller.future;
    _polygons.clear();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: widget.appState.reservedTrip.pickUpLocation, zoom: 14.4746)));

    //refresh location
    //setState(() {});
  }

  //when user decides to start a trip
  void onStartedTripPressed() async {
    // closePersMarkerBottomSheet();
    // if (_controllerBottomSheet != null) await _controllerBottomSheet.closed;
    await closePersMarkerBottomSheet();
    _showMarkerBottomSheet(
        widget.appState.startedTrip.price,
        widget.appState.startedTrip.date,
        widget.appState.startedTrip.description,
        widget.appState.startedTrip.icon,
        widget.appState.startedTrip.id,
        widget.appState.startedTrip.pickUpLocation,
        widget.appState.startedTrip.address);

    //vation();

    //final GoogleMapController controller = await _controller.future;
    _polygons.clear();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: widget.appState.startedTrip.pickUpLocation, zoom: 14.4746)));

    //refresh location
    //setState(() {});
  }

//when user swipes or closes the bottom sheet
  void closePersMarkerBottomSheet() async {
    if (_controllerBottomSheet != null && widget.appState.reserved == -1) {
      _controllerBottomSheet.close();
      await _controllerBottomSheet.closed;
      _controllerBottomSheet = null;
    } else {
      setState(() {});
      if (_controllerBottomSheet != null) {
        _controllerBottomSheet.close();
        _controllerBottomSheet = null;
      }
    }
  }

  void closeBottomSheet() {
    if (_controllerBottomSheet != null) {
      _controllerBottomSheet.close();
      _controllerBottomSheet = null;
    }
  }

//when user tabs on the schedule button, show or closes the schedule bottom sheet
  void _planTripPresed() {
    print('Pressed');

    if (_controllerBottomSheet == null) {
      _showBottomSheet();
    } else {
      _controllerBottomSheet.close();
      _controllerBottomSheet = null;
    }
  }

  refresh() {
    _planTripPresed();
  }

//refreshes the DateTime schedule to update non-sense filters (e.g. desired beginning or end of rental is in the past)
  refreshDateTimePicker(bd, bt, ed, et) {
    setState(() {
      selectedBeginningDate = bd;
      selectedBeginningTime = bt;
      selectedEndDate = ed;
      selectedEndTime = et;
    });
  }

  _updateTime() {
    if (selectedBeginningDate.isBefore(DateTime.now())) {
      setState(() {
        selectedBeginningDate = DateTime.now();
      });
    }
    if (selectedEndDate.isBefore(DateTime.now())) {
      setState(() {
        selectedEndDate = DateTime.now();
      });
    }
    if (selectedBeginningDate.month == DateTime.now().month &&
        selectedBeginningDate.day == DateTime.now().day) {
      if (selectedBeginningTime.hour < TimeOfDay.now().hour ||
          (selectedBeginningTime.hour == TimeOfDay.now().hour &&
              selectedBeginningTime.minute < TimeOfDay.now().minute)) {
        setState(() {
          selectedBeginningTime = TimeOfDay.now();
        });
      }
    }

    if (selectedEndDate.month == DateTime.now().month &&
        selectedEndDate.day == DateTime.now().day) {
      if (selectedEndTime.hour < TimeOfDay.now().hour ||
          (selectedEndTime.hour == TimeOfDay.now().hour &&
              selectedEndTime.minute < TimeOfDay.now().minute)) {
        setState(() {
          selectedBeginningTime = TimeOfDay.now();
          selectedEndTime = TimeOfDay.now();
        });
      }
    }
  }

  _updateFilterValues(int index, bool values) {
    setState(() {
      filterValues[index] = values;
    });
  }

  setLogin(bool val) {
    if (signedIn != val) {
      setState(() {
        signedIn = val;
      });
    }
  }

  bool getLogin() {
    return signedIn;
  }

  bool scheduleSet() {
    DateTime now = DateTime.now();

    if (selectedBeginningDate.difference(now).inDays > 1 ||
        selectedEndDate.difference(now).inDays > 1) {
      return true;
    } else {
      if (selectedBeginningTime.hour != now.hour)
        return true;
      else {
        if (selectedBeginningTime.minute > now.minute + 30) return true;
      }

      if (selectedEndTime.hour != now.hour + 1)
        return true;
      else {
        if (selectedEndTime.minute > now.minute + 30 ||
            selectedEndTime.minute < now.minute - 30)
          return true; // standard schedule is one hour
      }
    }

    return false;
  }
}
