import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_icons/flutter_icon_data.dart';
import 'package:flutter_icons/material_community_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maptest/countUpDesign.dart';
import 'package:maptest/countdownDesign.dart';
import 'package:maptest/secondaryPages/payment.dart';
import 'package:maptest/secondaryPages/review.dart';
import 'package:maptest/state.dart';
import 'package:maptest/swipe.dart';

import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:maptest/timerPage.dart';

import 'package:maptest/secondaryPages/logInPage.dart';

//When users reserv a rental, this BottomSheet pops up to give rental information and allows users to reservate, cancel, start or end rentals
class BottomMarkerModalSheet extends StatefulWidget {
  final String icon;
  final String description;
  final int id;
  final double price;
  final String date;
  final LatLng pickUpLocation;
  final Function(String, String, String, double, String) notifyParent;
  final AppState appState;

  const BottomMarkerModalSheet(
      {Key key,
      this.appState,
      this.date, //***Blockchain gettter */
      this.description, //***Blockchain gettter */
      this.icon,
      this.id, //***Blockchain gettter */
      this.pickUpLocation, //***Blockchain gettter */
      this.price, //***Blockchain gettter */
      this.notifyParent})
      : super(key: key);

  @override
  _BottomMarkerModalSheetState createState() => _BottomMarkerModalSheetState();
}

class _BottomMarkerModalSheetState extends State<BottomMarkerModalSheet> {
  bool endTripPressed = false;

