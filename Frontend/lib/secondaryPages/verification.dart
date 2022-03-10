import 'package:flutter/material.dart';
import 'package:flutter_icons/material_community_icons.dart';
import 'verifierSelection.dart';

//shows verification to users and allows them to upload additional documents and link accounts
class Verification extends StatefulWidget {
  //***Blockchain read to read verifications, Off-chain document sending, upload document implementation, third party account linking */
  Verification({Key key}) : super(key: key);

  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  bool _selected = true;
  List<Widget> containers = [
    Container(
      color: Colors.white,
      child: Container(
        child: ListView(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Overview',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Table(
              children: [
                TableRow(children: [
                  TableCell(
                    child: Text('Object Type'),
                  ),
                  TableCell(child: Text('Status')),
                  TableCell(
                    child: Text('Required'),
                  )
                ]),
                TableRow(children: [
                  TableCell(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(
                        MaterialCommunityIcons.getIconData('car'),
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Text('Driver License'),
                  )
                ]),
                TableRow(children: [
                  TableCell(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(
                        MaterialCommunityIcons.getIconData('motorbike'),
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.remove,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Text('Driver License'),
                  )
                ]),
                TableRow(children: [
                  TableCell(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(
                        MaterialCommunityIcons.getIconData('bike'),
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Text('ID'),
                  )
                ]),
                TableRow(children: [
                  TableCell(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(
                        MaterialCommunityIcons.getIconData('ev-station'),
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Text('ID'),
                  )
                ]),
                TableRow(children: [
                  TableCell(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(
                        MaterialCommunityIcons.getIconData('parking'),
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Text('ID'),
                  )
                ]),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Request Verification',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Container(
                      height: 40,

                      padding: EdgeInsets.only(left: 20, right: 20),
                      //width: double.maxFinite,

                      child: FlatButton(
                        onPressed: () {},
                        color: Colors.black,
                        textColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Upload Document',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            new VerifierSelection(
              objectTypes: [
                'Automatically',
                'Post Ident',
                'Verifier 2',
                'Verifier 3',
                'Verifier 4'
              ],
              withSendButton: true,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 142,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(color: Colors.lightGreen, width: 3.0),
                      ),
                    ),
                  ),
                  Center(child: Text('OR')),
                  Container(
                    width: 142,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(color: Colors.lightGreen, width: 3.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                width: double.maxFinite,
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: // child: ImageIcon(
                            //  AssetImage('assets/marcericons/DriveNow.png'),
                            Image.asset('assets/brandIcons/uport.png'),
                      ),
                      SizedBox(width: 10),
                      Center(
                        child: Text(
                          'Connect with uPort',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      )
                    ],
                  ),
                )),
            Container(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                width: double.maxFinite,
                height: 60,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: // child: ImageIcon(
                            //  AssetImage('assets/marcericons/DriveNow.png'),
                            Image.asset('assets/marcericons/Donkey.png'),
                      ),
                      SizedBox(width: 10),
                      Center(
                        child: Text(
                          'Connect with Donkey',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      )
                    ],
                  ),
                )),
            Container(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              width: double.maxFinite,
              height: 60,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 1),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      // child: ImageIcon(
                      //  AssetImage('assets/marcericons/DriveNow.png'),
                      child: Image.asset('assets/marcericons/DriveNow.png'),
                    ),
                    SizedBox(width: 10),
                    Center(
                      child: Text(
                        'Connect with DriveNow',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    Container(
      color: Colors.white,
      child: Container(
        child: ListView(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Overview',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Table(
              children: [
                TableRow(children: [
                  TableCell(
                    child: Text('Object Type'),
                  ),
                  TableCell(child: Text('Status')),
                  TableCell(
                    child: Text('Required'),
                  )
                ]),
                TableRow(children: [
                  TableCell(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(
                        MaterialCommunityIcons.getIconData('car'),
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Text('ID'),
                  )
                ]),
                TableRow(children: [
                  TableCell(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(
                        MaterialCommunityIcons.getIconData('motorbike'),
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Text('ID'),
                  )
                ]),
                TableRow(children: [
                  TableCell(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(
                        MaterialCommunityIcons.getIconData('bike'),
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Text('ID'),
                  )
                ]),
                TableRow(children: [
                  TableCell(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(
                        MaterialCommunityIcons.getIconData('ev-station'),
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.access_time,
                        color: Colors.yellow,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Text('ID, Station\nCertification'),
                  )
                ]),
                TableRow(children: [
                  TableCell(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(
                        MaterialCommunityIcons.getIconData('parking'),
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Text('ID'),
                  )
                ]),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Request Verification',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Container(
                      height: 40,

                      padding: EdgeInsets.only(left: 20, right: 20),
                      //width: double.maxFinite,

                      child: FlatButton(
                        onPressed: () {},
                        color: Colors.black,
                        textColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Upload Document',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            new VerifierSelection(
              objectTypes: [
                'Automatically',
                'Post Ident',
                'Verifier 2',
                'Verifier 3',
                'Verifier 4'
              ],
              withSendButton: true,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 142,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(color: Colors.lightGreen, width: 3.0),
                      ),
                    ),
                  ),
                  Center(child: Text('OR')),
                  Container(
                    width: 142,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(color: Colors.lightGreen, width: 3.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                width: double.maxFinite,
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: // child: ImageIcon(
                            //  AssetImage('assets/marcericons/DriveNow.png'),
                            Image.asset('assets/brandIcons/uport.png'),
                      ),
                      SizedBox(width: 10),
                      Center(
                        child: Text(
                          'Connect with uPort',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      )
                    ],
                  ),
                )),
            Container(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                width: double.maxFinite,
                height: 60,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: // child: ImageIcon(
                            //  AssetImage('assets/marcericons/DriveNow.png'),
                            Image.asset('assets/marcericons/Donkey.png'),
                      ),
                      SizedBox(width: 10),
                      Center(
                        child: Text(
                          'Connect with Donkey',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      )
                    ],
                  ),
                )),
            Container(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              width: double.maxFinite,
              height: 60,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 1),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      // child: ImageIcon(
                      //  AssetImage('assets/marcericons/DriveNow.png'),
                      child: Image.asset('assets/marcericons/DriveNow.png'),
                    ),
                    SizedBox(width: 10),
                    Center(
                      child: Text(
                        'Connect with DriveNow',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Verification'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Renter',
              ),
              Tab(
                text: 'Lessor',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: containers,
        ),
      ),
    );
  }
}
