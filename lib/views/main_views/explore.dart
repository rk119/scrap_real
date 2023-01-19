// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../themes/theme_provider.dart';
import '../../widgets/text_widgets/custom_textformfield.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentPosition;
  BitmapDescriptor currentPositionIcon = BitmapDescriptor.defaultMarker;
  final TextEditingController _search = TextEditingController();
  Timer? debounce;

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

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
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
          : Stack(
              children: [
                GoogleMap(
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
                  },
                ),
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                            color:
                                Provider.of<ThemeProvider>(context).themeMode ==
                                        ThemeMode.dark
                                    ? Colors.black
                                    : const Color(0xfffdfbfb),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x3f000000),
                                blurRadius: 2,
                                offset: Offset(1, 2),
                              )
                            ]),
                        child: TextFormField(
                          controller: _search,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            border: InputBorder.none,
                            hintText: "Search",
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              color: const Color.fromARGB(255, 193, 193, 193),
                            ),
                          ),
                          onChanged: (value) {
                            if (debounce?.isActive ?? false) debounce?.cancel();
                            debounce = Timer(
                              const Duration(milliseconds: 700),
                              () async {
                                if (value.length > 2) {
                                  print(value);
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
