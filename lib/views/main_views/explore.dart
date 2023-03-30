import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/models/autocomplate_prediction.dart';
import 'package:scrap_real/models/place_auto_complate_response.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/utils/network_utility.dart';
import 'package:scrap_real/views/main_views/ar_view.dart';
import 'package:scrap_real/views/main_views/location_list_tile.dart';
import 'package:scrap_real/widgets/scrapbook_widgets/custom_scrapbookmini.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  GoogleMapController? _controller;
  late LatLng _currentPosition = const LatLng(0, 0);
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  final Set<Marker> markers = {};
  var scrapbookData = [];
  bool isLoading = true;
  final TextEditingController _search = TextEditingController();
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  List<AutocompletePrediction> placesPredictions = [];
  Timer? debounce;
  bool tapped = false;
  bool isListVisible = true;
  // var apiKey = DotEnv().env['API_KEY'];
  var apiKey = 'Your API key';

  setCustomMarkerIcon() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/markers/placeholder.png");
  }

  @override
  void initState() {
    super.initState();
    getData();
    getLocation();
    setCustomMarkerIcon();
  }

  getData() async {
    try {
      var scrapbookSnap =
          await FirebaseFirestore.instance.collection('scrapbooks').get();

      for (int i = 0; i < scrapbookSnap.size; i++) {
        var location = [];
        var scrapData = scrapbookSnap.docs[i].data();
        if (scrapData['latitude'] == 0 ||
            scrapData['longitude'] == 0 ||
            scrapData['type'] == 'Secret') {
          continue;
        } else {
          location.add(scrapData['scrapbookId']);
          location.add(scrapData['latitude']);
          location.add(scrapData['longitude']);
          location.add(scrapData['title']);
          location.add(scrapData['coverUrl']);
          location.add(scrapData['tag']);
          location.add(scrapData['creatorUid']);
          location.add(scrapData['visibility']);
          location.add(scrapData['type']);
          scrapbookData.add(location);
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void clearSearchText() {
    setState(() {
      _search.clear();
      isListVisible = false;
    });
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
    _controller!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: newLatLng, zoom: 14)));
    setState(() {
      _currentPosition = newLatLng;
    });
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalObjectKey<ExpandableFabState>(context);
    return isLoading
        ? Container(
            color:
                Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
                    ? Colors.grey.shade900
                    : Colors.white,
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFF918EF4)),
            ),
          )
        : Scaffold(
            body: _currentPosition.latitude == 0 ||
                    _currentPosition.longitude == 0
                ? Container(
                    color: Colors.white,
                    child: const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF918EF4)),
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
                        onTap: (position) {
                          _customInfoWindowController.hideInfoWindow!();
                        },
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        markers: getMarkers(),
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
                                height:
                                    MediaQuery.of(context).size.height * 0.05),
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
                                  suffixIcon: _search.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(
                                            Icons.clear,
                                            color: Colors.black,
                                          ),
                                          onPressed: clearSearchText,
                                        )
                                      : null,
                                  border: InputBorder.none,
                                  hintText: "Search",
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                    color: const Color.fromARGB(
                                        255, 193, 193, 193),
                                  ),
                                ),
                                onChanged: (value) {
                                  _search.text.isNotEmpty
                                      ? isListVisible = true
                                      : isListVisible = false;
                                  placeAutocomplete(value);
                                },
                              ),
                            ),
                            Visibility(
                              visible: isListVisible,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: placesPredictions.length,
                                itemBuilder: (context, index) => Center(
                                  child: Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        color: const Color(0xfffdfbfb),
                                        child: LocationListTile(
                                          press: () {
                                            isListVisible = false;
                                            getLatLngFromPlaceId(
                                                placesPredictions[index]
                                                    .placeId!);
                                            _search.text =
                                                placesPredictions[index]
                                                    .description!;
                                          },
                                          location: placesPredictions[index]
                                              .description!,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
            floatingActionButtonLocation: ExpandableFab.location,
            floatingActionButton: ExpandableFab(
              key: key,
              overlayStyle: ExpandableFabOverlayStyle(
                // color: Colors.black.withOpacity(0.5),
                blur: 5,
              ),
              onOpen: () {
                debugPrint('onOpen');
              },
              afterOpen: () {
                debugPrint('afterOpen');
              },
              onClose: () {
                debugPrint('onClose');
              },
              afterClose: () {
                debugPrint('afterClose');
              },
              children: [
                FloatingActionButton(
                  heroTag: 'btn1',
                  onPressed: () async {
                    await getLocation();
                    _controller!.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(target: _currentPosition, zoom: 14)));
                  },
                  backgroundColor: const Color.fromARGB(255, 108, 200, 202),
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.black,
                  ),
                ),
                FloatingActionButton(
                  heroTag: 'btn2',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AugmentedRealityView(),
                      ),
                    );
                  },
                  backgroundColor: const Color.fromARGB(255, 108, 200, 202),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
  }

  Set<Marker> getMarkers() {
    if (scrapbookData.isNotEmpty) {
      setState(
        () {
          for (int index = 0; index < scrapbookData.length; index++) {
            markers.add(
              Marker(
                markerId: MarkerId(scrapbookData[index][0]),
                position: LatLng(
                  scrapbookData[index][1],
                  scrapbookData[index][2],
                ),
                icon: markerIcon,
                onTap: () {
                  _customInfoWindowController.addInfoWindow!(
                    Container(
                      height: 100,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          ScrapbookMiniSize(
                            scrapbookId: scrapbookData[index][0],
                            scrapbookTitle: scrapbookData[index][3],
                            coverImage: scrapbookData[index][4],
                            scrapbookTag: scrapbookData[index][5],
                            creatorId: scrapbookData[index][6],
                            visibility: scrapbookData[index][7],
                            type: scrapbookData[index][8],
                            map: true,
                          ),
                          ClipPath(
                            clipper: TriangleClipper(),
                            child: Container(
                              height: 15,
                              width: 15,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    LatLng(
                      scrapbookData[index][1],
                      scrapbookData[index][2],
                    ),
                  );
                },
              ),
            );
          }
        },
      );
    }
    return markers;
  }
}
