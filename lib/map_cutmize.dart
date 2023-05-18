import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustmizeMapThemeScreen extends StatefulWidget{
  const CustmizeMapThemeScreen({Key? key}) : super(key: key);

  @override
  State<CustmizeMapThemeScreen> createState() => _CustmizeMapThemeScreenState();
}

class _CustmizeMapThemeScreenState extends State<CustmizeMapThemeScreen> {

  @override
  Widget build(BuildContext context) {
    String mapStyle = '' ;
    final Completer<GoogleMapController> _controller = Completer();

     const CameraPosition _kGooglePlex =  CameraPosition(
      target: LatLng(33.6941, 72.9734),
      zoom: 15,
    );

    @override
    void initState() {
      // TODO: implement initState
      super.initState();

      DefaultAssetBundle.of(context).loadString('assets/maptheme/ratiotheme.json').then((string) {

        mapStyle = string;

      }).catchError((error) {
        print("error"+error.toString());
      });
    }


    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            // This button presents popup menu items.
            PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: (){
                      _controller.future.then((value){
                        DefaultAssetBundle.of(context).loadString('assets/maptheme/ratiotheme.json').then((string) {
                          setState(() {
                          });

                          value.setMapStyle(string,);
                        });
                      }).catchError((error) {
                        print("error"+error.toString());
                      });
                    },
                    child: Text("Retro"),
                    value: 1,
                  ),
                  PopupMenuItem(
                    onTap: ()async{
                      _controller.future.then((value){
                        DefaultAssetBundle.of(context).loadString('assets/maptheme/nighttheme.json').then((string) {
                          setState(() {

                          });
                          value.setMapStyle(string);
                        });
                      }).catchError((error) {
                        print("error"+error.toString());
                      });
                    },
                    child: Text("Night"),
                    value: 2,
                  )
                ]
            )
          ],
        ),
        body: SafeArea(
          child: GoogleMap(

            initialCameraPosition: _kGooglePlex,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,

            onMapCreated: (GoogleMapController controller){
              controller.setMapStyle(mapStyle);
              _controller.complete(controller);
            },
          ),

        )
    );
  }
}
