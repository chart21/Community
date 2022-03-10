import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maptest/state.dart';

import 'dart:ui' as ui;

//Google Map and Refresh Indicator
class myMap extends StatefulWidget {
  final AppState appState;
  final Completer<GoogleMapController> controller;
  final Function(double price, String date, String description, String icon,
      int id, LatLng location, String address) notifyParent;
  final Function() notifyParentClosed;
  final Set<Polygon> polygons;
  myMap(
      {Key key,
      this.notifyParent,
      this.notifyParentClosed,
      this.appState,
      this.controller,
      this.polygons})
      : super(key: key);

  _myMapState createState() => _myMapState();
}

class _myMapState extends State<myMap> {
  // Completer<GoogleMapController> _controller = Completer();
  //GoogleMapController mapController;
  int markerindex = 0;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  // final Set<Polygon> _polygons = {};

  // List<Trip> trips = [];

  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;

  String location;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(48.137154, 11.576124),
    zoom: 14.4746,
  );

  static final CameraPosition _Berlin =
      CameraPosition(target: LatLng(52.520008, 13.404954), zoom: 14.4746);

  static final CameraPosition _Munich =
      CameraPosition(target: LatLng(48.137154, 11.576124), zoom: 14.4746);

  @override
  void initState() {
    super.initState();
    location = 'Munich';
    //_initialPosition = LatLng(48.437154, 11.676124);

    _initialPosition = LatLng(48.137154, 11.576124);
    // _addMarker(LatLng(48.137154, 11.576124), 'Test car');

    //       icons.add(MaterialCommunityIcons.getIconData('motorbike'));
    //   icons.add(MaterialCommunityIcons.getIconData('car'));
    //   icons.add(MaterialCommunityIcons.getIconData('parking'));
    //   icons.add(MaterialCommunityIcons.getIconData('ev-station'));

    if (widget.appState.reservedTrip.id != -1) goToReservation();
  }

  Future<Null> refreshMap() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {});
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          onTap: (lt) async {
            print('tapped');
            final GoogleMapController controller =
                await widget.controller.future;

            controller.animateCamera(CameraUpdate.zoomTo(13.4));
            setState(() {
              widget.polygons.clear();
            });
            widget.notifyParentClosed();
          },
          initialCameraPosition:
              CameraPosition(target: _initialPosition, zoom: 13.6),
          onMapCreated: onCreated,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          mapType: MapType.normal,
          compassEnabled: true,
          markers: _markers,
          polylines: _polyLines,
          polygons: widget.polygons,

          //onCameraMove: _onCameraMove,
          // polylines: _polyLines,
        ),
        RefreshIndicator(
          displacement: 20,
          onRefresh: refreshMap,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              height: 130,
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _goToTheLake() async {
    //final GoogleMapController controller = await _controller.future;
    final GoogleMapController controller = await widget.controller.future;

    if (location.trim() == 'Berlin'.trim()) {
      controller.animateCamera(CameraUpdate.newCameraPosition(_Munich));

      setState(() {
        location = 'Munich';
      });
    } else {
      controller.animateCamera(CameraUpdate.newCameraPosition(_Berlin));
      setState(() {
        location = 'Berlin';
      });
    }
  }

  Future<void> goToReservation() async {
    //final GoogleMapController controller = await _controller.future;
    final GoogleMapController controller = await widget.controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: widget.appState.reservedTrip.pickUpLocation)));
  }

  void onCreated(GoogleMapController controller) async {
    setState(() {
      widget.controller.complete(controller);
    });

    //addPolylines();
    //***Blockchain getter */
    await _addCustomMarker(LatLng(48.137154, 11.516124), 'Test bike', 948625,
        0.05, '28.07.2019', 'ShareNow', 'car', markerindex);
    await _addCustomMarker(LatLng(48.237154, 11.496124), 'Test bike', 100543,
        0.05, '28.07.2019', 'Share&Charge', 'ev-station', markerindex);
    await _addCustomMarker(LatLng(48.135154, 11.596424), 'Test bike', 888452,
        1.50, '28.07.2019', 'DriveNow', 'car', markerindex);

    await _addCustomMarker(LatLng(48.137254, 11.586424), 'Test bike', 100000,
        0.05, '28.07.2019', 'Share&Charge', 'ev-station', markerindex);
    await _addCustomMarker(LatLng(48.145854, 11.596124), 'Test bike', 100001,
        1.50, '28.07.2019', 'Donkey', 'bike', markerindex);

    await _addCustomMarker(LatLng(48.157554, 11.566524), 'Test bike', 100002,
        0.05, '28.07.2019', 'RetroRent', 'motorbike', markerindex);
    await _addCustomMarker(LatLng(48.115122, 11.546181), 'Test bike', 100003,
        1.50, '28.07.2019', 'Patagonia', 'motorbike', markerindex);

    await _addCustomMarker(LatLng(48.177954, 11.526724), 'Test bike', 100004,
        0.05, '28.07.2019', 'BlackBike', 'bike', markerindex);
    await _addCustomMarker(LatLng(48.196154, 11.525824), 'Test bike', 100005,
        1.50, '28.07.2019', 'PrivateParking', 'parking', markerindex);

    await _addCustomMarker(LatLng(48.167554, 11.546514), 'Test bike', 100006,
        0.05, '28.07.2019', 'ParkChain', 'parking', markerindex);
    await _addCustomMarker(LatLng(48.125154, 11.536424), 'Test bike', 100007,
        1.50, '28.07.2019', 'GreenCharge', 'ev-station', markerindex);

    await _addCustomMarker(LatLng(48.117654, 11.516164), 'Test bike', 100008,
        0.05, '28.07.2019', 'DriveNow', 'car', markerindex);
    await _addCustomMarker(LatLng(48.135333, 11.566666), 'Test bike', 100009,
        1.50, '28.07.2019', 'BlackBike', 'bike', markerindex);

    await _addCustomMarker(LatLng(48.142000, 11.541234), 'Test bike', 100010,
        0.05, '28.07.2019', 'DriveNow', 'car', markerindex);
    await _addCustomMarker(LatLng(48.142586, 11.576564), 'Test bike', 100011,
        0.05, '28.07.2019', 'RetroRent', 'motorbike', markerindex);
    await _addCustomMarker(LatLng(48.140453, 11.585489), 'Test bike', 100012,
        0.05, '28.07.2019', 'DriveNow', 'car', markerindex);

    await _addCustomMarker(LatLng(48.127651, 11.548979), 'Test bike', 100013,
        1.50, '28.07.2019', 'Patagonia', 'motorbike', markerindex);
    await _addCustomMarker(LatLng(48.131234, 11.569744), 'Test bike', 100014,
        1.50, '28.07.2019', 'PrivateParking', 'parking', markerindex);
    await _addCustomMarker(LatLng(48.135475, 11.556744), 'Test bike', 100015,
        0.05, '28.07.2019', 'DriveNow', 'car', markerindex);
    await _addCustomMarker(LatLng(48.138654, 11.537484), 'Test bike', 100016,
        1.50, '28.07.2019', 'Donkey', 'bike', markerindex);

    await _addCustomMarker(LatLng(48.137123, 11.573154), 'Test bike', 100017,
        0.05, '28.07.2019', 'Share&Charge', 'ev-station', markerindex);
    await _addCustomMarker(LatLng(48.139564, 11.534216), 'Test bike', 100018,
        1.50, '28.07.2019', 'PrivateParking', 'parking', markerindex);
    await _addCustomMarker(LatLng(48.136124, 11.577561), 'Test bike', 100019,
        1.50, '28.07.2019', 'Patagonia', 'motorbike', markerindex);
    await _addCustomMarker(LatLng(48.140471, 11.593256), 'Test bike', 100020,
        0.05, '28.07.2019', 'DriveNow', 'car', markerindex);
    await _addCustomMarker(LatLng(48.143861, 11.552456), 'Test bike', 100021,
        0.05, '28.07.2019', 'DriveNow', 'car', markerindex);

    await _addCustomMarker(LatLng(48.155154, 11.696424), 'Test car', 521345,
        0.33, '-', 'Car3Js', 'car', markerindex);

    await _addCustomMarker(LatLng(48.125154, 11.496424), 'Test EV Station',
        15151, 0.33, '-', 'ChargeChain', 'ev-station', markerindex);

    await _addCustomMarker(LatLng(48.525154, 11.396424), 'Test Parking Lot',
        481534, 0.33, '-', 'ParkChain', 'parking', markerindex);

    await _addCustomMarker(LatLng(48.155154, 11.236424), 'Test Parking Lot',
        253144, 0.33, '-', 'Emmy', 'motorbike', markerindex);

    await _addCustomMarker(LatLng(48.217154, 11.176124), 'Test bike', 100544,
        0.05, '28.07.2019', 'BlackBike', 'bike', markerindex);
    await _addCustomMarker(LatLng(48.227154, 11.276124), 'Test bike', 100545,
        0.05, '28.07.2019', 'BlueBike', 'bike', markerindex);
    await _addCustomMarker(LatLng(48.237154, 11.376124), 'Test bike', 100546,
        0.05, '28.07.2019', 'RetroRent', 'motorbike', markerindex);
    await _addCustomMarker(LatLng(48.247154, 11.676124), 'Test bike', 100547,
        0.05, '28.07.2019', 'Donkey', 'bike', markerindex);
    await _addCustomMarker(LatLng(48.257154, 11.776124), 'Test bike', 100548,
        0.05, '28.07.2019', 'Patagonia', 'motorbike', markerindex);
    await _addCustomMarker(LatLng(48.267154, 11.876124), 'Test bike', 100549,
        0.05, '28.07.2019', 'AlpineBikes', 'bike', markerindex);
    await _addCustomMarker(LatLng(48.277154, 11.976124), 'Test bike', 100700,
        0.05, '28.07.2019', 'GreenCharge', 'ev-station', markerindex);
    await _addCustomMarker(LatLng(48.287154, 11.616124), 'Test bike', 100701,
        0.05, '28.07.2019', 'PrivateParking', 'parking', markerindex);
    await _addCustomMarker(LatLng(48.297154, 11.636124), 'Test bike', 100570,
        0.05, '28.07.2019', 'Park3js', 'parking', markerindex);
    await _addCustomMarker(LatLng(48.337154, 11.876124), 'Test bike', 100702,
        0.05, '28.07.2019', 'ParkChain', 'parking', markerindex);
    await _addCustomMarker(LatLng(48.447154, 11.412324), 'Test bike', 100803,
        0.05, '28.07.2019', 'BlackBike', 'bike', markerindex);
    await _addCustomMarker(LatLng(48.557154, 11.473254), 'Test bike', 100604,
        0.05, '28.07.2019', 'Car2Go', 'car', markerindex);
    await _addCustomMarker(LatLng(48.667154, 11.477853), 'Test bike', 100203,
        0.05, '28.07.2019', 'BlackBike', 'bike', markerindex);
    await _addCustomMarker(LatLng(48.7737154, 11.468431), 'Test bike', 100101,
        0.05, '28.07.2019', 'ShareNow', 'car', markerindex);
    await _addCustomMarker(LatLng(48.887154, 11.476999), 'Test bike', 845415,
        0.05, '28.07.2019', 'Share&Charge', 'ev-station', markerindex);
    await _addCustomMarker(LatLng(48.397154, 11.776211), 'Test bike', 295753,
        0.05, '28.07.2019', 'BlackBike', 'bike', markerindex);
    await _addCustomMarker(LatLng(48.398154, 11.871111), 'Test bike', 125615,
        0.05, '28.07.2019', 'Share&Charge', 'ev-station', markerindex);
  }

