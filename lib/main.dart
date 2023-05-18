import 'package:flutter/material.dart';
import 'package:google_map_flutter/convert_address.dart';
import 'package:google_map_flutter/home_screen.dart';
import 'package:google_map_flutter/tracking_location.dart';
import 'package:google_map_flutter/user_cureeent%20_location.dart';

import 'custom_info_window.dart';
import 'custom_marker_screen.dart';
import 'custom_network_image.dart';
import 'google_searcgh_place_autocomplete.dart';
import 'map_cutmize.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TrackingLocationGoogleMapScreen());


  }
}
