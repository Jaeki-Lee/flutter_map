import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_location/helper/local_app_directory.dart';
import 'package:flutter_location/helper/local_db_helper.dart';
import 'package:flutter_location/model/user_location.dart';
import 'package:flutter_location/preview_map_scree.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geocode;
import 'package:uuid/uuid.dart';

class RegisterMapScreen extends StatefulWidget {
  CameraPosition cameraPosition;

  RegisterMapScreen(this.cameraPosition);

  @override
  _RegisterMapScreenState createState() {
    return _RegisterMapScreenState();
  }
}

class _RegisterMapScreenState extends State<RegisterMapScreen> {
  bool _myLocationEnabled = true;
  bool _myLocationButtonEnabled = true;
  GoogleMapController _controller;
  String _address = '';
  GoogleMap _googleMap;
  Uuid uuid = Uuid();

  @override
  void initState() {
    super.initState();
    _getAddress(widget.cameraPosition.target.latitude,
            widget.cameraPosition.target.longitude)
        .then((address) {
      setState(() {
        _address = address;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _registerMapAppBar() {
    return AppBar(
      title: Text("지도"),
      actions: [
        TextButton(
          child: Text(
            "위치표시",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () async {
            // print(_address);

            //현재 지도를 캡쳐한다.
            final imageBytes = await _controller.takeSnapshot();
            //캡쳐한 사진을 로컬폴더에 저장한다.
            String fileName = uuid.v1() + ".png";
            String filePath =
                LocalAppDirectory.documentDirectory + '/' + fileName;
            File(filePath).writeAsBytesSync(imageBytes);
            //데이터를 db 에 저장한다.
            UserLocation userLocation = UserLocation(
              widget.cameraPosition.target.latitude,
              widget.cameraPosition.target.longitude,
              widget.cameraPosition.zoom,
              _address,
              filePath,
            );
            // LocalDBHelper.instance.insertUserLocation(userLocation);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PreviewMapScreen(userLocation),
              ),
            );
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // print("======build _cameraPosition ${_cameraPosition.toMap()}");
    _googleMap = GoogleMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: widget.cameraPosition,
      onCameraMove: _updateCameraPosition,
      myLocationButtonEnabled: _myLocationButtonEnabled,
      myLocationEnabled: _myLocationEnabled,
    );

    return Scaffold(
      appBar: _registerMapAppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: _googleMap,
      ),
    );
  }

  Future<String> _getAddress(double lat, double lon) async {
    List<geocode.Placemark> placemarks =
        await geocode.placemarkFromCoordinates(lat, lon);
    geocode.Placemark place = placemarks[0];
    return "${place.postalCode}, ${place.street}, ${place.locality}, ${place.subAdministrativeArea == ' ' ? place.subAdministrativeArea : place.administrativeArea}, ${place.country}";
  }

  void _updateCameraPosition(CameraPosition position) {
    setState(
      () {
        // _cameraPosition = position;
        widget.cameraPosition = position;
        _getAddress(position.target.latitude, position.target.longitude).then(
          (address) {
            _address = address;
          },
        );
      },
    );
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
      // _isMapCreated = true;
    });
  }
}
