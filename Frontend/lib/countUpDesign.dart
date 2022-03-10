import 'package:flutter/material.dart';
import 'package:maptest/state.dart';

//CountUpClockDesign
class CountUpDesign extends StatelessWidget {
  final int remainingMinutes; //elapsed Minutes
  final int remainingSeconds; //elapsed Seconds
  final int centPrice;
  final String text;
  final AppState appState;

  const CountUpDesign(
      {Key key,
      this.remainingMinutes,
      this.remainingSeconds,
      this.text,
      this.centPrice,
      this.appState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String display = (remainingMinutes % 60).toString().padLeft(2, '0') +
        ':' +
        (remainingSeconds % 60).toString().padLeft(2, '0');

    int price = ((centPrice * remainingMinutes) / 100).round();
    String displayPrice = (price % 100).toString() +
        ',' +
        (price - (price % 100)).toString() +
        '€';

    int euPrice = ((centPrice * remainingSeconds / 60) / 100).floor();
    int cePrice = (centPrice * remainingSeconds / 60).floor() - euPrice * 100;

    return Container(
      height: 170,
      width: 120,
      //padding: EdgeInsets.only(right: 10),
      child: CircleAvatar(
        foregroundColor: Colors.black,
        child: appState.openedStartedField == true
            ? Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Text(display),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Text(euPrice.toString().padLeft(1, '0') +
                        ',' +
                        cePrice.toString().padLeft(2, '0') +
                        '€'),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Text(display),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(euPrice.toString().padLeft(1, '0') +
                        ',' +
                        cePrice.toString().padLeft(2, '0') +
                        '€'),
                  ),
                ],
              ),
        backgroundColor: Colors.green[700],
      ),
    );
  }
}