/**
  
   void _onCameraMove(CameraPosition position) {
    setState(() {
      _lastPosition = position.target;
    });
  }
  
 
 */

  void _addMarker(LatLng location, String address) {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(_lastPosition.toString()),
          position: location,
          infoWindow: InfoWindow(title: address, snippet: "go here"),
          icon: BitmapDescriptor.defaultMarker));
    });

    /** 
     _markers.add(Marker(
        markerId: MarkerId('0'),
        position: LatLng(48.137154, 11.576124),
        infoWindow: InfoWindow(title: address, snippet: "go here"),
        icon: BitmapDescriptor.defaultMarker));
     * 
    */
  }

  void _addCustomMarker(LatLng location, String address, int id, double price,
      String date, String issuer, String description, int markerIndex) async {
    bool custom = false;
    double polyLineFactor = 1.0;
    bool polylines = true;
    markerindex++;
    double markericon = BitmapDescriptor.hueAzure;
    if (description.compareTo('bike') == 0) {
      markericon = BitmapDescriptor.hueOrange;
      polyLineFactor = 0.2;
    }
    markericon = BitmapDescriptor.hueGreen;
    if (description.compareTo('car') == 0) {
      markericon = BitmapDescriptor.hueOrange;
    }
    markericon = BitmapDescriptor.hueMagenta;
    if (description.compareTo('motorbike') == 0) {
      markericon = BitmapDescriptor.hueOrange;
      polyLineFactor = 0.5;
    }

    if (description.compareTo('ev-station') == 0) {
      markericon = BitmapDescriptor.hueYellow;
      polylines = false;
    }
    markericon = BitmapDescriptor.hueViolet;
    if (description.compareTo('parking') == 0) {
      markericon = BitmapDescriptor.hueYellow;
      polylines = false;
    }

    // String markericon2;
    // BitmapDescriptor markericon2;

    Uint8List markerIcond;
// = await getBytesFromCanvasImage2(
    //       150, 150, 'assets/marcericons/BlackBike.png');

    if (issuer.compareTo('BlackBike') == 0) {
      custom = true;
      String path = issuer;
      path += '.png';
      markerIcond = await getBytesFromCanvasImage2(
          150, 150, 'assets/marcericons/' + path);
      // markericon2 = 'assets/marcericons/' + path;
    }

    if (issuer.compareTo('BlueBike') == 0) {
      custom = true;
      String path = issuer;
      path += '.png';
      markerIcond = await getBytesFromCanvasImage2(
          150, 150, 'assets/marcericons/' + path);
    }

    if (issuer.compareTo('bus') == 0) {
      custom = true;
      String path = issuer;
      path += '.png';
      markerIcond = await getBytesFromCanvasImage2(
          150, 150, 'assets/marcericons/' + path);
    }

    if (issuer.compareTo('GreenBike') == 0) {
      custom = true;
      String path = issuer;
      path += '.png';
      markerIcond = await getBytesFromCanvasImage2(
          150, 150, 'assets/marcericons/' + path);
    }

    if (issuer.compareTo('GreenWhiteBike') == 0) {
      custom = true;
      String path = issuer;
      path += '.png';
      markerIcond = await getBytesFromCanvasImage2(
          150, 150, 'assets/marcericons/' + path);
    }

    if (issuer.compareTo('OrangeBike') == 0) {
      custom = true;
      String path = issuer;
      path += '.png';
      markerIcond = await getBytesFromCanvasImage2(
          150, 150, 'assets/marcericons/' + path);
    }

    if (issuer.compareTo('YellowBike') == 0) {
      custom = true;
      String path = issuer;
      path += '.png';
      markerIcond = await getBytesFromCanvasImage2(
          150, 150, 'assets/marcericons/' + path);
    }

    if (issuer.compareTo('ShareNow') == 0) {
      custom = true;
      String path = issuer;
      path += '.png';
      markerIcond = await getBytesFromCanvasImage2(
          150, 150, 'assets/marcericons/' + path);
    }

    if (issuer.compareTo('Car2Go') == 0) {
      custom = true;
      String path = issuer;
      path += '.png';
      markerIcond = await getBytesFromCanvasImage2(
          150, 150, 'assets/marcericons/' + path);
    }

    if (issuer.compareTo('DriveNow') == 0) {
      custom = true;
      String path = issuer;
      path += '.png';
      markerIcond = await getBytesFromCanvasImage2(
          150, 150, 'assets/marcericons/' + path);
    }

    if (issuer.compareTo('RetroRent') == 0) {
      custom = true;
      String path = issuer;
      path += '.png';
      markerIcond = await getBytesFromCanvasImage2(
          150, 150, 'assets/marcericons/' + path);
    }

    if (issuer.compareTo('Moto&Bike') == 0) {
      custom = true;
      String path = issuer;
      path += '.png';
      markerIcond = await getBytesFromCanvasImage2(
          150, 150, 'assets/marcericons/' + path);
    }

    if (issuer.compareTo('Patagonia') == 0) {
      custom = true;
      String path = issuer;
      path += '.png';
      markerIcond = await getBytesFromCanvasImage2(
          150, 150, 'assets/marcericons/' + path);
    }

    if (issuer.compareTo('AlpineBikes') == 0) {
      custom = true;
      String path = issuer;
      path += '.png';
      markerIcond = await getBytesFromCanvasImage2(
          150, 150, 'assets/marcericons/' + path);
    }

    if (issuer.compareTo('BikeRental') == 0) {
      custom = true;
      String path = issuer;
      path += '.png';
      markerIcond = await getBytesFromCanvasImage2(
          150, 150, 'assets/marcericons/' + path);
    }

    if (issuer.compareTo('GreenCharge') == 0) {
      custom = true;
      String path = issuer;
      path += '.png';
      markerIcond = await getBytesFromCanvasImage2(
          150, 150, 'assets/marcericons/' + path);
    }

    if (issuer.compareTo('PrivateParking') == 0) {
      custom = true;
      String path = issuer;
      path += '.png';
      markerIcond = await getBytesFromCanvasImage2(
          150, 150, 'assets/marcericons/' + path);
    }

    if (issuer.compareTo('ParkChain') == 0) {
      custom = true;
      String path = issuer;
      path += '.png';
      markerIcond = await getBytesFromCanvasImage2(
          150, 150, 'assets/marcericons/' + path);
    }

/*



  jpg:


*/

    if (issuer.compareTo('Donkey') == 0) {
      custom = true;
      String path = issuer;
      path += '.png';
      markerIcond = await getBytesFromCanvasImage2(
          150, 150, 'assets/marcericons/' + path);
    }
    if (issuer.compareTo('Green2Bike') == 0) {
      custom = true;
      String path = issuer;
      path += '.jpg';
      markerIcond = await getBytesFromCanvasImage2(
          150, 150, 'assets/marcericons/' + path);
    }
    if (issuer.compareTo('OBike') == 0) {
      custom = true;
      String path = issuer;
      path += '.jpg';
      markerIcond = await getBytesFromCanvasImage2(
          150, 150, 'assets/marcericons/' + path);
    }
    if (issuer.compareTo('Parc3js') == 0) {
      custom = true;
      String path = issuer;
      path += '.jpg';
      markerIcond = await getBytesFromCanvasImage2(
          150, 150, 'assets/marcericons/' + path);
    }
    if (issuer.compareTo('PurpleBike') == 0) {
      custom = true;
      String path = issuer;
      path += '.jpg';
      markerIcond = await getBytesFromCanvasImage2(
          150, 150, 'assets/marcericons/' + path);
    }

    if (issuer.compareTo('Share&Charge') == 0) {
      custom = true;
      String path = issuer;
      path += '.jpg';
      markerIcond = await getBytesFromCanvasImage2(
          150, 150, 'assets/marcericons/' + path);
    }

    /*
  if (issuer == 'Donkey') {
      custom = true;
      String path = issuer;
      path += '.jpg';
      //markericon2 = await _getAssetIcon(path, context);
      markericon2 = 'assets/marcericons/' + issuer + path;
    }
    
   */

    //print(markericon2);

    //muss später alle infos als paremter erhalten
    // BitmapDescriptor markericon = await _getAssetIcon(context);
    //final Uint8List markerIcon = await getBytesFromCanvas(200, 100);

    /**
    String snippet = 'free';
    if (widget.appState.reserved == id) {
      snippet = 'reserved by you';
    }
    if (widget.appState.startedTrip.id == id) {
      snippet = 'rented by you';
    }
     */

    if (custom == false) {
      setState(() {
        _markers.add(Marker(

            // markerId: MarkerId(_lastPosition.toString()),
            markerId: MarkerId(id.toString()),
            onTap: () async {
              await widget.notifyParentClosed();
              widget.notifyParent(
                  price, date, issuer, description, id, location, address);
              final GoogleMapController controller =
                  await widget.controller.future;
              controller.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: location, zoom: 13.1746)));
              // showNewPolyLine(location, Colors.red);
              showNewPolygons(
                  location, Colors.red, id.toString(), polyLineFactor);
              print('hi');
            },
            position: location,
            infoWindow: InfoWindow(title: issuer),
            icon: BitmapDescriptor.defaultMarkerWithHue(markericon)
            //icon: BitmapDescriptor.fromBytes(markerIcond)
            // icon: BitmapDescriptor.defaultMarker),
            // icon: BitmapDescriptor.fromAssetImage(null, 'icons/cartime1.png'),
            ));
      });
    } else {
      _markers.add(Marker(

          // markerId: MarkerId(_lastPosition.toString()),
          markerId: MarkerId(id.toString()),
          onTap: () async {
            await widget.notifyParentClosed();

            widget.notifyParent(
                price, date, issuer, description, id, location, address);
            final GoogleMapController controller =
                await widget.controller.future;

            if (polylines == true) {
              showNewPolygons(
                  location, Colors.blue, id.toString(), polyLineFactor);
              // await controller.animateCamera(CameraUpdate.newCameraPosition(
              //     CameraPosition(target: location, zoom: 9.1746)));
              await controller.animateCamera(
                CameraUpdate.newLatLngBounds(
                  LatLngBounds(
                    southwest: LatLng(location.latitude - 0.3 * polyLineFactor,
                        location.longitude - 0.3 * polyLineFactor),
                    northeast: LatLng(location.latitude + 0.3 * polyLineFactor,
                        location.longitude + 0.3 * polyLineFactor),
                  ),
                  32.0,
                ),
              );
              await Future.delayed(Duration(seconds: 2));
            } else {
              showNewPolygons(location, Colors.red, id.toString(), 0.001);
            }

            await controller.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: location, zoom: 15.1746)));

            print('ho');
          },
          position: location,
          infoWindow: InfoWindow(title: issuer),
          //icon: markericon2
          icon: BitmapDescriptor.fromBytes(markerIcond)
          //icon: BitmapDescriptor.fromAsset('marcericon2')
          // icon: BitmapDescriptor.defaultMarker),
          // icon: BitmapDescriptor.fromAssetImage(null, 'icons/cartime1.png'),
          ));
    }
  }

