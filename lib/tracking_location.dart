import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_map_flutter/google_map_service/google_map_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class TrackingLocationGoogleMapScreen extends StatefulWidget {
  const TrackingLocationGoogleMapScreen({Key? key}) : super(key: key);

  @override
  State<TrackingLocationGoogleMapScreen> createState() =>
      _TrackingLocationGoogleMapScreenState();
}

class _TrackingLocationGoogleMapScreenState
    extends State<TrackingLocationGoogleMapScreen> {
  LocationData? currentLocation;

  getCurrentLocation() {
    Location location = Location();
    location.requestPermission();
    location.getLocation().then((location) {
      currentLocation = location;
    });
  }

  LatLng sourceLoction = LatLng(21.1702, 72.8311);
  LatLng destination = LatLng(21.1801, 72.8347);
  List<LatLng> polylineCordinate = [];

  getPolyPoint() async {
    PolylinePoints polyPoints = PolylinePoints();
    PolylineResult result = await polyPoints.getRouteBetweenCoordinates(
      "AIzaSyD9mMJ7RJpJzltWhe8g2X6NPfjQ9bU-WOs",
      PointLatLng(
        sourceLoction.latitude,
        sourceLoction.longitude,
      ),
      PointLatLng(
        destination.latitude,
        destination.longitude,
      ),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCordinate.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // getCurrentLocation();
    getPolyPoint();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Track order"),
      ),
      body: currentLocation != null ? Text("loadinf")  :GoogleMap(
          polylines: {
            Polyline(
                polylineId: PolylineId("route"),
                points: polylineCordinate,
                color: Colors.red,
                width: 5)
          },
          initialCameraPosition:
              CameraPosition(target:  sourceLoction, zoom: 14),
          markers: {

            // Marker(
            //   markerId: MarkerId("current location"),
            //   position: LatLng(currentLocation!.latitude!,currentLocation!.longitude!),
            // ),
            Marker(
              markerId: MarkerId("source"),
              position: sourceLoction,
            ),
            Marker(
              markerId: MarkerId("destinatio"),
              position: destination,
            ),
          }),
    );
  }
}
