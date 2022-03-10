import 'package:flutter/material.dart';
import 'package:maptest/state.dart';

//Coundtown clock Design
class CountdownDesign extends StatelessWidget {
  final String remaining;
  final String text;

  const CountdownDesign({Key key, this.remaining, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: 120,
      //padding: EdgeInsets.only(right: 10),
      child: CircleAvatar(
        child: Text(remaining),
        backgroundColor: Colors.black,
      ),
    );
  }
}
