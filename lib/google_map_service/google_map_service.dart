import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapService {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(21.170240, 72.831062),
    zoom: 14,
  );

  List<Marker> listMarker = <Marker>[];
  List<Marker> list = const [
    Marker(
        markerId: MarkerId("1"),
        position: LatLng(21.170240, 72.831062),
        infoWindow: InfoWindow(title: "My Location")),
  ];
  Completer<GoogleMapController> googleMapController = Completer();

  markerAdd() {
    listMarker.addAll(list);
  }

  Widget googleMap({required List<Marker> markers}) {

    return GoogleMap(
      initialCameraPosition: _kGooglePlex,
      mapType: MapType.satellite,
      markers: Set<Marker>.of(markers),
      compassEnabled: true,
      myLocationEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        googleMapController.complete(controller);
      },
    );
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  customMarkerData() async {
    listMarker.clear();
    Uint8List? markerImage;

    List<String> images = [
      "assets/image/p1.png",
      "assets/image/p2.png",
      "assets/image/p3.png",
      "assets/image/p4.png",
    ];

    final List<LatLng> _latLang = <LatLng>[
      LatLng(33.6941, 72.9734),
      LatLng(33.6939, 72.9771),
      LatLng(33.6910, 72.9807),
      LatLng(33.7036, 72.9785)
    ];

    for (int i = 0; i < images.length; i++) {
      final Uint8List markerIcon =
          await getBytesFromAsset(images[i].toString(), 100);
      listMarker.add(Marker(
          markerId: MarkerId(i.toString()),
          position: _latLang[i],
          icon: BitmapDescriptor.fromBytes(markerIcon),
          infoWindow: InfoWindow(title: 'The title of the marker')));
    }
  }


}
