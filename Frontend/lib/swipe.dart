import 'package:flutter/material.dart';

//Detects Swipe Ups and Swipe downs
class SwipeDetectorExample extends StatefulWidget {
  final Function() onSwipeUp;
  final Function() onSwipeDown;
  final Widget child;

  SwipeDetectorExample({this.onSwipeUp, this.onSwipeDown, this.child});

  @override
  _SwipeDetectorExampleState createState() => _SwipeDetectorExampleState();
}

class _SwipeDetectorExampleState extends State<SwipeDetectorExample> {
  //Vertical drag details
  DragStartDetails startVerticalDragDetails;
  DragUpdateDetails updateVerticalDragDetails;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          print('tabbed');
        },
        onVerticalDragStart: (dragDetails) {
          startVerticalDragDetails = dragDetails;
        },
        onVerticalDragUpdate: (dragDetails) {
          updateVerticalDragDetails = dragDetails;
        },
        onVerticalDragEnd: (endDetails) {
          double dx = updateVerticalDragDetails.globalPosition.dx -
              startVerticalDragDetails.globalPosition.dx;
          double dy = updateVerticalDragDetails.globalPosition.dy -
              startVerticalDragDetails.globalPosition.dy;
          double velocity = endDetails.primaryVelocity;

          //Convert values to be positive
          if (dx < 0) dx = -dx;
          if (dy < 0) dy = -dy;

          if (velocity < 0) {
            widget.onSwipeUp();
          } else {
            widget.onSwipeDown();
          }
        },
        child: widget.child);
  }
}
