import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/material_community_icons.dart';
import 'package:maptest/starrating.dart';
import 'package:maptest/property.dart';

//Review Page after user ends a trip to give star ratings or report
class ReviewPage extends StatelessWidget {
  //***Blockchain read to get price and time information from blockchain, Blockchain write to write ratings and reports on the Blockchain */
  final String description;
  final String icon;
  final String priceText;
  final String date;
  final double price;
  final int id;
  final int totalSeconds;

  ReviewPage(
      {Key key,
      this.date,
      this.description,
      this.icon,
      this.priceText,
      this.price,
      this.totalSeconds,
      this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String euTotalPrice =
        ((totalSeconds * price) / 60).floor().toString().padLeft(1, '0');
    String ceTotalPrice = (((totalSeconds * price) / 60) * 100 -
            ((totalSeconds * price) / 60).floor() * 100)
        .floor()
        .toString()
        .padLeft(2, '0');

    final property = Property(0);
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Rental Summary'),
          backgroundColor: Colors.black,
        ),
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 170,
                  //color: Colors.green,
                  padding: EdgeInsets.only(right: 20, top: 15),
                  alignment: Alignment.topRight,
                  child: Icon(
                    MaterialCommunityIcons.getIconData(icon),
                    size: 120,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Hero(
                          tag: 'tripInfo',
                          child:
                              Icon(MaterialCommunityIcons.getIconData(icon))),
                      title: Text(description + '\n' + 'ID: ' + id.toString()),
                      // trailing: Text('ID: ' + id),
                    ),
                    ListTile(
                      leading: Icon(Icons.euro_symbol),
                      title: Text(priceText),
                    ),
                    ListTile(
                        leading: Icon(Icons.timelapse),
                        title: Text('Rented for ' +
                            (totalSeconds / 60)
                                .floor()
                                .toString()
                                .padLeft(1, '0') + //number of minutes
                            ':' +
                            (totalSeconds % 60)
                                .toString()
                                .padLeft(2, '0') + //number of seconds
                            ' min')),
                  ],
                ),
              ],
            ),
            //mainAxisSize: MainAxisSize.min,

            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                decoration: new BoxDecoration(
                    color: Colors.black,
                    borderRadius:
                        new BorderRadius.all(const Radius.circular(15))),
                padding: EdgeInsets.all(10),
                width: double.maxFinite,
                child: Text(
                  'Total Cost ' + euTotalPrice + '.' + ceTotalPrice + '€',
                  style: TextStyle(fontSize: 25, color: Colors.green),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            //StarRating(onChanged: (int) => {})
            //StarDisplayWidget(),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                'Review your rental experience',
                style: TextStyle(fontSize: 20),
              ),
            ),
            PropertyBuilder(
              property: property,
              builder: (context, value) => StarRating(
                onChanged: (v) => property.value = v,
                value: value,
                size: 55,
                marginFactor: 15,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 5),
              child: FlatButton(
                color: Colors.black,
                textColor: Colors.white,
                onPressed: () {
                  showMyDialog(context);
                },
                child: Text(
                  'Report a problem',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
            Spacer(),

            Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              width: double.maxFinite,
              child: FlatButton(
                  color: Colors.black,
                  textColor: Colors.white,
                  onPressed: () {
                    //upload rating
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Continue',
                      style: TextStyle(fontSize: 25),
                    ),
                  )),
            ),

            /**
              TextField(
              textAlign: TextAlign.center,
              cursorColor: Colors.black,
              textInputAction: TextInputAction.go,
              onSubmitted: (value) {},
              decoration: InputDecoration(
                hintText: "Problem will be public",
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15.0, top: 15),
              ),
            ), 
             
             * 
             * 
             * 
             */
          ],
        ),
      ),
    );
  }

  showMyDialog(context) {
    //final context = scaffoldKey.currentContext;

    final dialog = Stack(
      children: [
        new Opacity(
          opacity: 0.7,
          child: const ModalBarrier(dismissible: true, color: Colors.grey),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 100),
          child: Card(
            child: new Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Text(
                        'Describe your Problem',
                        style: TextStyle(
                            fontSize: 18, color: Colors.black, inherit: false),
                      ),
                    ),
                    new Text(
                      'Your problem description will be public so please refrain from including personal information you do not want to share.',
                      style: TextStyle(
                          fontSize: 12, color: Colors.black, inherit: false),
                    ),
                    TextField(),
                    FlatButton(
                      color: Colors.black,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text('Send Report'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );

/**
 * 
 * 
 * 
 *   final dialog = AlertDialog(
      content: Text('Test'),
    );
 * 
 * 
 */

    showDialog(context: context, builder: (x) => dialog);
  }
}
