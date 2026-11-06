class GeoPointModel {
  final double latitude;
  final double longitude;

  const GeoPointModel({required this.latitude, required this.longitude});

  factory GeoPointModel.fromJson(Map<String, dynamic> json) {
    return GeoPointModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}

class LocalityModel {
  final String localityId;
  final String name;
  final String marathiName;
  final String pincode;
  final GeoPointModel center;
  final double radiusKm;
  final String density;
  final bool emergencyHub;

  const LocalityModel({
    required this.localityId,
    required this.name,
    required this.marathiName,
    required this.pincode,
    required this.center,
    required this.radiusKm,
    required this.density,
    required this.emergencyHub,
  });

  factory LocalityModel.fromJson(Map<String, dynamic> json) {
    return LocalityModel(
      localityId: json['localityId'] as String,
      name: json['name'] as String,
      marathiName: json['marathiName'] as String,
      pincode: json['pincode'] as String,
      center: GeoPointModel.fromJson(json['center'] as Map<String, dynamic>),
      radiusKm: (json['radiusKm'] as num).toDouble(),
      density: json['density'] as String,
      emergencyHub: json['emergencyHub'] as bool? ?? false,
    );
  }
}

class CityConfigModel {
  final String cityId;
  final String name;
  final String fullName;
  final String state;
  final String country;
  final List<String> pincodeRange;
  final GeoPointModel centerCoordinates;
  final double defaultDispatchRadiusKm;
  final int emergencyDispatchWindowMins;
  final String currencySymbol;
  final List<LocalityModel> localities;

  const CityConfigModel({
    required this.cityId,
    required this.name,
    required this.fullName,
    required this.state,
    required this.country,
    required this.pincodeRange,
    required this.centerCoordinates,
    required this.defaultDispatchRadiusKm,
    required this.emergencyDispatchWindowMins,
    required this.currencySymbol,
    required this.localities,
  });

  factory CityConfigModel.fromJson(Map<String, dynamic> json) {
    return CityConfigModel(
      cityId: json['cityId'] as String,
      name: json['name'] as String,
      fullName: json['fullName'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      pincodeRange: (json['pincodeRange'] as List<dynamic>).map((e) => e.toString()).toList(),
      centerCoordinates: GeoPointModel.fromJson(json['centerCoordinates'] as Map<String, dynamic>),
      defaultDispatchRadiusKm: (json['defaultDispatchRadiusKm'] as num).toDouble(),
      emergencyDispatchWindowMins: json['emergencyDispatchWindowMins'] as int? ?? 25,
      currencySymbol: json['currencySymbol'] as String? ?? '₹',
      localities: (json['localities'] as List<dynamic>)
          .map((e) => LocalityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
