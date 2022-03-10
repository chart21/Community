import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:maptest/slideClockAnimation.dart';
import 'package:maptest/slideRightRoute.dart';
import 'package:maptest/slideTransition.dart';
import 'package:maptest/state.dart';
import 'package:maptest/timerPage.dart';
import 'bottomUserFormField.dart';
import 'countdownDesign.dart';
import 'package:flutter/scheduler.dart';

//shows all icons, fields and buttons on the bottom half of the home screen
class WholeBottomView extends StatefulWidget {
  double position;
  TextEditingController destinationController;
  final Function() notifyParent;
  List<bool> filterValues;
  final Function(int, bool) notifyFilter;
  final Function() notifyReservation;
  final Function() notifyStarted;
  final AppState appState;
//  final bool reservationSheetOpened;

  WholeBottomView(
      {Key key,
      this.position,
      //    this.showPersBottomSheetCallback,
      this.destinationController,
      this.notifyReservation,
      this.notifyStarted,
      //    this.controllerBottomSheet,
      //    this.scaffoldKey,
      this.notifyParent,
      // this.reservationSheetOpened,
      this.appState,
      this.notifyFilter,
      this.filterValues})
      : super(key: key);

  _WholeBottomViewState createState() => _WholeBottomViewState();
}

class _WholeBottomViewState extends State<WholeBottomView> {
  bool _filterPressed;
  double bottomHeight;

  @override
  void initState() {
    super.initState();
    _filterPressed = false;
    bottomHeight = 200;
  }

  refresh() {
    _planTripPresed();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Positioned(
        bottom: widget.position,
        right: 5.0,
        left: 7.0,
        child: GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dx < 0) {
              // swiping in left direction
              if (!_filterPressed) {
                _filterGotPressed();
              }
              print('Swiped left');
            }
            if (details.delta.dx > 0) {
              // swiping in right direction
              if (_filterPressed) {
                _filterGotPressed();
              }
              print('Swiped right');
            }
          },
          child: Column(
            children: <Widget>[
              widget.appState.startedTrip.started != -1 &&
                      widget.appState.openedStartedField == false
                  ? SlideClockAnimation(
                      child: Container(
                        height: 60,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 4, bottom: 0),
                        child: FittedBox(
                          child: FloatingActionButton(
                            onPressed: () {
                              print('Reservation pressed');
                              widget.notifyStarted();
                            },
                            child: TimerPage(
                              appState: widget.appState,
                              stopping: false,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Opacity(
                      opacity: 0,
                      child: Container(
                        height: 50,
                        width: 275,
                      ),
                    ),
              widget.appState.reserved != -1 &&
                      widget.appState.openedReservationField == false
                  ? SlideClockAnimation(
                      child: Container(
                        height: 60,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 4, bottom: 0),
                        child: FloatingActionButton(
                            onPressed: () {
                              print('Reservation pressed');
                              widget.notifyReservation();
                            },
                            child: CountdownFormatted(
                                duration: (widget.appState.latestStartTrip
                                    .difference(DateTime.now())),
                                onFinish: () {
                                  setState(() {
                                    widget.appState.reserved = -1;
                                  });
                                },
                                builder: (BuildContext ctx, String remaining) {
                                  return CountdownDesign(
                                    remaining: remaining,
                                    text: 'Reserved',
                                  );
                                } // 01:00:00
                                )),
                      ),
                    )
                  : Opacity(
                      opacity: 0,
                      child: Container(
                        height: 50,
                        width: 275,
                      ),
                    ),
              Container(
                height: 50,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 12, bottom: 10),
                child: IconButton(
                    onPressed: () {
                      print('gps pressed');
                    },
                    icon: Icon(MaterialIcons.getIconData("my-location"),
                        size: 40)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _filterPressed == true
                      ? MySlideTransition(
                          offsetBool: 50,
                          widthSlide: 50,
                          notifyFilter: widget.notifyFilter,
                          filterValues: widget.filterValues,
                          appState: widget.appState,
                        )
                      : _checkFilterSet() == true
                          ? RaisedButton(
                              onPressed: _resetFilter,
                              textColor: Colors.white,
                              child: Text('Reset Filter'),
                              color: Colors.black,
                            )
                          : Opacity(
                              opacity: 0,
                              child: Container(
                                height: 50,
                                width: 275,
                              ),
                            ),
                  Container(
                    height: 50,
                    child: IconButton(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 13, right: 28),
                      onPressed: () {
                        _filterGotPressed();

                        print(_filterPressed);
                      },
                      icon: Icon(MaterialCommunityIcons.getIconData("filter"),
                          size: 40),
                    ),
                  ),
                ],
              ),
              ButtonUserFormField(
                  notifyParent: refresh, appState: widget.appState)
            ],
          ),
        ),
      ),
    );
  }

  void _planTripPresed() {
    widget.notifyParent();
  }

  bool _checkFilterSet() {
    for (int i = 0; i < widget.filterValues.length; i++) {
      if (widget.filterValues[i] == false) {
        return true;
      }
    }
    return false;
  }

  void _filterGotPressed() async {
    if (_filterPressed) {
      if (widget.appState.controller != null) {
        await widget.appState.controller.reverse();
      }
      setState(() {
        _filterPressed = false;
      });
    } else {
      setState(() {
        _filterPressed = true;
      });
    }
  }

  _resetFilter() {
    for (int i = 0; i < widget.filterValues.length; i++) {
      widget.notifyFilter(i, true);
    }
  }
}
