// @dart=2.9
import 'dart:async';
import 'package:flutter_location/model/user_location.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDBHelper {
  static Database db;

  LocalDBHelper._privateConstructor();

  static final LocalDBHelper instance = LocalDBHelper._privateConstructor();

  static Future<void> init() async {
    if (db == null) {
      db = await openDatabase(
        join(await getDatabasesPath(), 'flutter_location.db'),
        onCreate: onCreate,
        version: 1,
      );
    }
  }

  static Future<void> onCreate(Database db, int version) async {
    await db.execute(
      """
          CREATE TABLE "user_location" (
	          "user_location_id" INTEGER,
	          "lat"	TEXT,
	          "lon"	TEXT,
	          "camera_zoom"	TEXT,
	          "address"	TEXT,
	          "image_path"	TEXT,
	          PRIMARY KEY("map_id" AUTOINCREMENT)
          );
      """,
    );    
  }

  Future<List<Map<String, dynamic>>> bringUserLocation() async {
    final result = await db.rawQuery("""
      SELECT * FROM user_location;
      """);
    return result;
  }

  Future<int> insertUserLocation(UserLocation userLocation) async {
    final result = await db.insert('user_location', {
      "lat": "${userLocation.latitude}",
      "lon": "${userLocation.lontitude}",
      "camera_zoom": "${userLocation.cameraZoom}",
      "address": "${userLocation.address}",
      "image_path": "${userLocation.imagePath}",
    });

    if (result != 0) {
      await db.batch().commit();
    }

    return result;
  }
}
