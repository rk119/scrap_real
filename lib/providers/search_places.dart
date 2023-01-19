import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final placeResultsProvider = ChangeNotifierProvider<PlaceResults>(
  (ref) {
    return PlaceResults();
  },
);

class PlaceResults extends ChangeNotifier {
  List<Place> _placeResults = [];
  List<Place> get placeResults => _placeResults;

  void setPlaceResults(List<Place> placeResults) {
    _placeResults = placeResults;
    notifyListeners();
  }
}
