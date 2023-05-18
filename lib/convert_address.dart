import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_map_flutter/google_map_service/google_map_service.dart';

class ConvertToAddress extends StatefulWidget {
  const ConvertToAddress({Key? key}) : super(key: key);

  @override
  State<ConvertToAddress> createState() => _ConvertToAddressState();
}

class _ConvertToAddressState extends State<ConvertToAddress> {
  var strAddress = "";
  var stADD = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Map"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(strAddress),
            Text(stADD),
            GestureDetector(
              onTap: () async {
                getLatLong();
                getAddressByLotLong();

                setState(() {});
              },
              child: Container(
                decoration: const BoxDecoration(color: Colors.green),
                height: 50,
                child: const Center(
                  child: Text("Convert"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String> getLatLong() async {
    List<Location> locations =
        await locationFromAddress("Gronausestraat 710, Enschede");

    strAddress = locations.last.longitude.toString() +
        "" +
        locations.last.latitude.toString();
    return strAddress;
  }

  Future<String> getAddressByLotLong() async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(52.2165157, 6.9437819);
    ;
    stADD = placemarks.reversed.last.country.toString() +
        " " +
        placemarks.reversed.last.subLocality.toString();
    return stADD;
  }
}
