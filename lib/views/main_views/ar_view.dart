import 'dart:async';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/views/navigation.dart';
import 'package:scrap_real/views/scrapbook_views/solve_riddle.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'dart:math' as Math;

class AugmentedRealityView extends StatefulWidget {
  const AugmentedRealityView({Key? key}) : super(key: key);
  @override
  State<AugmentedRealityView> createState() => _AumentedgRealityViewState();
}

class _AumentedgRealityViewState extends State<AugmentedRealityView> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  var scrapbookData = [];
  late Position currentPosition = Position(
    latitude: 0,
    longitude: 0,
    altitude: 0,
    accuracy: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
    timestamp: DateTime.now(),
  );
  var nodes = [];
  bool isLoading = true;

  ARLocationManager? arLocationManager;

  @override
  void initState() {
    try {
      super.initState();
      scrapbookData.clear();
      getData();
      getCurrentPosition();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    arSessionManager!.dispose();
  }

  getData() async {
    var scrapbookSnap =
        await FirebaseFirestore.instance.collection('scrapbooks').get();

    for (int i = 0; i < scrapbookSnap.size; i++) {
      var location = [];
      var scrapData = scrapbookSnap.docs[i].data();
      if (scrapData['latitude'] == 0 ||
          scrapData['longitude'] == 0 ||
          scrapData['type'] != 'Secret') {
        continue;
      } else {
        location.add(scrapData['scrapbookId']);
        location.add(scrapData['latitude']);
        location.add(scrapData['longitude']);
        location.add(scrapData['altitude']);
        scrapbookData.add(location);
        print('Scrapbook $scrapbookData');
      }
    }
  }

  getCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.requestPermission();
    }

    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> addNodes() async {
    for (int i = 0; i < scrapbookData.length; i++) {
      ARNode node = ARNode(
          type: NodeType.webGLB,
          name: scrapbookData[i][0].toString(),
          uri:
              "https://github.com/rk119/question_box_test/raw/master/mario_mystery_box.glb",
          scale: vector.Vector3(0.2, 0.2, 0.2),
          rotation: vector.Vector4(1.0, 0.0, 0.0, 0.0),
          position: getPosition(
              scrapbookData[i][1], scrapbookData[i][2], scrapbookData[i][3]));
      await arObjectManager!.addNode(node);
      nodes.add([scrapbookData[i][0], node]);
    }
  }

  vector.Vector3 getPosition(double lat, double long, double alt) {
    const earthRadius = 6371000.0;
    double latRadians = Math.pi * lat / 180.0;
    double lonRadians = Math.pi * long / 180.0;
    double userLatRadians = Math.pi * currentPosition.latitude / 180.0;
    double userLonRadians = Math.pi * currentPosition.longitude / 180.0;

    double x =
        (earthRadius + alt) * Math.cos(latRadians) * Math.cos(lonRadians) -
            ((earthRadius + alt) *
                Math.cos(userLatRadians) *
                Math.cos(userLonRadians));
    double y =
        (earthRadius + alt) * Math.cos(latRadians) * Math.sin(lonRadians) -
            ((earthRadius + alt) *
                Math.cos(userLatRadians) *
                Math.sin(userLonRadians));
    double z = (earthRadius + alt) * Math.sin(latRadians) -
        ((earthRadius + alt) * Math.sin(userLatRadians));

    vector.Vector3 vectorCoordinates = vector.Vector3(x, y, z);

    return vectorCoordinates;
  }

  @override
  Widget build(BuildContext context) {
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
            body: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0, left: 15.0),
                    child: CustomBackButton(buttonFunction: () {
                      arSessionManager!.dispose();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NavBar(
                            currentIndex: 1,
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: ARView(
                      onARViewCreated: _onARViewCreated,
                      planeDetectionConfig:
                          PlaneDetectionConfig.horizontalAndVertical,
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  void _onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;

    this.arSessionManager!.onInitialize(
          showFeaturePoints: false,
          showPlanes: true,
          showWorldOrigin: true,
          handleTaps: false,
          showAnimatedGuide: false,
        );

    arObjectManager.onInitialize();
    addNodes();
    arObjectManager.onNodeTap = (nodes) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecretScrapbook(
            scrapbookId: nodes[0],
          ),
        ),
      );
    };
  }
}
