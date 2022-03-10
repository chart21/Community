import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'home.dart';
import 'package:maptest/state.dart';
import 'package:permission_handler/permission_handler.dart';

//The main methods is the first methods that gets invoked when the app is started
void main() {
  PermissionHandler().requestPermissions(//delete if permissions problems
      //at first location permission is requested from the user (only shows up if not granted before)
      [PermissionGroup.locationWhenInUse]).then(_onStatusRequested);
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(
      //homepage widgets gets displayed (main screen)
      appState:
          new AppState(), //a new appstate is created (global Singleton for managing appstate)
    ),
  ));
}

//requests Permission of user
void _onStatusRequested(Map<PermissionGroup, PermissionStatus> statuses) {
  //delete if permissions problems
  final status = statuses[PermissionGroup.locationWhenInUse];
  if (status != PermissionStatus.granted) {
    PermissionHandler()
        .openAppSettings(); //on iOS, after one rejection users can only grant permissions by opening the app settings
  }
}
