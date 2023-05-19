import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'direction_map_screen.dart';

class UberMapScreen extends StatefulWidget {
  const UberMapScreen({Key? key}) : super(key: key);

  @override
  State<UberMapScreen> createState() => _UberMapScreenState();
}

class _UberMapScreenState extends State<UberMapScreen> {

  final latController = TextEditingController();
  final longController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    latController.text = "21.1702";
    longController.text = ' 72.8311';
    return Scaffold(
      appBar: AppBar(
        title: Text("uber map"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Enter your location',
            style: TextStyle(fontSize: 40),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: latController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'latitude',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: longController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'longitute',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DirectionMapScreen(
                          double.parse(latController.text),
                          double.parse(longController.text))));
                },
                child: Text('Get Directions')),
          ),
        ]),
      ),
    );
  }
}
