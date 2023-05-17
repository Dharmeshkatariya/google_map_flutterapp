
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class ConvertToAddress extends StatefulWidget {
  const ConvertToAddress({Key? key}) : super(key: key);

  @override
  State<ConvertToAddress> createState() => _ConvertToAddressState();
}

class _ConvertToAddressState extends State<ConvertToAddress> {
  String strAddress = "";
  String stADD = "";
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
              onTap: () async{

                List<Location> locations =await locationFromAddress("Gronausestraat 710, Enschede");
                List<Placemark> placemarks =await placemarkFromCoordinates(52.2165157, 6.9437819);

                setState(() {
                  strAddress = locations.last.longitude.toString() +""+locations.last.latitude.toString();
                  stADD = placemarks.reversed.last.country.toString() + " "+ placemarks.reversed.last.subLocality.toString();
                });



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
}
