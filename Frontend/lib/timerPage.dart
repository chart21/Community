import 'package:flutter/material.dart';
import 'dart:async';

import 'package:maptest/countdownDesign.dart';
import 'package:maptest/state.dart';

import 'countUpDesign.dart';

//counts time for the clock (should remain off chain)
class ElapsedTime {
  final int hundreds;
  final int seconds;
  final int minutes;

  ElapsedTime({
    this.hundreds,
    this.seconds,
    this.minutes,
  });
}

class Dependencies {
  final List<ValueChanged<ElapsedTime>> timerListeners =
      <ValueChanged<ElapsedTime>>[];
  final TextStyle textStyle =
      const TextStyle(fontSize: 15.0, fontFamily: "Bebas Neue");
  final Stopwatch stopwatch = new Stopwatch();
  final int timerMillisecondsRefreshRate = 30;
}

class TimerPage extends StatefulWidget {
  final AppState appState;
  final bool stopping;
  TimerPage({Key key, this.appState, this.stopping}) : super(key: key);

  TimerPageState createState() => new TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  final Dependencies dependencies = new Dependencies();

  void leftButtonPressed() {
    setState(() {
      if (dependencies.stopwatch.isRunning) {
        print("${dependencies.stopwatch.elapsedMilliseconds}");
      } else {
        dependencies.stopwatch.reset();
      }
    });
  }

  void rightButtonPressed() {
    setState(() {
      if (dependencies.stopwatch.isRunning) {
        dependencies.stopwatch.stop();
      } else {
        dependencies.stopwatch.start();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    dependencies.stopwatch.start();
  }

  Widget buildFloatingButton(String text, VoidCallback callback) {
    TextStyle roundTextStyle =
        const TextStyle(fontSize: 16.0, color: Colors.white);
    return new FloatingActionButton(
        child: new Text(text, style: roundTextStyle), onPressed: callback);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.stopping == true) rightButtonPressed();

    return Container(
      height: 170,
      width: 120,

      child:
          new TimerText(dependencies: dependencies, appState: widget.appState),

      //new Expanded(
      //flex: 0,
      //child: new Padding(
      // padding: const EdgeInsets.symmetric(vertical: 10.0),
      /*
          
          
           new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildFloatingButton(
                  dependencies.stopwatch.isRunning ? "lap" : "reset",
                  leftButtonPressed),
              buildFloatingButton(
                  dependencies.stopwatch.isRunning ? "stop" : "start",
                  rightButtonPressed),
            ],
          ),
          
          
           */
    );
  }
}

class TimerText extends StatefulWidget {
  TimerText({this.dependencies, this.appState});
  final Dependencies dependencies;
  final AppState appState;

  TimerTextState createState() =>
      new TimerTextState(dependencies: dependencies);
}

class TimerTextState extends State<TimerText> {
  TimerTextState({this.dependencies});
  final Dependencies dependencies;
  Timer timer;
  int milliseconds;

  @override
  void initState() {
    timer = new Timer.periodic(
        new Duration(milliseconds: dependencies.timerMillisecondsRefreshRate),
        callback);
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  void callback(Timer timer) {
    if (milliseconds != dependencies.stopwatch.elapsedMilliseconds) {
      milliseconds = dependencies.stopwatch.elapsedMilliseconds;
      final int hundreds = (milliseconds / 10).truncate();
      final int seconds = (hundreds / 100).truncate();
      final int minutes = (seconds / 60).truncate();
      final ElapsedTime elapsedTime = new ElapsedTime(
        hundreds: hundreds,
        seconds: seconds,
        minutes: minutes,
      );
      for (final listener in dependencies.timerListeners) {
        listener(elapsedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new RepaintBoundary(
      child: new MinutesAndSeconds(
          dependencies: dependencies, appState: widget.appState),
    );
  }
}

class MinutesAndSeconds extends StatefulWidget {
  MinutesAndSeconds({this.dependencies, this.appState});
  final Dependencies dependencies;
  final AppState appState;

  MinutesAndSecondsState createState() =>
      new MinutesAndSecondsState(dependencies: dependencies);
}

class MinutesAndSecondsState extends State<MinutesAndSeconds> {
  MinutesAndSecondsState({this.dependencies});
  final Dependencies dependencies;

  int minutes = 0;
  int seconds = 0;

  int initialMinutes;
  int initialSeconds;

  @override
  void initState() {
    dependencies.timerListeners.add(onTick);
    super.initState();
    initialMinutes =
        (DateTime.now().difference(widget.appState.startedTrip.startTime))
            .inMinutes;
    initialSeconds =
        (DateTime.now().difference(widget.appState.startedTrip.startTime))
            .inSeconds;
    minutes = initialMinutes;
    seconds = initialSeconds;
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.minutes != minutes || elapsed.seconds != seconds) {
      //widget.appState.startedTrip.started = elapsed.seconds;
      setState(() {
        //minutes = elapsed.minutes + initialMinutes; //does not work as it does not take previusly elapsed sceonds into account
        seconds = elapsed.seconds + initialSeconds;
        minutes = (seconds / 60).floor();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return new CountUpDesign(
        remainingMinutes: (minutes),
        remainingSeconds: (seconds),
        centPrice: (widget.appState.startedTrip.price * 100).round(),
        appState: widget.appState);
  }
}

class Hundreds extends StatefulWidget {
  Hundreds({this.dependencies});
  final Dependencies dependencies;

  HundredsState createState() => new HundredsState(dependencies: dependencies);
}

class HundredsState extends State<Hundreds> {
  HundredsState({this.dependencies});
  final Dependencies dependencies;

  int hundreds = 0;

  @override
  void initState() {
    dependencies.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.hundreds != hundreds) {
      setState(() {
        hundreds = elapsed.hundreds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');
    return new Text(hundredsStr, style: dependencies.textStyle);
  }
}
