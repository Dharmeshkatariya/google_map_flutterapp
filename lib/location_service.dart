import 'dart:convert';

import 'package:http/http.dart'as http;
class LocationService{

  final String key =  "AIzaSyD9mMJ7RJpJzltWhe8g2X6NPfjQ9bU-WOs";

  Future<String>  getPlacedId(String input)async{

    final String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&inputtype =textquery&key=$key';
    var response = await http.get(Uri.parse(url));
    print(response.body);
    var json = jsonDecode(response.body);

    var placeId = "";
    print(placeId);
    return placeId;
  }
}