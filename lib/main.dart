import 'package:flutter/material.dart';
import 'package:flutter_location/helper/local_app_directory.dart';
import 'package:flutter_location/helper/local_db_helper.dart';
import 'package:flutter_location/register_map_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  runApp(AppBuild());
}

class AppBuild extends StatefulWidget {
  @override
  _AppBuildState createState() => _AppBuildState();
}

class _AppBuildState extends State<AppBuild> {
  bool isTakingLocation = false;
  CameraPosition cameraPosition;

  @override
  void initState() {
    super.initState();

    LocalAppDirectory.init();
    LocalDBHelper.init();

    _setLatLon().then((position) {
      setState(() {
        cameraPosition = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 18);
        isTakingLocation = true;
      });
    });
    
  }

  @override
  Widget build(BuildContext context) {
    if (!isTakingLocation) {
      return Container();
    }
    return MaterialApp(
      home: RegisterMapScreen(cameraPosition),
    );
  }

  Future<Position> _setLatLon() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    return position;
  }
}
