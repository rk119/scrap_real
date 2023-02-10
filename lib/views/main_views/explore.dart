import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:scrap_real/models/autocomplate_prediction.dart';
import 'package:scrap_real/models/place_auto_complate_response.dart';
import 'package:scrap_real/utils/network_utility.dart';
import 'package:scrap_real/views/main_views/location_list_tile.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  GoogleMapController? _controller;
  late LatLng _currentPosition = const LatLng(0, 0);
  BitmapDescriptor currentPositionIcon = BitmapDescriptor.defaultMarker;
  final TextEditingController _search = TextEditingController();
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  List<AutocompletePrediction> placesPredictions = [];
  Timer? debounce;
  bool tapped = false;
  // var apiKey = DotEnv().env['API_KEY'];
  var apiKey = 'AIzaSyAPDpwLsPSi4QpbyZZR0Ze8fgKNTPk3srk';

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

  void placeAutocomplete(String query) async {
    Uri uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/autocomplete/json',
      {
        'input': query,
        'key': apiKey,
      },
    );
    String? response = await NetworkUtility().fetchUrl(uri);
    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placesPredictions = result.predictions!;
        });
      }
    }
  }

  void getLatLngFromPlaceId(String placeId) async {
    Uri uri = Uri.https(
      'maps.googleapis.com',
      'maps/api/geocode/json',
      {
        'place_id': placeId,
        'key': apiKey,
      },
    );
    String? response = await NetworkUtility().fetchUrl(uri);
    final parsed = json.decode(response!).cast<String, dynamic>();
    LatLng newLatLng = LatLng(
        parsed['results'][0]['geometry']['location']['lat'],
        parsed['results'][0]['geometry']['location']['lng']);
    print(newLatLng);
    _controller!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: newLatLng, zoom: 14)));
    setState(() {
      _currentPosition = newLatLng;
    });
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
                child: CircularProgressIndicator(color: Color(0xFF918EF4)),
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
                    _controller = controller;
                    _customInfoWindowController.googleMapController =
                        controller;
                  },
                  onCameraMove: (position) {
                    _customInfoWindowController.onCameraMove!();
                  },
                  myLocationEnabled: true,
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
                            placeAutocomplete(value);
                          },
                        ),
                      ),
                      Expanded(
                          child: ListView.builder(
                        itemCount: placesPredictions.length,
                        itemBuilder: (context, index) => LocationListTile(
                          press: () {
                            getLatLngFromPlaceId(
                                placesPredictions[index].placeId!);
                            // Hana: clean up search and remove list view
                          },
                          location: placesPredictions[index].description!,
                        ),
                      ))
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
