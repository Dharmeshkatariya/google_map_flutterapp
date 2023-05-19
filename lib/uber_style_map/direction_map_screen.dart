import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_flutter/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show sqrt, cos, asin;

import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class DirectionMapScreen extends StatefulWidget {
  final double lat;
  final double long;

  DirectionMapScreen(this.lat, this.long);

  @override
  State<DirectionMapScreen> createState() => _DirectionMapScreenState();
}

class _DirectionMapScreenState extends State<DirectionMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Map<PolylineId, Polyline> polylines = {};
  Location location = Location();
  List<Marker> _markers = <Marker>[];


  Marker? sourcePosition, destinationPosition;
  PolylinePoints polylinePoints = PolylinePoints();
  LatLng curLocation = LatLng(21.1702, 72.8311);

  StreamSubscription<LocationData>? locationSubscription;

  @override
  void initState() {
    // TODO: implement initState
    getNavigation();
    addMarker();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sourcePosition == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  zoomControlsEnabled: false,
                  polylines: Set<Polyline>.of(polylines.values),
                  initialCameraPosition: CameraPosition(
                    target: curLocation,
                    zoom: 16,
                  ),
                  markers: {sourcePosition!, destinationPosition!},
                  onTap: (latLng) {
                    print(latLng);
                  },
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                Positioned(
                  top: 30,
                  left: 15,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => MyApp()),
                          (route) => false);
                    },
                    child: Icon(Icons.arrow_back),
                  ),
                ),
                Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.blue),
                      child: Center(
                        child: IconButton(
                          icon: Icon(
                            Icons.navigation_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            await launchUrl(Uri.parse(
                                'google.navigation:q=${widget.lat}, ${widget.long}&key=AIzaSyD9mMJ7RJpJzltWhe8g2X6NPfjQ9bU-WOs'));
                          },
                        ),
                      ),
                    ))
              ],
            ),
    );
  }

  addMarker() {
    setState(() {
      sourcePosition = Marker(
        markerId: MarkerId('source'),
        position: curLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
      destinationPosition = Marker(
        markerId: MarkerId('destination'),
        position: LatLng(widget.lat, widget.long),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      );
    });
  }

  getNavigation() async {
    try {
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      final GoogleMapController? controller = await _controller.future;
      //  location.changeSettings(accuracy: loc.LocationAccuracy.high);
      print("----- ---");

      _serviceEnabled = await location.serviceEnabled();

      // if (!_serviceEnabled) {
      //   _serviceEnabled = await location.requestService();
      //   if (!_serviceEnabled) {
      //     return;
      //   }
      // }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      curLocation = LatLng(curLocation.latitude, curLocation.longitude);
      loadData();

      // locationSubscription = location.onLocationChanged.listen((LocationData currentLocation) {
      //
      //   controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      //     target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
      //     zoom: 16,
      //   )));
      //   if (mounted) {
      //     controller
      //         ?.showMarkerInfoWindow(MarkerId(sourcePosition!.markerId.value));
      //     setState(() {
      //       curLocation =
      //           LatLng(currentLocation.latitude!, currentLocation.longitude!);
      //       sourcePosition = Marker(
      //         markerId: MarkerId(currentLocation.toString()),
      //         icon: BitmapDescriptor.defaultMarkerWithHue(
      //             BitmapDescriptor.hueBlue),
      //         position:
      //             LatLng(currentLocation.latitude!, currentLocation.longitude!),
      //         infoWindow: InfoWindow(
      //             title:
      //                 '${double.parse((getDistance(LatLng(widget.lat, widget.long)).toStringAsFixed(2)))} km'),
      //         onTap: () {
      //           print('market tapped');
      //         },
      //       );
      //     });
      //     getDirections(LatLng(widget.lat, widget.long));
      //   }
      // });
    } catch (e) {
      print(e);
    }
  }


  loadData() {
    getUserCurrentLocation().then((value) async {
      _markers.add(
        Marker(
            markerId: MarkerId("2"),
            position: LatLng(value.latitude, value.longitude),
            infoWindow: InfoWindow(title: "My current location")),
      );

      CameraPosition cameraPosition = CameraPosition(
          zoom: 14, target: LatLng(value.latitude, value.longitude));

      final GoogleMapController mapController = await _controller.future;
      mapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      setState(() {});
    });
  }


  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print(error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  double getDistance(LatLng destposition) {
    return calculateDistance(curLocation.latitude, curLocation.longitude,
        destposition.latitude, destposition.longitude);
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  getDirections(LatLng dst) async {
    List<LatLng> polylineCoordinates = [];
    List<dynamic> points = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyD9mMJ7RJpJzltWhe8g2X6NPfjQ9bU-WOs',
        PointLatLng(curLocation.latitude, curLocation.longitude),
        PointLatLng(dst.latitude, dst.longitude),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        points.add({'lat': point.latitude, 'lng': point.longitude});
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    setState(() {});
  }
}
