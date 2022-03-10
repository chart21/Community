import 'package:flutter/material.dart';
import 'package:flutter_icons/material_community_icons.dart';
import 'package:maptest/secondaryPages/account.dart';
import 'package:maptest/secondaryPages/help.dart';
import 'package:maptest/secondaryPages/history.dart';
import 'package:maptest/secondaryPages/offerService.dart';
import 'package:maptest/secondaryPages/payment.dart';
import 'package:maptest/secondaryPages/settings.dart';
import 'package:maptest/secondaryPages/verification.dart';
import 'package:maptest/secondaryPages/logInPage.dart';
import 'package:maptest/secondaryPages/registerPage.dart';

import 'state.dart';

//the drawer (sidebar) of the homescreen
class MyDrawer extends StatefulWidget {
  //final Function() getSignedIn;
  //final Function(bool val) setSignedIn;
  //final bool signedIn;
  final AppState appState;
  // const MyDrawer({Key key, this.getSignedIn, this.setSignedIn, this.signedIn})
  //     : super(key: key);

  const MyDrawer({Key key, this.appState}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
//  bool signedIn;
  void initState() {
    super.initState();

    //  this.signedIn = widget.signedIn;
  }

  @override
  Widget build(BuildContext context) {
    //widget.setSignedIn(signedIn);
    // WidgetsBinding.instance.addPostFrameCallback((_) {

    //   widget.setSignedIn(true);
    // });
    return new Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Container(
                height: 150,
                color: Colors.black,
                alignment: Alignment.center,
                child: widget.appState.signedIn == true //!
                    //widget.getSignedIn == true
                    ? SignedInTrue(
                        appState: widget.appState,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 130,
                            child: RaisedButton(
                              onPressed: () {
                                //setSignedIn(true);
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new LogInPage(
                                              signedIn: widget.appState, //!
                                            )));
                              },
                              //borderSide:
                              //  BorderSide(color: Colors.white, width: 1.5),
                              color: Colors.green,
                              textColor: Colors.black,
                              child: Text(
                                'Sign in',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                          ),
                          Container(
                            width: 120,
                            child: OutlineButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new RegisterPage(
                                              appState: widget.appState,
                                            )));
                              },
                              borderSide:
                                  BorderSide(color: Colors.green, width: 1.5),
                              color: Colors.white,
                              textColor: Colors.green,
                              child: Text(
                                'Register',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      )),
            ListTile(
              title: Text('Offer Service', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new OfferServicePage()));
              },
            ),
            ListTile(
              title: Text('History', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new HistoryPage()));
              },
            ),
            ListTile(
              title: Text('Verification', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new Verification()));
              },
            ),
            ListTile(
              title: Text('Payment', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new PaymentPage(
                              appState: widget.appState,
                            )));
              },
            ),
            ListTile(
              title: Text('Settings', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new SettingsPage()));
              },
            ),
            ListTile(
              title: Text('Help', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new HelpPage()));
              },
            ),
            ListTile(
                title: Text('Logout', style: TextStyle(fontSize: 16)),
                onTap: //setSignedIn(false),
                    //widget.signedIn = false;
                    () {
                  if (widget.appState.startedTrip.started == -1) {
                    setState(() {});
                    widget.appState.signedIn = false;

                    widget.appState.reserved = -1;
                  } else {
                    print('end your trip first');
                  }
                }),
          ],
        ),
      ),
    );
  }

  setSignedIn(bool val) {
    //if (signedIn == val) return;

    // widget.setSignedIn(val);
    // setState(() {
    //    signedIn = val;
    //  });
    setState(() {
      widget.appState.signedIn = val;
    });
  }
}

