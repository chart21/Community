import 'package:flutter/material.dart';

//Settings like backing up private key or further options
class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  /**local file read to get keystore file or private key, implementation of backup to email address,... */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Settings')),
      body: Theme(
        data: ThemeData(
            primaryColor: Colors.white,
            canvasColor: Colors.black,
            backgroundColor: Colors.white),
        child: RaisedButton(
          child: Text('Backup Private Key'),
          onPressed: () {},
        ),
      ),
    );
  }
}
