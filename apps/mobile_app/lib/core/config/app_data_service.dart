import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/city_model.dart';
import '../models/trade_model.dart';
import '../models/artisan_profile_model.dart';

class AppDataService {
  static CityConfigModel? _cachedCity;
  static List<TradeModel>? _cachedTrades;

  static Future<CityConfigModel> loadPilotCity() async {
    if (_cachedCity != null) return _cachedCity!;
    try {
      final jsonStr = await rootBundle.loadString('assets/data/pilot_city_nanded.json');
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      _cachedCity = CityConfigModel.fromJson(data);
      return _cachedCity!;
    } catch (_) {
      // Fallback in-memory configuration for Nanded, Maharashtra
      _cachedCity = _defaultNandedConfig;
      return _cachedCity!;
    }
  }

  static Future<List<TradeModel>> loadTrades() async {
    if (_cachedTrades != null) return _cachedTrades!;
    try {
      final jsonStr = await rootBundle.loadString('assets/data/launch_trades.json');
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      final tradesList = data['trades'] as List<dynamic>;
      _cachedTrades = tradesList.map((e) => TradeModel.fromJson(e as Map<String, dynamic>)).toList();
      return _cachedTrades!;
    } catch (_) {
      _cachedTrades = _defaultTradesList;
      return _cachedTrades!;
    }
  }

  static List<ArtisanProfileModel> getSampleNandedArtisans() {
    return const [
      ArtisanProfileModel(
        artisanId: 'art_nanded_01',
        name: 'Ganesh Kadam',
        phone: '+919822012345',
        primaryTradeId: 'trade_electrician',
        tradeTitle: 'Master Electrician',
        yearsExperience: 9,
        rating: 4.9,
        reviewCount: 340,
        distanceKm: 1.2,
        bio: 'Specialist in 3-phase commercial wiring, inverter installation & recurring MCB trip diagnosis.',
        inspectionFee: 199,
        cityId: 'city_nanded_01',
        localityId: 'loc_anand_nagar',
        tier: GuildTier.masterGuildsman,
        totalJobsCompleted: 512,
      ),
      ArtisanProfileModel(
        artisanId: 'art_nanded_02',
        name: 'Sayyed Arshad',
        phone: '+919822054321',
        primaryTradeId: 'trade_plumber',
        tradeTitle: 'Certified Master Plumber',
        yearsExperience: 11,
        rating: 4.85,
        reviewCount: 290,
        distanceKm: 2.1,
        bio: 'Expert in CPVC/PVC concealed leak detection, water pressure boosting & bathroom drain augering.',
        inspectionFee: 199,
        cityId: 'city_nanded_01',
        localityId: 'loc_vazirabad',
        tier: GuildTier.masterGuildsman,
        totalJobsCompleted: 420,
      ),
      ArtisanProfileModel(
        artisanId: 'art_nanded_03',
        name: 'Prakash Sutar',
        phone: '+919822098765',
        primaryTradeId: 'trade_carpenter',
        tradeTitle: 'Senior Guild Carpenter',
        yearsExperience: 8,
        rating: 4.8,
        reviewCount: 215,
        distanceKm: 1.8,
        bio: 'Precision door lock fitting, hydraulic cabinet hinge alignment & custom wardrobe repair.',
        inspectionFee: 249,
        cityId: 'city_nanded_01',
        localityId: 'loc_cidco',
        tier: GuildTier.guildVerifiedPro,
        totalJobsCompleted: 190,
      ),
      ArtisanProfileModel(
        artisanId: 'art_nanded_04',
        name: 'Sachin Waghmare',
        phone: '+919822011223',
        primaryTradeId: 'trade_ac_refrig',
        tradeTitle: 'AC & Cooling Mechanic',
        yearsExperience: 7,
        rating: 4.9,
        reviewCount: 180,
        distanceKm: 2.4,
        bio: 'Foam jet split AC chemical wash, copper pipe brazing & R32 refrigerant vacuum gas charging.',
        inspectionFee: 249,
        cityId: 'city_nanded_01',
        localityId: 'loc_taroda_naka',
        tier: GuildTier.guildVerifiedPro,
        totalJobsCompleted: 165,
      ),
    ];
  }

  static final CityConfigModel _defaultNandedConfig = CityConfigModel(
    cityId: 'city_nanded_01',
    name: 'Nanded',
    fullName: 'Nanded-Waghala, Maharashtra',
    state: 'Maharashtra',
    country: 'India',
    pincodeRange: const ['431601', '431602', '431603', '431604', '431605', '431606'],
    centerCoordinates: const GeoPointModel(latitude: 19.1383, longitude: 77.3210),
    defaultDispatchRadiusKm: 4.5,
    emergencyDispatchWindowMins: 25,
    currencySymbol: '₹',
    localities: const [
      LocalityModel(
        localityId: 'loc_vazirabad',
        name: 'Vazirabad & Sarafa',
        marathiName: 'वजिराबाद आणि सराफा',
        pincode: '431601',
        center: GeoPointModel(latitude: 19.1555, longitude: 77.3190),
        radiusKm: 2.5,
        density: 'HIGH_COMMERCIAL_RESIDENTIAL',
        emergencyHub: true,
      ),
      LocalityModel(
        localityId: 'loc_anand_nagar',
        name: 'Anand Nagar',
        marathiName: 'आनंद नगर',
        pincode: '431602',
        center: GeoPointModel(latitude: 19.1685, longitude: 77.3090),
        radiusKm: 2.0,
        density: 'HIGH_RESIDENTIAL',
        emergencyHub: true,
      ),
      LocalityModel(
        localityId: 'loc_cidco',
        name: 'CIDCO New Nanded',
        marathiName: 'सिडको',
        pincode: '431603',
        center: GeoPointModel(latitude: 19.1310, longitude: 77.3380),
        radiusKm: 3.5,
        density: 'RESIDENTIAL_PLANNED',
        emergencyHub: true,
      ),
    ],
  );

  static final List<TradeModel> _defaultTradesList = [
    const TradeModel(
      tradeId: 'trade_electrician',
      slug: 'electrician',
      name: 'Electrician',
      marathiName: 'इलेक्ट्रिशियन',
      tagline: 'Short circuit, MCB, switchboard & heavy appliance wiring',
      accentColorHex: '#D97706',
      surfaceTintHex: '#FEF3C7',
      iconName: 'bolt',
      baseInspectionFee: 199,
      safetyShieldFee: 29,
      guaranteeDays: 30,
      emergencyEligible: true,
      popularPackages: [
        ServicePackageModel(
          packageId: 'pkg_elec_mcb',
          name: 'Short Circuit & MCB Tripping',
          estimatedPrice: 249,
          estimatedMinutes: 45,
          description: 'Continuous tripping, spark diagnosis & fuse repair',
        ),
      ],
    ),
    const TradeModel(
      tradeId: 'trade_plumber',
      slug: 'plumber',
      name: 'Plumber',
      marathiName: 'प्लंबर (नळ कारागीर)',
      tagline: 'Pipe leaks, tap replacement & drainage blockages',
      accentColorHex: '#0284C7',
      surfaceTintHex: '#E0F2FE',
      iconName: 'plumbing',
      baseInspectionFee: 199,
      safetyShieldFee: 29,
      guaranteeDays: 30,
      emergencyEligible: true,
      popularPackages: [],
    ),
  ];
}