class SignedInTrue extends StatelessWidget {
  final AppState appState;
  const SignedInTrue({
    Key key,
    this.appState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int euPrice = appState.balance.floor();
    int cePrice = (appState.balance * 100).floor() - euPrice * 100;
    // String priceText = widget.price.toString() + '/min';
    String balanceText = euPrice.toString().padLeft(1, '0') +
        '.' +
        cePrice.toString().padLeft(2, '0') +
        '€';
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              print('profile pressed');
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new AccountPage()));
            },
            color: Colors.black,
            highlightColor: Colors.blueGrey[600],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'Account',
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        new NetworkImage('http://i.pravatar.cc/300'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(
                    'Christopher',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          //color: Colors.red,
          padding: EdgeInsets.only(top: 10, left: 10),
          //alignment: Alignment.topLeft,
          child: Container(
            alignment: Alignment.topLeft,
            //color: Colors.blue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RaisedButton(
                  padding: EdgeInsets.all(0),
                  color: Colors.black,
                  highlightColor: Colors.blueGrey[600],
                  onPressed: () {
                    print('tabbed big Button');
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new Verification()));
                  },
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            new Text(
                              'Verified Renter ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            /** 
                            Container(
                              height: 25,
                              width: 25,
                              child: IconButton(
                                //label: Text(''),
                                splashColor: Colors.white,
                                highlightColor: Colors.white,
                                padding: EdgeInsets.all(0),
                                icon: Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                //materialTapTargetSize:
                                //    MaterialTapTargetSize.shrinkWrap,
                                onPressed: () => print('pressed'),
                              ),
                            ),
                            */
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              MaterialCommunityIcons.getIconData('car'),
                              size: 17,
                              color: appState.verifiedRenter[0] == 1
                                  ? Colors.green
                                  : appState.verifiedRenter[0] == 0
                                      ? Colors.yellow
                                      : Colors.red,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Icon(
                                MaterialCommunityIcons.getIconData('motorbike'),
                                size: 17,
                                color: appState.verifiedRenter[1] == 1
                                    ? Colors.green
                                    : appState.verifiedRenter[1] == 0
                                        ? Colors.yellow
                                        : Colors.red,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Icon(
                                MaterialCommunityIcons.getIconData('bike'),
                                size: 17,
                                color: appState.verifiedRenter[2] == 1
                                    ? Colors.green
                                    : appState.verifiedRenter[2] == 0
                                        ? Colors.yellow
                                        : Colors.red,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Icon(
                                MaterialCommunityIcons.getIconData(
                                    'ev-station'),
                                size: 17,
                                color: appState.verifiedRenter[3] == 1
                                    ? Colors.green
                                    : appState.verifiedRenter[3] == 0
                                        ? Colors.yellow
                                        : Colors.red,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Icon(
                                MaterialCommunityIcons.getIconData('parking'),
                                size: 17,
                                color: appState.verifiedRenter[4] == 1
                                    ? Colors.green
                                    : appState.verifiedRenter[4] == 0
                                        ? Colors.yellow
                                        : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Row(children: <Widget>[
                          new Text(
                            'Verified Lessor ',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ]),
                        Row(
                          children: <Widget>[
                            Icon(
                              MaterialCommunityIcons.getIconData('car'),
                              size: 17,
                              color: appState.verifiedLessor[0] == 1
                                  ? Colors.green
                                  : appState.verifiedLessor[0] == 0
                                      ? Colors.yellow
                                      : Colors.red,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Icon(
                                MaterialCommunityIcons.getIconData('motorbike'),
                                size: 17,
                                color: appState.verifiedLessor[1] == 1
                                    ? Colors.green
                                    : appState.verifiedLessor[1] == 0
                                        ? Colors.yellow
                                        : Colors.red,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Icon(
                                MaterialCommunityIcons.getIconData('bike'),
                                size: 17,
                                color: appState.verifiedLessor[2] == 1
                                    ? Colors.green
                                    : appState.verifiedLessor[2] == 0
                                        ? Colors.yellow
                                        : Colors.red,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Icon(
                                MaterialCommunityIcons.getIconData(
                                    'ev-station'),
                                size: 17,
                                color: appState.verifiedLessor[3] == 1
                                    ? Colors.green
                                    : appState.verifiedLessor[3] == 0
                                        ? Colors.yellow
                                        : Colors.red,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Icon(
                                MaterialCommunityIcons.getIconData('parking'),
                                size: 17,
                                color: appState.verifiedLessor[4] == 1
                                    ? Colors.green
                                    : appState.verifiedLessor[4] == 0
                                        ? Colors.yellow
                                        : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: RaisedButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      print('tabbed Balance');
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new PaymentPage(
                                    appState: appState,
                                  )));
                    },
                    color: Colors.black,
                    highlightColor: Colors.blueGrey[600],
                    child: Row(
                      children: <Widget>[
                        new Text(
                          'Balance ',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        new Text(
                          balanceText,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              height: 20,
                              width: 20,
                              child: IconButton(
                                //label: Text(''),
                                splashColor: Colors.white,
                                highlightColor: Colors.white,
                                padding: EdgeInsets.all(0),
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.green,
                                ),
                                //materialTapTargetSize:
                                //    MaterialTapTargetSize.shrinkWrap,
                                onPressed: () => print('pressed'),
                              ),
                            ),
                            Container(
                              height: 20,
                              width: 20,
                              child: IconButton(
                                //label: Text(''),
                                splashColor: Colors.white,
                                highlightColor: Colors.white,
                                padding: EdgeInsets.all(0),
                                icon: Icon(
                                  Icons.remove,
                                  color: Colors.red,
                                ),
                                //materialTapTargetSize:
                                //    MaterialTapTargetSize.shrinkWrap,
                                onPressed: () => print('pressed'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
