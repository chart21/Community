import 'package:flutter/material.dart';

//Account page that gets opened when user tabs on his/her profile picture, could be used to change that picture
class AccountPage extends StatefulWidget {
  AccountPage({Key key}) : super(key: key);

  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account')),
      body: Center(
        child: Hero(
          tag: 'Account',
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            backgroundImage: new NetworkImage('http://i.pravatar.cc/300'),
          ),
        ),
      ),
    );
  }
}
