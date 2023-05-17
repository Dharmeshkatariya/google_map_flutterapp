import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(21.170240, 72.831062),
    zoom: 14,
  );
}

class _HomeScreenState extends State<HomeScreen> {
  List<Marker> _markers = <Marker>[];
  List<Marker> list = const [
    Marker(
        markerId: MarkerId("1"),
        position: LatLng(21.170240, 72.831062),
        infoWindow: InfoWindow(title: "My Location")),
  ];
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    // TODO: implement initState
    _markers.addAll(list);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(
                    21.170240, 72.831062
                ),
                zoom: 14),

          ));
          setState(() {

          });
        },
        child: Icon(Icons.location_searching_rounded),
      ),
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: HomeScreen._kGooglePlex,
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
}
