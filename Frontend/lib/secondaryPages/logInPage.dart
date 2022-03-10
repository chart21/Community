import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maptest/home.dart';
import 'package:maptest/state.dart';
import 'package:dropdownfield/dropdownfield.dart';

//Login Page for the user
class LogInPage extends StatefulWidget {
  //***local file read (keystore file, saved accounts), Blockchain read (checking keystore file public and private key, loading information), connecting to third party logins */
  // final Function(bool) setSignedIn;
  //bool signedIn;
  final AppState signedIn;
  LogInPage({Key key, this.signedIn}) : super(key: key);

  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  List<String> l = ['c.harth-kitzerow@gmx.de'];
  bool loggedIn = false;
  bool _savePassword = true;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.black,
        canvasColor: Colors.white,
      ),
      child: Scaffold(
        appBar: AppBar(title: Text('Community SignIn')),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20),
                /** 
                child: TextField(
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) {},
                    decoration: InputDecoration(
                      hintText: 'Email Address',
                    )),
                    */

                child: Form(
                  child: DropDownField(
                    labelText: 'Email Address',
                    items: l,
                    itemsVisibleInDropdown: 1,
                    hintText: '',
                    hintStyle: TextStyle(color: Colors.black),

                    //labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
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
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 40,
                      child: FloatingActionButton(
                        backgroundColor: Colors.black,
                        //padding: EdgeInsets.all(0),
                        onPressed: () {},
                        child: Icon(Icons.fingerprint),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 40,
                        //width: double.maxFinite,
                        child: FlatButton(
                          onPressed: () {
                            setState(() {
                              widget.signedIn.signedIn = true;
                            });
                            Navigator.pop(context);
                          },
                          color: Colors.black,
                          textColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Sign In',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                            'Sign In with uPort',
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
                            'Sign In with Donkey',
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
                            'Sign In with DriveNow',
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
                            'Sign in with Private Key',
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
      ),
    );
  }
}
