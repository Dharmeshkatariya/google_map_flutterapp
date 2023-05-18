import 'dart:async';
import 'dart:convert';
import 'package:google_map_flutter/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AutoCompleteSearchApiScreen extends StatefulWidget {
  const AutoCompleteSearchApiScreen({Key? key}) : super(key: key);

  @override
  State<AutoCompleteSearchApiScreen> createState() =>
      _AutoCompleteSearchApiScreenState();
}

class _AutoCompleteSearchApiScreenState
    extends State<AutoCompleteSearchApiScreen> {
  var uuid = Uuid();
  String token = "12234";
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(21.170240, 72.831062),
    zoom: 14,
  );
  List<dynamic> _placeList = [];

  final searchController = TextEditingController();
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
    // searchController.addListener(() {
    //   // onChange();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Google search place api"),
      ),
      body: Container(

        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: TextFormField(
                onChanged: (value){

                  print(value);
                },
                textCapitalization: TextCapitalization.words,
                controller: searchController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(onPressed: (){

                    LocationService().getPlacedId(searchController.text);


                  },icon: Icon(Icons.search),),
                    hintText: "Search place ",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
              ),
            ),
            Expanded(

              child: GoogleMap(
                initialCameraPosition: _kGooglePlex,
                mapType: MapType.hybrid,
                markers: Set<Marker>.of(_markers),
                compassEnabled: true,
                myLocationEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _onChange() {
    if (token == null) {
      setState(() {
        token = uuid.v4();
      });
    }
    _getSuggestion(searchController.text);
  }

  _getSuggestion(String input) async {
    String kPLACES_API_KEY = "AIzaSyD9mMJ7RJpJzltWhe8g2X6NPfjQ9bU-WOs";
    String type = '(regions)';

    try {
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request =
          '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$token';

      var response = await http.get(Uri.parse(request));

      var data = json.decode(response.body);
      print('mydata');
      print(data);
      print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          _placeList = json.decode(response.body)['predictions'];
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      // toastMessage('success');
    }
  }
}