/**
  Future<BitmapDescriptor> _getAssetIcon(
      String path, BuildContext context) async {
    final Completer<BitmapDescriptor> bitmapIcon =
        Completer<BitmapDescriptor>();
    final ImageConfiguration config = createLocalImageConfiguration(context);

    AssetImage('assets/marcericons/' + path)
        .resolve(config)
        .addListener((ImageInfo image, bool sync) async {
      final ByteData bytes =
          await image.image.toByteData(format: ImageByteFormat.png);
      final BitmapDescriptor bitmap =
          BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
      bitmapIcon.complete(bitmap);
    });

    return await bitmapIcon.future;
  }
   */

  Future<Uint8List> getBytesFromCanvas(int width, int height) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.blue;
    final Radius radius = Radius.circular(20.0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: 'Hello world',
      style: TextStyle(fontSize: 25.0, color: Colors.white),
    );
    painter.layout();
    painter.paint(
        canvas,
        Offset((width * 0.5) - painter.width * 0.5,
            (height * 0.5) - painter.height * 0.5));
    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data.buffer.asUint8List();
  }

  Future<Uint8List> getBytesFromCanvasImage(
      int width, int height, urlAsset) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.transparent;
    final Radius radius = Radius.circular(20.0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);

    final ByteData datai = await rootBundle.load(urlAsset);

    var imaged = await loadImage(new Uint8List.view(datai.buffer));

    canvas.drawImage(imaged, new Offset(0, 0), new Paint());

    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data.buffer.asUint8List();
  }

  Future<ui.Image> loadImage(List<int> img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  Future<Uint8List> getBytesFromCanvasImage2(
      int width, int height, urlAsset) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final ByteData datai = await rootBundle.load(urlAsset);
    var imaged = await loadImage(new Uint8List.view(datai.buffer));
    canvas.drawImageRect(
      imaged,
      Rect.fromLTRB(
          0.0, 0.0, imaged.width.toDouble(), imaged.height.toDouble()),
      Rect.fromLTRB(0.0, 0.0, width.toDouble(), height.toDouble()),
      new Paint(),
    );

    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data.buffer.asUint8List();
  }

  addPolylines(double factor) {
    LatLng locationCenter = LatLng(48.217154, 11.176124);

    List<LatLng> s = polylineCircleHelper(locationCenter, factor);

    Polyline p = Polyline(
        polylineId: PolylineId('100544'),
        geodesic: false,
        points: s,
        visible: false);

    _polyLines.add(p);
  }

  showNewPolyLine(LatLng locationCenter, Color color, double factor) {
    _polyLines.clear();

    List<LatLng> s = polylineCircleHelper(locationCenter, factor);

    Polyline p = Polyline(
        polylineId: PolylineId('100544'),
        geodesic: false,
        points: s,
        visible: true,
        color: color);

    setState(() {
      _polyLines.add(p);
    });
  }

  showNewPolygons(
      LatLng locationCenter, Color color, String id, double factor) {
    widget.polygons.clear();

    List<LatLng> s = polylineCircleHelper(locationCenter, factor);

    Polygon p = Polygon(
        polygonId: PolygonId(id),
        geodesic: false,
        points: s,
        visible: true,
        fillColor: color.withOpacity(0.2));

    setState(() {
      widget.polygons.add(p);
    });
  }

  List<LatLng> polylineCircleHelper(LatLng center, double factor) {
    List<LatLng> circle = new List<LatLng>();

    double x = center.latitude;
    double y = center.longitude - 0.2 * factor;
    circle.add(LatLng(x, y));

    x += 0.1 * factor;
    y += 0.05 * factor;
    circle.add(LatLng(x, y));

    x += 0.1 * factor;
    y += 0.15 * factor;
    circle.add(LatLng(x, y));

    x -= 0.0125 * factor;
    y += 0.18 * factor;
    circle.add(LatLng(x, y));

    x -= 0.1875 * factor;
    y += 0.03 * factor;
    circle.add(LatLng(x, y));

    x -= 0.1 * factor;
    y -= 0.1 * factor;
    circle.add(LatLng(x, y));

    x -= 0.025 * factor;
    y -= 0.1 * factor;
    circle.add(LatLng(x, y));

    x += 0.0625 * factor;
    y -= 0.1 * factor;
    circle.add(LatLng(x, y));

    x += 0.0625 * factor;
    y -= 0.11 * factor;
    circle.add(LatLng(x, y));

    return circle;
  }
}
