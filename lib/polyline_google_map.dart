import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolyLineGoogleMapScreen extends StatefulWidget{
  const PolyLineGoogleMapScreen({Key? key}) : super(key: key);

  @override
  State<PolyLineGoogleMapScreen> createState() => _PolyLineGoogleMapScreenState();
}

class _PolyLineGoogleMapScreenState extends State<PolyLineGoogleMapScreen> {

  Completer<GoogleMapController> _controller = Completer();


  CameraPosition _kGooglePlex =  CameraPosition(
    target: LatLng(21.1702, 72.8311),
    zoom: 14,
  );
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};


  List<LatLng> latlong = [
    LatLng(21.1702, 72.8311),
    LatLng(21.1431, 72.8431),
    LatLng(21.1993, 72.8497),



  ];

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(int i = 0 ; i <latlong.length ; i++){
      _markers.add(

        Marker(markerId: MarkerId(i.toString()),
        position: latlong[i],
          infoWindow: InfoWindow(
            title: "cool  place",
            snippet: "5 star rating"
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),

      );
      _polyline.add(

        Polyline(polylineId: PolylineId("1"),points: latlong,color: Colors.orange,width: 4),
      );

    }
    setState(() {

    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(

        onMapCreated: (GoogleMapController controller){
          _controller.complete(controller);
        },
        polylines: _polyline,
        myLocationEnabled: true,
        markers: _markers,
        initialCameraPosition: _kGooglePlex,
      ),
    );
  }
}
