import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/station_model.dart';
import '../services/station_service.dart';

final stationServiceProvider = Provider<StationService>((ref) {
  return StationService();
});

final allStationsProvider = FutureProvider<List<StationModel>>((ref) async {
  final service = ref.watch(stationServiceProvider);
  return service.loadStations();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<StationModel>>((ref) async {
  final service = ref.watch(stationServiceProvider);
  final query = ref.watch(searchQueryProvider);

  if (query.isEmpty) {
    return service.loadStations();
  }

  return service.searchStations(query);
});

final selectedLineProvider = StateProvider<int?>((ref) => null);

final stationsByLineProvider = FutureProvider<List<StationModel>>((ref) async {
  final service = ref.watch(stationServiceProvider);
  final selectedLine = ref.watch(selectedLineProvider);

  if (selectedLine == null) {
    return service.loadStations();
  }

  return service.getStationsByLine(selectedLine);
});

final stationByNameProvider = FutureProvider.family<StationModel?, String>((
  ref,
  name,
) async {
  final service = ref.watch(stationServiceProvider);
  return service.getStationByName(name);
});

final nearbyStationsProvider =
    FutureProvider.family<List<StationModel>, String>((ref, stationName) async {
      final service = ref.watch(stationServiceProvider);
      return service.getNearbyStations(stationName);
    });

class FacilityFilter {
  final bool? hasWc;
  final bool? hasCoffeeShop;
  final bool? hasElevator;
  final bool? hasATM;
  final bool? hasGroceryStore;
  final bool? hasFastFood;
  final bool? hasBicycleParking;
  final bool? hasNearHolyshrine;
  final bool? hasCleanFood;
  final bool? hasBlindPass;
  final bool? hasCreditTicketSales;
  final bool? hasPrayerRoom;

  FacilityFilter({
    this.hasWc,
    this.hasCoffeeShop,
    this.hasElevator,
    this.hasATM,
    this.hasGroceryStore,
    this.hasFastFood,
    this.hasBicycleParking,
    this.hasNearHolyshrine,
    this.hasCleanFood,
    this.hasBlindPass,
    this.hasCreditTicketSales,
    this.hasPrayerRoom,
  });

  FacilityFilter copyWith({
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
  }) {
    return FacilityFilter(
      hasWc: hasWc ?? this.hasWc,
      hasCoffeeShop: hasCoffeeShop ?? this.hasCoffeeShop,
      hasElevator: hasElevator ?? this.hasElevator,
      hasATM: hasATM ?? this.hasATM,
      hasGroceryStore: hasGroceryStore ?? this.hasGroceryStore,
      hasFastFood: hasFastFood ?? this.hasFastFood,
      hasBicycleParking: hasBicycleParking ?? this.hasBicycleParking,
      hasNearHolyshrine: hasNearHolyshrine ?? this.hasNearHolyshrine,
      hasCleanFood: hasCleanFood ?? this.hasCleanFood,
      hasBlindPass: hasBlindPass ?? this.hasBlindPass,
      hasCreditTicketSales: hasCreditTicketSales ?? this.hasCreditTicketSales,
      hasPrayerRoom: hasPrayerRoom ?? this.hasPrayerRoom,
    );
  }

  bool get hasAnyFilter =>
      hasWc != null ||
      hasCoffeeShop != null ||
      hasElevator != null ||
      hasATM != null ||
      hasGroceryStore != null ||
      hasFastFood != null ||
      hasBicycleParking != null ||
      hasNearHolyshrine != null ||
      hasCleanFood != null ||
      hasBlindPass != null ||
      hasCreditTicketSales != null ||
      hasPrayerRoom != null;
}

final facilityFilterProvider = StateProvider<FacilityFilter>((ref) {
  return FacilityFilter();
});

final stationsWithFacilitiesProvider = FutureProvider<List<StationModel>>((
  ref,
) async {
  final service = ref.watch(stationServiceProvider);
  final filter = ref.watch(facilityFilterProvider);

  if (!filter.hasAnyFilter) {
    return service.loadStations();
  }

  return service.getStationsWithFacility(
    filter.hasWc,
    filter.hasCoffeeShop,
    filter.hasElevator,
    filter.hasATM,
    filter.hasGroceryStore,
    filter.hasFastFood,
    filter.hasBicycleParking,
    filter.hasNearHolyshrine,
    filter.hasCleanFood,
    filter.hasBlindPass,
    filter.hasCreditTicketSales,
    filter.hasPrayerRoom,
  );
});

final stationsCountProvider = FutureProvider<int>((ref) async {
  final service = ref.watch(stationServiceProvider);
  return service.getStationsCount();
});

final allLinesProvider = FutureProvider<List<int>>((ref) async {
  final service = ref.watch(stationServiceProvider);
  return service.getAllLines();
});

final firstAndLastStationProvider =
    FutureProvider.family<Map<String, StationModel?>, int>((
      ref,
      lineNumber,
    ) async {
      final service = ref.watch(stationServiceProvider);
      return service.getFirstAndLastStation(lineNumber);
    });
