import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

//implements date and time picking lofic for offering a rental
class MyDatePickerOffer extends StatefulWidget {
  final Function(DateTime, TimeOfDay, DateTime, TimeOfDay) notifyParent;
  DateTime selectedBeginningDate;
  DateTime selectedEndDate;
  TimeOfDay selectedBeginningTime;
  TimeOfDay selectedEndTime;

  MyDatePickerOffer(
      {Key key,
      this.notifyParent,
      this.selectedBeginningDate,
      this.selectedBeginningTime,
      this.selectedEndTime,
      this.selectedEndDate})
      : super(key: key);

  _MyDatePickerOfferState createState() => _MyDatePickerOfferState();
}

class _MyDatePickerOfferState extends State<MyDatePickerOffer> {
  //DateTime selectedDate = dNow;
  // DateTime selectedBeginningDate = dNow;
  // DateTime selectedEndDate = dNow;
  // TimeOfDay selectedBeginningTime = tNow;
//  TimeOfDay selectedEndTime =
//      TimeOfDay(hour: tNow.hour + 1, minute: tNow.minute);

  DateTime selectedBeginningDate;
  DateTime selectedEndDate;
  TimeOfDay selectedBeginningTime;
  TimeOfDay selectedEndTime;

  bool _immideatlySelected = false;
  bool _noEndSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedBeginningDate = widget.selectedBeginningDate;
    selectedEndDate = widget.selectedEndDate;
    selectedBeginningTime = widget.selectedBeginningTime;
    selectedEndTime = widget.selectedEndTime;
  }

  var months = [
    'January',
    'Febuary',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  Future<Null> _selectEndTime() async {
    final TimeOfDay picked = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.lerp(ThemeData.light(), ThemeData.dark(), 2.1),
          child: child,
        );
      },
    );

    if (picked != null && picked != selectedBeginningTime)
      setState(() {
        selectedEndTime = picked;
      });

    if (selectedBeginningDate.year == selectedEndDate.year &&
        selectedBeginningDate.month == selectedEndDate.month &&
        selectedBeginningDate.day == selectedEndDate.day &&
        (selectedBeginningTime.hour > selectedEndTime.hour ||
            ((selectedBeginningTime.hour == selectedEndTime.hour) &&
                selectedBeginningTime.minute > selectedEndTime.minute))) {
      setState(() {
        selectedBeginningTime = picked;
      });
      _updateTime();
    }
  }

  Future<Null> _selectStartTime() async {
    final TimeOfDay picked = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.lerp(ThemeData.light(), ThemeData.dark(), 2.1),
          child: child,
        );
      },
    );

    if (picked != null && picked != selectedBeginningTime)
      setState(() {
        selectedBeginningTime = picked;
      });
    if (selectedBeginningDate.year == selectedEndDate.year &&
        selectedBeginningDate.month == selectedEndDate.month &&
        selectedBeginningDate.day == selectedEndDate.day &&
        (selectedBeginningTime.hour > selectedEndTime.hour ||
            ((selectedBeginningTime.hour == selectedEndTime.hour) &&
                selectedBeginningTime.minute > selectedEndTime.minute))) {
      setState(() {
        selectedEndTime = picked;
      });
    }
    _updateTime();
  }

  Future<Null> _selectStartDate(BuildContext context) async {
    DateTime dNow = DateTime.now();

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedBeginningDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(dNow.year, dNow.month, dNow.day),
      lastDate: DateTime(dNow.year, dNow.month + 1, dNow.day - 3),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.lerp(ThemeData.light(), ThemeData.dark(), 2.1),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedBeginningDate)
      setState(() {
        selectedBeginningDate = picked;
      });
    if (selectedBeginningDate.isAfter(selectedEndDate)) {
      setState(() {
        selectedEndDate = selectedBeginningDate;
      });
    }
    if (selectedBeginningDate.year == selectedEndDate.year &&
        selectedBeginningDate.month == selectedEndDate.month &&
        selectedBeginningDate.day == selectedEndDate.day &&
        (selectedBeginningTime.hour > selectedEndTime.hour ||
            ((selectedBeginningTime.hour == selectedEndTime.hour) &&
                selectedBeginningTime.minute > selectedEndTime.minute))) {
      setState(() {
        selectedEndTime = selectedBeginningTime;
      });
    }
    _updateTime();
  }

  Future<Null> _selectEndDate(BuildContext context) async {
    DateTime dNow = DateTime.now();

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedBeginningDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: selectedBeginningDate,
      lastDate: DateTime(dNow.year, dNow.month + 1, dNow.day - 3),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.lerp(ThemeData.light(), ThemeData.dark(), 2.1),
          child: child,
        );
      },
    );

    if (picked != null && picked != selectedEndDate)
      setState(() {
        selectedEndDate = picked;
      });

    if (selectedBeginningDate.year == selectedEndDate.year &&
        selectedBeginningDate.month == selectedEndDate.month &&
        selectedBeginningDate.day == selectedEndDate.day &&
        (selectedBeginningTime.hour > selectedEndTime.hour ||
            ((selectedBeginningTime.hour == selectedEndTime.hour) &&
                selectedBeginningTime.minute > selectedEndTime.minute))) {
      setState(() {
        selectedBeginningTime = selectedEndTime;
      });
    }
    _updateTime();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _immideatlySelected == false
            ? ListTile(
                leading: Container(width: 50, child: Text('Start Time')),
                title: Container(
                    // width: MediaQuery.of(context).size.width / 2.1,

                    //color: Colors.blue,
                    alignment: Alignment.topLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        FlatButton.icon(
                          onPressed: () => _selectStartDate(context),
                          icon: Icon(Icons.calendar_today),
                          label: Text("${selectedBeginningDate.toLocal().day}"
                              " ${months[selectedBeginningDate.toLocal().month - 1]}  "),
                          padding: EdgeInsets.all(0),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        ButtonTheme(
                          minWidth: 20,
                          child: FlatButton.icon(
                            //onPressed: () => _selectDate(context),
                            onPressed: _selectStartTime,
                            icon: Icon(Icons.access_time),
                            label: Text(
                                '${selectedBeginningTime.toString().substring(10, 15)}'),
                            padding: EdgeInsets.all(0),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    )),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: _immideatlySelected,
                        onChanged: (bool val) {
                          setState(() {
                            _immideatlySelected = val;
                          });
                        }),
                    Container(width: 40, child: Text('now'))
                  ],
                ),
              )
            : ListTile(
                leading: Container(width: 50, child: Text('Start Time')),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: _immideatlySelected,
                        onChanged: (bool val) {
                          setState(() {
                            _immideatlySelected = val;
                          });
                        }),
                    Container(width: 40, child: Text('now'))
                  ],
                ),
              ),
        // FloatingActionButton(
        //   child: Text("Reset"),
        //   onPressed: () => {},
        // ),
        _noEndSelected == false
            ? ListTile(
                leading: Container(width: 50, child: Text('End Time')),
                title: Container(
                    alignment: Alignment.topLeft,
                    // color: Colors.red,

                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        FlatButton.icon(
                          onPressed: () => _selectEndDate(context),
                          icon: Icon(Icons.calendar_today),
                          label: Text("${selectedEndDate.toLocal().day}"
                              " ${months[selectedEndDate.toLocal().month - 1]}  "),
                          padding: EdgeInsets.all(0),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        ButtonTheme(
                          minWidth: 20,
                          child: FlatButton.icon(
                            //onPressed: () => _selectDate(context),
                            onPressed: _selectEndTime,
                            icon: Icon(Icons.access_time),
                            label: Text(
                                '${selectedEndTime.toString().substring(10, 15)}'),
                            padding: EdgeInsets.all(0),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    )),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: _noEndSelected,
                        onChanged: (bool val) {
                          setState(() {
                            _noEndSelected = val;
                          });
                        }),
                    Container(width: 40, child: Text('no End'))
                  ],
                ))
            : ListTile(
                leading: Container(width: 50, child: Text('End Time')),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: _noEndSelected,
                        onChanged: (bool val) {
                          setState(() {
                            _noEndSelected = val;
                          });
                        }),
                    Container(width: 40, child: Text('no End'))
                  ],
                )),
      ],
    );
  }

  _updateTime() {
    DateTime dNow = DateTime.now();
    TimeOfDay tNow = TimeOfDay.now();
    if (selectedBeginningDate.isBefore(dNow)) {
      setState(() {
        selectedBeginningDate = dNow;
      });
    }
    if (selectedEndDate.isBefore(dNow)) {
      setState(() {
        selectedEndDate = dNow;
      });
    }
    if (selectedBeginningDate.month == dNow.month &&
        selectedBeginningDate.day == dNow.day) {
      if (selectedBeginningTime.hour < tNow.hour ||
          (selectedBeginningTime.hour == tNow.hour &&
              selectedBeginningTime.minute < tNow.minute)) {
        setState(() {
          selectedBeginningTime = tNow;
        });
      }
    }

    if (selectedEndDate.month == dNow.month &&
        selectedEndDate.day == dNow.day) {
      if (selectedEndTime.hour < tNow.hour ||
          (selectedEndTime.hour == tNow.hour &&
              selectedEndTime.minute < tNow.minute)) {
        setState(() {
          selectedBeginningTime = tNow;
          selectedEndTime = tNow;
        });
      }
    }
  }
}
