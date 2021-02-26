import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_location/model/user_location.dart';
import 'package:flutter_location/register_map_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PreviewMapScreen extends StatefulWidget {
  UserLocation userLocation;

  PreviewMapScreen(this.userLocation);

  @override
  _PreviewMapScreenState createState() => _PreviewMapScreenState();
}

class _PreviewMapScreenState extends State<PreviewMapScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.userLocation);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            InkWell(
              child: Container(
                width: 350,
                height: 450,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: FileImage(File(widget.userLocation.imagePath)),
                  fit: BoxFit.cover,
                )),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      CameraPosition cameraPosition = CameraPosition(
                        target: LatLng(widget.userLocation.latitude,
                            widget.userLocation.lontitude),
                        zoom: 18,
                      );
                      return new RegisterMapScreen(cameraPosition);
                    },
                  ),
                );
              },
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              children: [
                Text("주소: ${widget.userLocation.address}"),
                Text("Latitude: ${widget.userLocation.latitude}"),
                Text("Lontitude: ${widget.userLocation.lontitude}"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
