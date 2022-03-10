import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

//lets users select start dates/time and end dates/time for renting or leasing out trips
class MyDatePicker extends StatefulWidget {
  final Function(DateTime, TimeOfDay, DateTime, TimeOfDay) notifyParent;
  DateTime selectedBeginningDate;
  DateTime selectedEndDate;
  TimeOfDay selectedBeginningTime;
  TimeOfDay selectedEndTime;

  MyDatePicker(
      {Key key,
      this.notifyParent,
      this.selectedBeginningDate,
      this.selectedBeginningTime,
      this.selectedEndTime,
      this.selectedEndDate})
      : super(key: key);

  _MyDatePickerState createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
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

    if (picked != null && picked != selectedEndTime)
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
    int lastmonth = dNow.month + 1;
    int lastday = dNow.day - 3;
    int lastyear = dNow.year;
    if (lastday < 1) lastday = 1;
    if (lastmonth > 12) {
      lastmonth = 1;
      lastyear++;
    }
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedBeginningDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(dNow.year, dNow.month, dNow.day),
      lastDate: DateTime(lastyear, lastmonth, lastday),
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
    int lastmonth = dNow.month + 1;
    int lastday = dNow.day - 3;
    int lastyear = dNow.year;
    if (lastday < 1) lastday = 1;
    if (lastmonth > 12) {
      lastmonth = 1;
      lastyear++;
    }

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedBeginningDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: selectedBeginningDate,
      lastDate: DateTime(lastyear, lastmonth, lastday),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              // width: MediaQuery.of(context).size.width / 2.1,

              //color: Colors.blue,
              alignment: Alignment.topLeft,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Begin'),
                  // Text("${selectedDate.toLocal().month.toString()}" +
                  //     "${selectedDate.toLocal().day}"),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FlatButton.icon(
                        onPressed: () => _selectStartDate(context),
                        icon: Icon(Icons.calendar_today),
                        label: Text("${selectedBeginningDate.toLocal().day}"
                            " ${months[selectedBeginningDate.toLocal().month - 1]}  "),
                        padding: EdgeInsets.all(0),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                  )
                ],
              ),
            ),
            // FloatingActionButton(
            //   child: Text("Reset"),
            //   onPressed: () => {},
            // ),
            Container(
              alignment: Alignment.topLeft,
              // color: Colors.red,
              child: (Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('End'),
                  // Text("${selectedDate.toLocal().month.toString()}" +
                  //     "${selectedDate.toLocal().day}"),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FlatButton.icon(
                        onPressed: () => _selectEndDate(context),
                        icon: Icon(Icons.calendar_today),
                        label: Text("${selectedEndDate.toLocal().day}"
                            " ${months[selectedEndDate.toLocal().month - 1]}  "),
                        padding: EdgeInsets.all(0),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                  )
                ],
              )),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              textColor: Colors.white,
              color: Colors.black,
              onPressed: _resetSchedule,
              child: Text(
                'Reset Schedule',
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
            ),
            RaisedButton(
              textColor: Colors.white,
              color: Colors.black,
              onPressed: () {
                widget.notifyParent(selectedBeginningDate,
                    selectedBeginningTime, selectedEndDate, selectedEndTime);
              },
              //onPressed: () => {},
              child: Text(
                'Apply',
              ),
            ),
          ],
        )
      ],
    );
  }

  _resetSchedule() {
    DateTime dNow = DateTime.now();
    TimeOfDay tNow = TimeOfDay.now();
    int endhour = tNow.hour + 1;
    int endminute = tNow.minute;
    if (endhour > 23) {
      endhour--;
      endminute = 59;
    }
    setState(() {
      selectedBeginningDate = dNow;
      selectedEndDate = dNow;
      selectedBeginningTime = tNow;
      selectedEndTime = TimeOfDay(hour: tNow.hour, minute: tNow.minute);
      selectedEndTime = TimeOfDay(hour: endhour, minute: endminute);
    });
    widget.notifyParent(selectedBeginningDate, selectedBeginningTime,
        selectedEndDate, selectedEndTime);
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
