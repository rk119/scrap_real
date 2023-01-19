// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../themes/theme_provider.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentPosition;
  BitmapDescriptor currentPositionIcon = BitmapDescriptor.defaultMarker;

  setCustomMarkerIcon() async {
    currentPositionIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), "assets/markers/current_location.png");
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    setCustomMarkerIcon();
  }

  getLocation() async {
    await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {
      _currentPosition = location;
    });

    print(_currentPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? Container(
              color: Provider.of<ThemeProvider>(context).themeMode ==
                      ThemeMode.dark
                  ? Colors.grey.shade900
                  : Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 14,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: {
                  Marker(
                    markerId: const MarkerId('currentLocation'),
                    position: _currentPosition!,
                    icon: currentPositionIcon,
                  ),
                }),
    );
  }
}
