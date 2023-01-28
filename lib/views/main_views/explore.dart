import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  Completer<GoogleMapController> _controller = Completer();
  late LatLng _currentPosition = const LatLng(0, 0);
  BitmapDescriptor currentPositionIcon = BitmapDescriptor.defaultMarker;
  final TextEditingController _search = TextEditingController();
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  // List<AutocompletePrediction> placesPredictions = [];
  // Mode? _mode = Mode.overlay;
  Timer? debounce;
  bool tapped = false;

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
      body: _currentPosition == null ||
              _currentPosition.latitude == 0 ||
              _currentPosition.longitude == 0
          ? Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition,
                    zoom: 14,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    // _controller.future.then((value) {
                    //   value.animateCamera(
                    //       CameraUpdate.newLatLngZoom(_currentPosition!, 14));
                    // });
                    _customInfoWindowController.googleMapController =
                        controller;
                  },
                  onCameraMove: (position) {
                    _customInfoWindowController.onCameraMove!();
                  },
                  myLocationEnabled: true,
                  // onCameraMove: (CameraPosition position) {
                  //   setState(() {
                  //     _currentPosition = position.target;
                  //   });
                  // },
                  markers: {
                    Marker(
                      markerId: const MarkerId('currentLocation'),
                      position: _currentPosition,
                      icon: currentPositionIcon,
                      onTap: () {
                        if (tapped) {
                          _customInfoWindowController.hideInfoWindow!();
                          tapped = false;
                        } else {
                          _customInfoWindowController.addInfoWindow!(
                              Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 135,
                                      width: 170,
                                      decoration: BoxDecoration(
                                        color: Colors.pink,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  ClipPath(
                                    clipper: TriangleClipper(),
                                    child: Container(
                                      height: 15,
                                      width: 15,
                                      color: Colors.pink,
                                    ),
                                  ),
                                ],
                              ),
                              _currentPosition);
                          tapped = true;
                        }
                      },
                    ),
                  },
                ),
                CustomInfoWindow(
                  height: 120,
                  width: 180,
                  controller: _customInfoWindowController,
                ),
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                            color: const Color(0xfffdfbfb),
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
                          textCapitalization: TextCapitalization.words,
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
                            print(value);
                            // if (debounce?.isActive ?? false) debounce?.cancel();
                            // debounce = Timer(
                            //   const Duration(milliseconds: 700),
                            //   () async {
                            //     if (value.length > 2) {
                            //       print(value);
                            //     }
                            //   },
                            // );
                          },
                        ),
                      ),

                      // TextButton(
                      //     onPressed: () {
                      //       LocationService().getPlaceId(_search.text);
                      //     },
                      //     child: Text("Dubai")),

                      //   ElevatedButton(
                      //     onPressed: () {
                      //       placesAutocomplete("Dubai");
                      //     },
                      //     child: Text("Dubai"),
                      //   ),
                      // Expanded(
                      // child: ListView.builder(
                      // itemCount: placesPredictions.length,
                      // itemBuilder: (context, index) => LocationListTile(
                      //   press: () {},
                      //   location: placesPredictions[index].description!,
                      // ),
                      // ),
                      // ),
                      // LocationListTile(
                      //   press: () {},
                      //   location: "Dubai",
                      // ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
