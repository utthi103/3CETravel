import 'package:flutter/material.dart';
import '../models/favourite.dart';

class FavouriteController with ChangeNotifier {
  List<Favourite> _favourites = [];

  List<Favourite> get favourites => _favourites;

  bool isFavourite(String id) {
    return _favourites.any((favourite) => favourite.id == id);
  }

  void addFavourite(Favourite favourite) {
    _favourites.add(favourite);
    notifyListeners(); // Notify UI to update
  }

  void removeFavourite(String id) {
    _favourites.removeWhere((favourite) => favourite.id == id);
    notifyListeners();
  }
}
