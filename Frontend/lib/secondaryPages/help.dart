import 'package:flutter/material.dart';

//help page of the app
class HelpPage extends StatefulWidget {
  HelpPage({Key key}) : super(key: key);

  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Help')),
    );
  }
}
