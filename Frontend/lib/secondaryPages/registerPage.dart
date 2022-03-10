import 'package:flutter/material.dart';
import 'package:maptest/state.dart';

class RegisterPage extends StatefulWidget {
  final AppState appState;
  RegisterPage({Key key, this.appState}) : super(key: key);

  _RegisterPageState createState() => _RegisterPageState();
}

//lets users register to the platform
class _RegisterPageState extends State<RegisterPage> {
  //***local file write to create new public and private key, store it in a keystore file and link that to the user selcted password, third party integration for account linking */
  bool _savePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Community Register')),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextField(
                  textInputAction: TextInputAction.go,
                  onSubmitted: (value) {},
                  decoration: InputDecoration(
                    hintText: 'Email Address',
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: TextField(
                textInputAction: TextInputAction.go,
                onSubmitted: (value) {},
                decoration: InputDecoration(
                  hintText: 'Password',
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Checkbox(
                        value: _savePassword,
                        onChanged: (val) {
                          setState(() {
                            _savePassword = val;
                          });
                        },
                      ),
                      Text('save')
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 30),
              width: double.maxFinite,
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    widget.appState.signedIn = true;
                  });
                  Navigator.pop(context);
                },
                color: Colors.black,
                textColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
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
                padding: const EdgeInsets.only(top: 10),
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
                          'Register with uPort',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      )
                    ],
                  ),
                )),
            Container(
                padding: const EdgeInsets.only(top: 20),
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
                          'Register with Donkey',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      )
                    ],
                  ),
                )),
            Container(
                padding: const EdgeInsets.only(top: 20),
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
                          'Register with DriveNow',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      )
                    ],
                  ),
                )),
            Container(
                padding: const EdgeInsets.only(top: 20),
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
                        child: Icon(Icons.vpn_key),
                      ),
                      SizedBox(width: 10),
                      Center(
                        child: Text(
                          'Register with existing Private Key',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
