class StationModel {
  final String name;
  final Map<String, String> translations;
  final List<int> lines;
  final String longitude;
  final String latitude;
  final String address;
  final List<String> colors;
  final bool disabled;
  final bool wc;
  final bool coffeeShop;
  final bool groceryStore;
  final bool fastFood;
  final bool atm;
  final bool elevator;
  final bool bicycleParking;
  final bool nearHolyshrine;
  final bool cleanFood;
  final bool blindPath;
  final bool fireSuppressionSystem;
  final bool fireExtinguisher;
  final bool metroPolice;
  final bool creditTicketSales;
  final bool waitingChair;
  final bool camera;
  final bool trashCan;
  final bool smoking;
  final bool petsAllowed;
  final bool freeWifi;
  final bool prayerRoom;
  final List<String> relations;
  final List<Map<String, int>> positionInLine;

  StationModel({
    required this.name,
    required this.translations,
    required this.lines,
    required this.longitude,
    required this.latitude,
    required this.address,
    required this.colors,
    required this.disabled,
    required this.wc,
    required this.coffeeShop,
    required this.groceryStore,
    required this.fastFood,
    required this.atm,
    required this.elevator,
    required this.bicycleParking,
    required this.nearHolyshrine,
    required this.cleanFood,
    required this.blindPath,
    required this.fireSuppressionSystem,
    required this.fireExtinguisher,
    required this.metroPolice,
    required this.creditTicketSales,
    required this.waitingChair,
    required this.camera,
    required this.trashCan,
    required this.smoking,
    required this.petsAllowed,
    required this.freeWifi,
    required this.prayerRoom,
    required this.relations,
    required this.positionInLine,
  });

  factory StationModel.fromJson(String key, Map<String, dynamic> json) {
    return StationModel(
      name: json['name'] as String? ?? key,
      translations: Map<String, String>.from(json['translations'] as Map),
      lines: List<int>.from(json['lines'] as List),
      longitude: json['longitude'] as String,
      latitude: json['latitude'] as String,
      address: json['address'] as String,
      colors: List<String>.from(json['colors'] as List),
      disabled: json['disabled'] as bool,
      wc: json['wc'] as bool,
      coffeeShop: json['coffeeShop'] as bool,
      groceryStore: json['groceryStore'] as bool,
      fastFood: json['fastFood'] as bool,
      atm: json['atm'] as bool,
      elevator: json['elevator'] as bool,
      bicycleParking: json['bicycleParking'] as bool,
      nearHolyshrine: json['NearHolyshrine'] as bool,
      cleanFood: json['cleanFood'] as bool,
      blindPath: json['blindPath'] as bool,
      fireSuppressionSystem: json['fireSuppressionSystem'] as bool,
      fireExtinguisher: json['fireExtinguisher'] as bool,
      metroPolice: json['metroPolice'] as bool,
      creditTicketSales: json['creditTicketSales'] as bool,
      waitingChair: json['waitingChair'] as bool,
      camera: json['camera'] as bool,
      trashCan: json['trashCan'] as bool,
      smoking: json['smoking'] as bool,
      petsAllowed: json['petsAllowed'] as bool,
      freeWifi: json['freeWifi'] as bool,
      prayerRoom: json['prayerRoom'] as bool,
      relations: List<String>.from(json['relations'] as List),
      positionInLine: (json['positionInLine'] as List)
          .map((item) => Map<String, int>.from(item as Map))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'StationModel(name: $name, fa: ${translations['fa']})';
  }

  int? getPositionInLine(int lineNumber) {
    try {
      final position = positionInLine.firstWhere(
        (item) => item['line'] == lineNumber,
      );
      return position['position'];
    } catch (e) {
      return null;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StationModel && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
