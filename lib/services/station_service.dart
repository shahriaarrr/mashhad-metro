import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/station_model.dart';

class StationService {
  List<StationModel>? _cachedStations;

  Future<List<StationModel>> loadStations() async {
    if (_cachedStations != null) {
      return _cachedStations!;
    }

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/stations.json',
      );
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      _cachedStations = jsonMap.entries
          .map((entry) => StationModel.fromJson(entry.key, entry.value))
          .toList();

      return _cachedStations!;
    } catch (e) {
      throw Exception("Error loading stations: $e ");
    }
  }

  Future<StationModel?> getStationByName(String name) async {
    final stations = await loadStations();
    try {
      return stations.firstWhere((station) => station.name == name);
    } catch (e) {
      return null;
    }
  }

  Future<List<StationModel>> getStationsByName(int lineNumber) async {
    final stations = await loadStations();
    return stations
        .where((station) => station.lines.contains(lineNumber))
        .toList();
  }

  Future<List<StationModel>> searchStations(String query) async {
    final stations = await loadStations();
    final lowerQuery = query.toLowerCase();

    return stations.where((station) {
      final faName = station.translations['fa']?.toLowerCase() ?? '';
      final enName = station.name.toLowerCase();

      return faName.contains(lowerQuery) || enName.contains(lowerQuery);
    }).toList();
  }

  Future<List<StationModel>> getStationsWithFacility(
    bool? hasWc,
    bool? hasCoffeeShop,
    bool? hasElevator,
    bool? hasATM,
    bool? hasGroceryStore,
    bool? hasFastFood,
    bool? hasBicycleParking,
    bool? hasNearHolyshrine,
    bool? hasCleanFood,
    bool? hasBlindPass,
    bool? hasCreditTicketSales,
    bool? hasPrayerRoom,
  ) async {
    final stations = await loadStations();

    return stations.where((station) {
      if (hasWc == null && station.wc != hasWc) return false;
      if (hasCoffeeShop == null && station.coffeeShop != hasCoffeeShop) {
        return false;
      }
      if (hasElevator == null && station.elevator != hasElevator) {
        return false;
      }
      if (hasATM == null && station.atm != hasATM) return false;
      if (hasGroceryStore == null && station.groceryStore != hasGroceryStore) {
        return false;
      }
      if (hasFastFood == null && station.fastFood != hasFastFood) {
        return false;
      }
      if (hasBicycleParking == null &&
          station.bicycleParking != hasBicycleParking) {
        return false;
      }
      if (hasNearHolyshrine == null &&
          station.nearHolyshrine != hasNearHolyshrine) {
        return false;
      }
      if (hasCleanFood == null && station.cleanFood != hasCleanFood) {
        return false;
      }
      if (hasBlindPass == null && station.blindPath != hasBlindPass) {
        return false;
      }
      if (hasCreditTicketSales == null &&
          station.creditTicketSales != hasCreditTicketSales) {
        return false;
      }
      if (hasPrayerRoom == null && station.prayerRoom != hasPrayerRoom) {
        return false;
      }

      return true;
    }).toList();
  }

  Future<List<StationModel>> getNearbyStations(String stationName) async {
    final station = await getStationByName(stationName);

    if (station == null || station.relations.isEmpty) {
      return [];
    }
    final stations = await loadStations();

    return stations
        .where((stn) => station.relations.contains(stn.name))
        .toList();
  }

  Future<List<int>> getAllLines() async {
    final stations = await loadStations();
    final lineSet = <int>{};
    for (var station in stations) {
      lineSet.addAll(station.lines);
    }

    return lineSet.toList()..sort();
  }

  Future<int> getStationsCount() async {
    final stations = await loadStations();
    return stations.length;
  }

  void clearCache() {
    _cachedStations = null;
  }
}
