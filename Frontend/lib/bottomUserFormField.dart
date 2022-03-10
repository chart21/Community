import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:maptest/state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'config.dart';

//shows the Textfield and schedule icon at the bottom of the home screen
class ButtonUserFormField extends StatefulWidget {
  final Function() notifyParent;
  final AppState appState;

  ButtonUserFormField({Key key, this.notifyParent, this.appState})
      : super(key: key);

  _ButtonUserFormFieldState createState() => _ButtonUserFormFieldState();
}

const kGoogleApiKey = mapsAPIKey;

class _ButtonUserFormFieldState extends State<ButtonUserFormField> {
  double bottomHeight;
  TextEditingController destinationController = TextEditingController();
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    bottomHeight = 200;

    focusNode.addListener(textFieldFocusDidChange);
  }

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        height: 50.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(1.0, 5.0),
                blurRadius: 10,
                spreadRadius: 3)
          ],
        ),
        child: CupertinoTextField(
          // readOnly: true,
          focusNode: focusNode,
          cursorColor: Colors.black,
          controller: destinationController,
          textInputAction: TextInputAction.go,
          onSubmitted: (value) {},

          suffix: Padding(
            padding: const EdgeInsetsDirectional.only(end: 0.0),
            child: Container(
              width: 67,
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 3, bottom: 3),
                    width: 2,
                    color: Colors.black,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 0),
                    width: 65,
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      padding: EdgeInsets.only(bottom: 10, top: 3, right: 5),
                      iconSize: 50,
                      onPressed: _planTripPresed,
                      icon: Image.asset(
                        'assets/icons/cartime1.png',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          placeholder: "Set Pickup Address",
          suffixMode: OverlayVisibilityMode.always,
          //  clearButtonMode: OverlayVisibilityMode.editing,
          //   border: InputBorder.none,
          //    contentPadding: EdgeInsets.only(left: 15.0, top: 15),
        ),
      ),
    );
  }

  void _planTripPresed() {
    widget.notifyParent();
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;

      final lng = detail.result.geometry.location.lng;

      // scaffold.showSnackBar(
      //   SnackBar(content: Text("${p.description} - $lat/$lng")),
      //  );

      final GoogleMapController controller =
          await widget.appState.mapsController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 14.4746)));
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  void textFieldFocusDidChange() async {
    if (focusNode.hasFocus) {
      // textfield was tapped
      Prediction p = await PlacesAutocomplete.show(
          context: context,
          apiKey: kGoogleApiKey,
          onError: onError,
          mode: Mode.fullscreen,
          logo: Opacity(
            opacity: 1.0,
          ));
      displayPrediction(p, homeScaffoldKey.currentState);
    }
  }
}
