import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_flutter/google_map_service/google_map_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    GoogleMapService().markerAdd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          GoogleMapController controller =
              await GoogleMapService().googleMapController.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(21.170240, 72.831062), zoom: 14),
          ));
          setState(() {});
        },
        child: Icon(Icons.location_searching_rounded),
      ),
      body: SafeArea(
        child: GoogleMapService()
            .googleMap(markers: GoogleMapService().listMarker),
      ),
    );
  }
}
