import 'package:flutter/material.dart';

//animates the Clock when Bottom Modal Sheet gets closed or opened
class SlideClockAnimation extends StatefulWidget {
  final Widget child;
  SlideClockAnimation({Key key, this.child}) : super(key: key);

  _SlideClockAnimationState createState() => _SlideClockAnimationState();
}

class _SlideClockAnimationState extends State<SlideClockAnimation>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetFloat;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _offsetFloat = Tween<Offset>(
            begin: Offset(-0.1, 3.0),
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
    return SlideTransition(
      position: _offsetFloat,
      child: widget.child,
    );
  }
}
