import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:scrap_real/main.dart';
import 'package:scrap_real/utils/shared_prefs.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

// class _ExplorePageState extends State<ExplorePage> {
//   Completer<GoogleMapController> _controller = Completer();
//   LatLng? _currentPosition;
//   BitmapDescriptor currentPositionIcon = BitmapDescriptor.defaultMarker;
//   final TextEditingController _search = TextEditingController();
//   // List<AutocompletePrediction> placesPredictions = [];
//   // Mode? _mode = Mode.overlay;
//   Timer? debounce;

//   setCustomMarkerIcon() async {
//     currentPositionIcon = await BitmapDescriptor.fromAssetImage(
//         ImageConfiguration(), "assets/markers/current_location.png");
//   }

//   @override
//   void initState() {
//     super.initState();
//     getLocation();
//     setCustomMarkerIcon();
//   }

//   @override
//   void dispose() {
//     _search.dispose();
//     super.dispose();
//   }

//   getLocation() async {
//     await Geolocator.requestPermission();

//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     double lat = position.latitude;
//     double long = position.longitude;

//     LatLng location = LatLng(lat, long);

//     setState(() {
//       _currentPosition = location;
//     });

//     print(_currentPosition);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _currentPosition == null
//           ? Container(
//               color: Colors.white,
//               child: const Center(
//                 child: CircularProgressIndicator(),
//               ),
//             )
//           : Stack(
//               children: [
//                 GoogleMap(
//                   mapType: MapType.normal,
//                   initialCameraPosition: CameraPosition(
//                     target: _currentPosition!,
//                     zoom: 14,
//                   ),
//                   onMapCreated: (GoogleMapController controller) {
//                     _controller.complete(controller);
//                     _controller.future.then((value) {
//                       value.animateCamera(
//                           CameraUpdate.newLatLngZoom(_currentPosition!, 14));
//                     });
//                   },
//                   myLocationEnabled: true,
//                   // onCameraMove: (CameraPosition position) {
//                   //   setState(() {
//                   //     _currentPosition = position.target;
//                   //   });
//                   // },
//                   // markers: {
//                   //   Marker(
//                   //     markerId: const MarkerId('currentLocation'),
//                   //     position: _currentPosition!,
//                   //     icon: currentPositionIcon,
//                   //   ),
//                   // },
//                 ),
//                 Center(
//                   child: Column(
//                     children: [
//                       SizedBox(
//                           height: MediaQuery.of(context).size.height * 0.05),
//                       Container(
//                         width: MediaQuery.of(context).size.width * 0.9,
//                         decoration: BoxDecoration(
//                             color: const Color(0xfffdfbfb),
//                             borderRadius: BorderRadius.circular(15),
//                             boxShadow: const [
//                               BoxShadow(
//                                 color: Color(0x3f000000),
//                                 blurRadius: 2,
//                                 offset: Offset(1, 2),
//                               )
//                             ]),
//                         child: TextFormField(
//                           controller: _search,
//                           textCapitalization: TextCapitalization.words,
//                           decoration: InputDecoration(
//                             prefixIcon: const Icon(Icons.search),
//                             border: InputBorder.none,
//                             hintText: "Search",
//                             hintStyle: GoogleFonts.poppins(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                               height: 1.5,
//                               color: const Color.fromARGB(255, 193, 193, 193),
//                             ),
//                           ),
//                           onChanged: (value) {
//                             print(value);
//                             // if (debounce?.isActive ?? false) debounce?.cancel();
//                             // debounce = Timer(
//                             //   const Duration(milliseconds: 700),
//                             //   () async {
//                             //     if (value.length > 2) {
//                             //       print(value);
//                             //     }
//                             //   },
//                             // );
//                           },
//                         ),
//                       ),

//                       // TextButton(
//                       //     onPressed: () {
//                       //       LocationService().getPlaceId(_search.text);
//                       //     },
//                       //     child: Text("Dubai")),

//                       //   ElevatedButton(
//                       //     onPressed: () {
//                       //       placesAutocomplete("Dubai");
//                       //     },
//                       //     child: Text("Dubai"),
//                       //   ),
//                       // Expanded(
//                       // child: ListView.builder(
//                       // itemCount: placesPredictions.length,
//                       // itemBuilder: (context, index) => LocationListTile(
//                       //   press: () {},
//                       //   location: placesPredictions[index].description!,
//                       // ),
//                       // ),
//                       // ),
//                       // LocationListTile(
//                       //   press: () {},
//                       //   location: "Dubai",
//                       // ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }

// class ExplorePage extends StatefulWidget {
//   const ExplorePage({Key? key}) : super(key: key);

//   @override
//   State<ExplorePage> createState() => _ExplorePageState();
// }

class _ExplorePageState extends State<ExplorePage> {
  bool isLoading = false;
  LatLng latLng = getLatLngFromSharedPrefs();
  late CameraPosition _initialCameraPosition;
  late MapboxMapController controller;
  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeLocationAndSave();
    _initialCameraPosition = CameraPosition(
      target: latLng,
      zoom: 14,
    );
  }

  void initializeLocationAndSave() async {
    Location _location = Location();
    bool? _serviceEnabled;
    PermissionStatus? _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
    }

    LocationData _locationData = await _location.getLocation();
    LatLng currentLatLng =
        LatLng(_locationData.latitude!, _locationData.longitude!);

    sharedPreferences.setDouble('latitude', _locationData.latitude!);
    sharedPreferences.setDouble('longitude', _locationData.longitude!);

    setState(() {
      isLoading = true;
    });
  }

  _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            MapboxMap(
              accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              // myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
              minMaxZoomPreference: const MinMaxZoomPreference(14, 17),
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.animateCamera(
            CameraUpdate.newCameraPosition(_initialCameraPosition),
          );
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
