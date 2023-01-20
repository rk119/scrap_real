import 'dart:convert';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:scrap_real/main.dart';

LatLng getLatLngFromSharedPrefs() {
  return sharedPreferences.getDouble('latitude') != null
      ? LatLng(sharedPreferences.getDouble('latitude')!,
          sharedPreferences.getDouble('longitude')!)
      : LatLng(0, 0);
}

Map getDecodedResponseFromSharedPrefs(int index) {
  String key = 'restaurant--$index';
  Map response = json.decode(sharedPreferences.getString(key)!);
  return response;
}

num getDistanceFromSharedPrefs(int index) {
  num distance = getDecodedResponseFromSharedPrefs(index)['distance'];
  return distance;
}

num getDurationFromSharedPrefs(int index) {
  num duration = getDecodedResponseFromSharedPrefs(index)['duration'];
  return duration;
}

Map getGeometryFromSharedPrefs(int index) {
  Map geometry = getDecodedResponseFromSharedPrefs(index)['geometry'];
  return geometry;
}
