class UserLocation {
  double latitude;
  double lontitude;
  double cameraZoom;
  String address;
  String imagePath;

  UserLocation(this.latitude, this.lontitude, this.cameraZoom, this.address,
      this.imagePath);

  factory UserLocation.fromMap(Map<String, dynamic> map) {
    double lat = double.parse(map["lat"]);
    double lon = double.parse(map["lon"]);
    double cameraZoom = double.parse(map["camera_zoom"]);

    return UserLocation(
        lat, lon, cameraZoom, map["address"], map["image_path"]);
  }
}
