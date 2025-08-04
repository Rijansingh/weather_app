import 'package:flutter/material.dart';
import 'package:weather_app/models/favorite_location.dart';

class FirestoreService with ChangeNotifier {
  final List<FavoriteLocation> _mockLocations = [];
  bool _isMockMode = true;

  // Get all favorite locations for a user
  Stream<List<FavoriteLocation>> getFavoriteLocations(String userId) {
    if (_isMockMode) {
      // Return a stream that updates when the list changes
      return Stream.value(_mockLocations
          .where((location) => location.userId == userId)
          .toList());
    }
    return Stream.value([]);
  }

  // Add a new favorite location
  Future<void> addFavoriteLocation(FavoriteLocation location) async {
    if (_isMockMode) {
      // Check if location already exists
      final exists = _mockLocations.any((loc) =>
          loc.userId == location.userId &&
          loc.cityName.toLowerCase() == location.cityName.toLowerCase());

      if (!exists) {
        _mockLocations.add(location);
        notifyListeners();
      }
      return;
    }
  }

  // Delete a favorite location
  Future<void> deleteFavoriteLocation(String locationId) async {
    if (_isMockMode) {
      _mockLocations.removeWhere((location) => location.id == locationId);
      notifyListeners();
      return;
    }
  }

  // Update a favorite location
  Future<void> updateFavoriteLocation(
      String locationId, String newCityName) async {
    if (_isMockMode) {
      final location =
          _mockLocations.firstWhere((location) => location.id == locationId);
      final index = _mockLocations.indexOf(location);
      _mockLocations[index] = FavoriteLocation(
        id: location.id,
        userId: location.userId,
        cityName: newCityName,
        timestamp: DateTime.now(),
      );
      notifyListeners();
      return;
    }
  }

  // Check if a location is already in favorites
  bool isLocationFavorite(String userId, String cityName) {
    return _mockLocations.any((location) =>
        location.userId == userId &&
        location.cityName.toLowerCase() == cityName.toLowerCase());
  }

  // Get all locations for a user (synchronous version for immediate access)
  List<FavoriteLocation> getLocationsForUser(String userId) {
    return _mockLocations
        .where((location) => location.userId == userId)
        .toList();
  }

  // Clear all favorites (for testing)
  void clearAllFavorites() {
    _mockLocations.clear();
    notifyListeners();
  }
}
