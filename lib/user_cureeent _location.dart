import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_flutter/home_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetUserCurrentLocationScreen extends StatefulWidget {
  const GetUserCurrentLocationScreen({Key? key}) : super(key: key);

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(21.170240, 72.831062),
    zoom: 14,
  );

  @override
  State<GetUserCurrentLocationScreen> createState() =>
      _GetUserCurrentLocationScreenState();
}

class _GetUserCurrentLocationScreenState
    extends State<GetUserCurrentLocationScreen> {
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> _markers = <Marker>[];
  List<Marker> list = [
    Marker(
        markerId: MarkerId("1"),
        position: LatLng(21.170240, 72.831062),
        infoWindow: InfoWindow(title: "My Location")),
  ];

  @override
  void initState() {
    // TODO: implement initState
    _markers.addAll(list);
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.location_searching_rounded),
      ),
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: GetUserCurrentLocationScreen._kGooglePlex,
          mapType: MapType.hybrid,
          markers: Set<Marker>.of(_markers),
          compassEnabled: true,
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
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
}
