import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_flutter/google_map_service/google_map_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarkerScreen extends StatefulWidget {
  const CustomMarkerScreen({Key? key}) : super(key: key);

  @override
  State<CustomMarkerScreen> createState() => _CustomMarkerScreenState();
}

class _CustomMarkerScreenState extends State<CustomMarkerScreen> {


 Uint8List? markerImage;
  final List<Marker> _markers =  <Marker>[];
  final List<LatLng> _latLang =  <LatLng>[
    LatLng(33.6941, 72.9734),
    LatLng(33.6939, 72.9771), LatLng(33.6910, 72.9807), LatLng(33.7036, 72.9785)];

  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex =  CameraPosition(
    target: LatLng(33.6910, 72.98072),
    zoom: 15,
  );
  List<String> images = [
    "assets/image/p1.png",
    "assets/image/p2.png",
    "assets/image/p3.png",
    "assets/image/p4.png",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     loadData();
  }
 Future<Uint8List> getBytesFromAsset(String path, int width) async {
   ByteData data = await rootBundle.load(path);
   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
   ui.FrameInfo fi = await codec.getNextFrame();
   return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();

 }

  loadData()async{

    for(int i = 0 ; i < images.length ; i++){

     final Uint8List markerIcon = await getBytesFromAsset(images[i].toString(), 100);
      _markers.add(Marker(
          markerId: MarkerId(i.toString()),
          position: _latLang[i],
          icon: BitmapDescriptor.fromBytes(markerIcon),
          infoWindow: InfoWindow(
              title: 'The title of the marker'
          )
      ));
      setState(() {

      });
    }



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          markers: Set<Marker>.of(_markers),
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
          },
        ),

      ),
    );
  }
}
