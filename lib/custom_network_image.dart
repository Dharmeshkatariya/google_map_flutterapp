import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomNetworkImageMarkerScreen extends StatefulWidget {
  const CustomNetworkImageMarkerScreen({Key? key}) : super(key: key);

  @override
  State<CustomNetworkImageMarkerScreen> createState() =>
      _CustomNetworkImageMarkerScreenState();
}

class _CustomNetworkImageMarkerScreenState
    extends State<CustomNetworkImageMarkerScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  List<String> images = [
    "assets/image/p1.png",
    "assets/image/p2.png",
    "assets/image/p3.png",
    "assets/image/p4.png",
    "assets/image/p1.png",
    "assets/image/p2.png",

  ];

  final List<Marker> _markers = <Marker>[];
  List<LatLng> _latLang = [
    LatLng(33.6941, 72.9734),
    LatLng(33.7008, 72.9682),
    LatLng(33.6992, 72.9744),
    LatLng(33.6939, 72.9771),
    LatLng(33.6910, 72.9807),
    LatLng(33.7036, 72.9785)
  ];

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.6941, 72.9734),
    zoom: 15,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
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
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }

  loadData() async {
    for (int i = 0; i < images.length; i++) {
      Uint8List? image = await _loadNetworkImage(
          'https://images.bitmoji.com/3d/avatar/201714142-99447061956_1-s5-v1.webp');

      final ui.Codec markerImageCodec = await instantiateImageCodec(
        image!.buffer.asUint8List(),
        targetHeight: 200,
        targetWidth: 200,
      );
      final FrameInfo frameInfo = await markerImageCodec.getNextFrame();
      final ByteData? byteData = await frameInfo.image.toByteData(
        format: ImageByteFormat.png,
      );

      final Uint8List resizedMarkerImageBytes = byteData!.buffer.asUint8List();
      _markers.add(Marker(
        markerId: MarkerId(i.toString()),
        position: _latLang[i],
        icon: BitmapDescriptor.fromBytes(resizedMarkerImageBytes),
        anchor: Offset(.1, .1),
        //icon: BitmapDescriptor.fromBytes(image!.buffer.asUint8List()),
        infoWindow: InfoWindow(title: 'This is title marker: ' + i.toString()),
      ));
      setState(() {});
    }
  }

  Future<Uint8List?> _loadNetworkImage(String path) async {
    final completer = Completer<ImageInfo>();
    var img = NetworkImage(path);
    img
        .resolve(const ImageConfiguration(size: Size.fromHeight(10)))
        .addListener(
            ImageStreamListener((info, _) => completer.complete(info)));
    final imageInfo = await completer.future;
    final byteData = await imageInfo.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return byteData?.buffer.asUint8List();
  }
}
