import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:maptest/checkBoxbar.dart';
import 'package:maptest/myFilterCheckBox.dart';
import 'dart:async';

import 'package:maptest/state.dart';

//Slides filter in and out
class MySlideTransition extends StatefulWidget {
  final offsetBool;
  final double widthSlide;
  final Function(int, bool) notifyFilter;
  final List<bool> filterValues;
  final AppState appState;

  MySlideTransition(
      {Key key,
      this.offsetBool,
      this.widthSlide,
      this.notifyFilter,
      this.appState,
      this.filterValues})
      : super(key: key);

  _MySlideTransitionState createState() => _MySlideTransitionState();
}

class _MySlideTransitionState extends State<MySlideTransition>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetFloat;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));

    widget.appState.controller = _controller;

    _offsetFloat = Tween<Offset>(
            begin: Offset(1, 0.0),
            end: Offset.zero) //widget.widthSlide (vorher Statt beginn 1)
        .animate(_controller);

    _offsetFloat.addListener(() {
      setState(() {});
    });

    _controller.forward().orCancel;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<IconData> icons = new List();
    icons.add(MaterialCommunityIcons.getIconData('bike'));
    icons.add(MaterialCommunityIcons.getIconData('motorbike'));
    icons.add(MaterialCommunityIcons.getIconData('car'));
    icons.add(MaterialCommunityIcons.getIconData('parking'));
    icons.add(MaterialCommunityIcons.getIconData('ev-station'));

    // icons.add(Icons.desktop_windows);
    //icons.add(Icons.description);
    return SlideTransition(
      position: _offsetFloat,
      // child: myFilterCheckBox(
      //   icon: Icons.ac_unit,
      child: myCheckboxBar(
        icons: icons,
        notifyFilter: widget.notifyFilter,
        filterValues: widget.filterValues,
      ),
    );
  }
}