  @override
  Widget build(BuildContext context) {
    int euPrice = widget.price.floor();
    int cePrice = (widget.price * 100).floor() - euPrice * 100;
    // String priceText = widget.price.toString() + '/min';
    String priceText = euPrice.toString().padLeft(1, '0') +
        '.' +
        cePrice.toString().padLeft(2, '0') +
        '/min';
    if (widget.appState.reserved != widget.id &&
        widget.appState.startedTrip.id != widget.id) {
      return Container(
          //height: 200,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Container(
                height: 170,
                //width: MediaQuery.of(context).size.width * 0.65,
                //color: Colors.green,
                padding: EdgeInsets.only(right: 20),
                alignment: Alignment.centerRight,
                child: widget.description.compareTo('Share&Charge') == 0
                    ? Image.asset('assets/previewIcons/station3.png')
                    : widget.description.compareTo('DriveNow') == 0
                        ? Image.asset(
                            'assets/previewIcons/BMWi3.png',
                            width: MediaQuery.of(context).size.width * 0.4,
                          )
                        : widget.description.compareTo('BlackBike') == 0
                            ? Image.asset(
                                'assets/previewIcons/cityBike.png',
                                width: MediaQuery.of(context).size.width * 0.4,
                              )
                            : widget.description.compareTo('Patagonia') == 0
                                ? Image.asset(
                                    'assets/previewIcons/yamaha.png',
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                  )
                                : widget.description.compareTo('RetroRent') == 0
                                    ? Image.asset(
                                        'assets/previewIcons/schwalbe2.png',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                      )
                                    : Icon(
                                        MaterialCommunityIcons.getIconData(
                                            widget.icon),
                                        size: 120,
                                      ),
              ),
              Column(
                //ListView hatte das Problem das man nnicht per drag down das sheet schließen konnte, vielleicht aber anderen vorteil?
                mainAxisSize: MainAxisSize.min,
                //shrinkWrap: true,

                children: <Widget>[
                  ListTile(
                    leading: Hero(
                        tag: 'tripInfo',
                        child: Icon(
                            MaterialCommunityIcons.getIconData(widget.icon))),
                    title: Text('4.5★ ' +
                        widget.description +
                        '\n' +
                        'ID: ' +
                        widget.id.toString()),
                    // trailing: Text('ID: ' + id),
                  ),
                  ListTile(
                    leading: Icon(Icons.euro_symbol),
                    title: Text(priceText),
                  ),
                  ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: Text('Return before ' + '\n' + widget.date)),
                  ListTile(
                    title: FlatButton(
                      color: Colors.black,
                      textColor: Colors.white,
                      child: Text('Reserve'),
                      onPressed: onReservePressed,
                    ),
                  )
                ],
              ),
            ],
          ));
    } else {
      print('StartedTripId' + widget.appState.startedTrip.id.toString());
      print('WidgetId:' + widget.id.toString());

      if (widget.appState.startedTrip.id != widget.id) {
        return Container(
            //height: 200,
            color: Colors.white,
            child: Stack(
              children: <Widget>[
                Container(
                  height: 170,
                  //color: Colors.green,
                  padding: EdgeInsets.only(right: 20),
                  alignment: Alignment.centerRight,
                  // child: Icon(
                  //   MaterialCommunityIcons.getIconData(widget.icon),
                  //   size: 120,
                  // ),
                  child: CountdownFormatted(
                      duration: (widget.appState.latestStartTrip
                          .difference(DateTime.now())),
                      onFinish: onCancelReservePressed,
                      builder: (BuildContext ctx, String remaining) {
                        return CountdownDesign(
                          remaining: remaining,
                          text: 'Reserved',
                        );
                      } // 01:00:00
                      ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading:
                          Icon(MaterialCommunityIcons.getIconData(widget.icon)),
                      title: Text(widget.description +
                          '\n' +
                          'ID: ' +
                          widget.id.toString()),
                      // trailing: Text('ID: ' + id),
                    ),
                    ListTile(
                      leading: Icon(Icons.euro_symbol),
                      // title: Text(widget.price.toString() + '/min'),
                      title: Text(priceText),
                    ),
                    ListTile(
                        leading: Icon(Icons.calendar_today),
                        title: Text('Return before ' + '\n' + widget.date)),
                    ListTile(
                        leading: FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Text(
                            '   Cancel\nReservation',
                          ),
                          color: Colors.red[600],
                          onPressed: onCancelReservePressed,
                        ),
                        title: FlatButton(
                          color: Colors.black,
                          textColor: Colors.white,
                          child: Text('Start Rental'),
                          onPressed: onStartRentalPressed,
                        ))
                  ],
                ),
              ],
            ));
      } else {
        return Container(
            //height: 200,
            color: Colors.white,
            child: Stack(
              children: <Widget>[
                Container(
                  height: 170,
                  //color: Colors.green,
                  padding: EdgeInsets.only(right: 20),
                  alignment: Alignment.centerRight,
                  // child: Icon(
                  //   MaterialCommunityIcons.getIconData(widget.icon),
                  //   size: 120,
                  // ),
                  //child: Stopwatch(),

                  child: !endTripPressed
                      ? TimerPage(
                          appState: widget.appState,
                          stopping: false,
                        )
                      : TimerPage(
                          appState: widget.appState,
                          stopping: true,
                        ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading:
                          Icon(MaterialCommunityIcons.getIconData(widget.icon)),
                      title: Text(widget.description +
                          '\n' +
                          'ID: ' +
                          widget.id.toString()),
                      // trailing: Text('ID: ' + id),
                    ),
                    ListTile(
                      leading: Icon(Icons.euro_symbol),
                      title: Text(priceText),
                    ),
                    ListTile(
                        leading: Icon(Icons.calendar_today),
                        title: Text('Return before ' + '\n' + widget.date)),
                    ListTile(
                        title: FlatButton(
                      color: Colors.black,
                      textColor: Colors.white,
                      child: Text('End Rental'),
                      onPressed: () {
                        onEndRentalPressed(priceText);
                      },
                    ))
                  ],
                ),
              ],
            ));
      }
      // return SwipeDetectorExample(
      //   onSwipeDown: () => print('cant close reserved offer'),
      //   onSwipeUp: () => {},

    }
  }

  onReservePressed() {
    //***Blockchain write */
    if (widget.appState.signedIn ==
        false) //only signed in users can reserve trips
      return;
    if (widget.icon.compareTo('car') == 0 &&
        widget.appState.verifiedRenter[0] == -1)
      return; //reject if renter is not verified for that object type
    if (widget.icon.compareTo('motorbike') == 0 &&
        widget.appState.verifiedRenter[1] == -1) return;
    if (widget.icon.compareTo('bike') == 0 &&
        widget.appState.verifiedRenter[2] == -1) return;
    if (widget.icon.compareTo('ev-station') == 0 &&
        widget.appState.verifiedRenter[3] == -1) return;
    if (widget.icon.compareTo('parking') == 0 &&
        widget.appState.verifiedRenter[4] == -1) return;

    if (widget.appState.reserved == -1) {
      widget.appState.reservedTrip.date = widget.date;
      widget.appState.reservedTrip.description = widget.description;
      widget.appState.reservedTrip.price = widget.price;
      widget.appState.reservedTrip.icon = widget.icon;
      widget.appState.reservedTrip.id = widget.id;
      widget.appState.reservedTrip.pickUpLocation = widget.pickUpLocation;

      widget.appState.reserved = widget.id;

      widget.appState.latestStartTrip =
          new DateTime.now().add(new Duration(minutes: 2));

      print(widget.id);
      print(widget.appState.startedTrip.id);

      setState(() {});
    } else {
      print('Already a reservation');
    }
  }

  onCancelReservePressed() {
    //***Blockchain write */
    setState(() {
      widget.appState.reserved = -1;
    });
  }

  onStartRentalPressed() {
    //***Blockchain write */
    print('rental Started');
    if (widget.appState.startedTrip.id == -1 &&
        widget.appState.reserved == widget.id) {
      setState(() {
        widget.appState.reserved = -1;
        //widget.appState.reservedTrip = new Trip();
        //widget.appState.startedTrip.id = widget.id;
        widget.appState.startedTrip = Trip.copy(widget.appState.reservedTrip);
        widget.appState.startedTrip.started = 0;
        widget.appState.startedTrip.startTime = DateTime.now();
      });
    } else {
      print('already started trip, not allowed');
    }
  }

  onEndRentalPressed(String price) async {
    //***Blockchain write */
    setState(() {
      endTripPressed = true;
    });
    int duration = DateTime.now()
        .difference(widget.appState.startedTrip.startTime)
        .inSeconds; //time elapsed in seconds since start of trip
    double totalPrice = (((duration * widget.price) / 60) * 100).floor() / 100;
    widget.appState.balance -= totalPrice;
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          new Future.delayed(new Duration(seconds: 2), () {
            Navigator.pop(context); //pop dialog
            return true;
          });
          return new WillPopScope(
              onWillPop: () async => false,
              child: new Stack(
                children: [
                  new Opacity(
                    opacity: 0.2,
                    child: const ModalBarrier(
                        dismissible: false, color: Colors.grey),
                  ),
                  Center(
                    child: new Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new CircularProgressIndicator(),
                          new Text(
                            'Getting Confirmation \n  from Rental device',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                inherit: false),
                          )
                        ],
                      ),
                      color: Colors.black,
                    ),
                  ),
                ],
              ));
        });
    if (widget.appState.reserved == widget.id) widget.appState.reserved = -1;

    setState(() {
      widget.appState.startedTrip = new Trip();
      widget.appState.startedTrip.id = -1;
      widget.appState.startedTrip.started = -1;
      endTripPressed = false;
    });
    Navigator.pop(context);
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => ReviewPage(
                date: widget.date,
                icon: widget.icon,
                id: widget.id,
                description: widget.description,
                priceText: price,
                totalSeconds: duration,
                price: widget.price)));
  }

/*
  Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new PaymentPage(
                //!
                )));
 */

/**
  reserveRide() {
    widget.notifyParent(
        widget.icon, widget.description, widget.id, widget.price, widget.date);
  }
  */

  Future<bool> _onLoading() async {
    //***Blockchain getter/ listen to events*/
    showDialog(
      context: context,
      barrierDismissible: false,
      child: new Dialog(
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new CircularProgressIndicator(),
            new Text("Loading"),
          ],
        ),
      ),
    );
    await new Future.delayed(new Duration(seconds: 3), () {
      Navigator.pop(context); //pop dialog
      return true;
    });
  }
}
