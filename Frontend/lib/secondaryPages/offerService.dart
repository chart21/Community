import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:maptest/secondaryPages/datepickerOffer.dart';

class OfferServicePage extends StatefulWidget {
  OfferServicePage({Key key}) : super(key: key);

  _OfferServicePageState createState() => _OfferServicePageState();
}

class _OfferServicePageState extends State<OfferServicePage> {
  //***Blockchain write when pressing offer service, Client Side creation of polygons in a circle */
  var objectTypes = [
    'Charging Station',
    'Parking Lot',
    'Bike',
    'Motorbike',
    'Car'
  ];
  var _selectedObjectType = 'Car';
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(canvasColor: Colors.white, primaryColor: Colors.black),
      child: Scaffold(
        appBar: AppBar(title: Text('Offer Service')),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(5)),
            ListTile(
              leading: Text('Object Type'),
              title: DropdownButton<String>(
                  value: _selectedObjectType,
                  onChanged: (String newValue) {
                    setState(() {
                      // viewModel.classType = newValue;
                      _selectedObjectType = newValue;
                    });
                  },
                  items: objectTypes.map((String objectType) {
                    return new DropdownMenuItem<String>(
                        value: objectType,
                        child: new Text(objectType.toString()));
                  }).toList()),
            ),
            _selectedObjectType.compareTo('Parking Lot') != 0
                ? ListTile(
                    leading: Text('Model'),
                    title: TextField(
                        decoration: InputDecoration(
                      hintText: 'e.g. BMW i3',
                    )))
                : Opacity(
                    opacity: 1,
                  ),
            ListTile(leading: Text('Pickup Address'), title: TextFormField()),
            MyDatePickerOffer(
              selectedBeginningDate: DateTime.now(),
              selectedBeginningTime: TimeOfDay.now(),
              selectedEndDate: DateTime.now(),
              selectedEndTime: TimeOfDay.now(),
              notifyParent: null,
            ),
            ListTile(
                leading: Text('Price per minute'),
                title: TextFormField(
                  keyboardType: TextInputType.number,
                ),
                trailing: Container(width: 70, child: Text('€'))),
            _selectedObjectType.compareTo('Parking Lot') != 0 &&
                    _selectedObjectType.compareTo('Charging Station') != 0
                ? ListTile(
                    leading: Text('Dropoff Radius'),
                    title: TextFormField(
                      keyboardType: TextInputType.number,
                    ),
                    trailing: Container(width: 70, child: Text('km')))
                : Opacity(
                    opacity: 1,
                  ),
            ListTile(
                leading: Text('Maximum time of reserve'),
                title: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'rec: 15'),
                ),
                trailing: Container(width: 70, child: Text('min'))),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 50),
              child: RaisedButton(
                child: Text('Confirm Offer'),
                color: Colors.black,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
