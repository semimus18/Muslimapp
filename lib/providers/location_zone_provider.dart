import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muslimapp/models/zone_model.dart';
import 'package:muslimapp/providers/location_provider.dart';
import 'dart:math';

// 📍 Data classes for location information
class WeatherLocation {
  final double latitude;
  final double longitude;
  final double accuracy;
  final DateTime timestamp;

  const WeatherLocation({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.timestamp,
  });
}

class ComprehensiveLocationInfo {
  final double latitude;
  final double longitude;
  final double accuracy;
  final String cityName;
  final EsolatZone prayerZone;
  final DateTime timestamp;

  const ComprehensiveLocationInfo({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.cityName,
    required this.prayerZone,
    required this.timestamp,
  });
}

// 🎯 LOCATION-BASED PRAYER ZONE PROVIDER
// Automatically selects the best eSolat zone based on user's location
final locationBasedZoneProvider = StreamProvider<EsolatZone>((ref) async* {
  await for (final position in ref.watch(locationStreamProvider.stream)) {
    try {
      print('🕌 Finding prayer zone for: ${position.latitude}, ${position.longitude}');
      
      // Find the nearest eSolat zone based on coordinates
      final nearestZone = _findNearestZone(position.latitude, position.longitude);
      
      print('✅ Auto-selected prayer zone: ${nearestZone.code} - ${nearestZone.description}');
      yield nearestZone;
    } catch (e) {
      print('❌ Error finding prayer zone: $e');
      // Fallback to default Kuala Lumpur zone
      yield esolatZones.firstWhere((zone) => zone.code == 'SGR01');
    }
  }
});

// 🎯 SMART ZONE PROVIDER WITH CITY MAPPING
// Combines coordinate-based and city-name based zone selection
final smartZoneProvider = StreamProvider<EsolatZone>((ref) async* {
  await for (final position in ref.watch(locationStreamProvider.stream)) {
    try {
      print('🧠 Smart zone selection for: ${position.latitude}, ${position.longitude}');
      
      // First, get coordinate-based zone
      final coordinateZone = _findNearestZone(position.latitude, position.longitude);
      
      // Try to get city name and enhance the selection
      try {
        final cityNameAsync = await ref.read(daerahStreamProvider.future);
        final enhancedZone = _mapCityToZone(cityNameAsync, position.latitude, position.longitude);
        
        print('✅ Smart zone selection: ${enhancedZone.code} - ${enhancedZone.description}');
        print('   City: $cityNameAsync | Coordinates: ${position.latitude}, ${position.longitude}');
        yield enhancedZone;
      } catch (e) {
        print('⚠️ City name not available, using coordinate-based zone: ${coordinateZone.code}');
        yield coordinateZone;
      }
    } catch (e) {
      print('❌ Error in smart zone selection: $e');
      // Ultimate fallback to KL zone
      yield esolatZones.firstWhere((zone) => zone.code == 'SGR01');
    }
  }
});

// 🌦️ WEATHER COORDINATES PROVIDER
// Provides exact coordinates for weather API calls with updates
final weatherCoordinatesProvider = StreamProvider<WeatherLocation>((ref) async* {
  await for (final position in ref.watch(locationStreamProvider.stream)) {
    print('🌡️ Weather coordinates updated: ${position.latitude}, ${position.longitude}');
    
    yield WeatherLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      timestamp: DateTime.now(),
    );
  }
});

// 📍 COMPREHENSIVE LOCATION INFO PROVIDER
// Provides all location-related information in one place
final comprehensiveLocationProvider = FutureProvider<ComprehensiveLocationInfo>((ref) async {
  try {
    // Get the latest position
    final position = await ref.watch(locationStreamProvider.future);
    
    // Get city name
    String cityName = 'Mencari lokasi...';
    try {
      cityName = await ref.watch(daerahStreamProvider.future);
    } catch (e) {
      print('⚠️ Could not get city name: $e');
    }
    
    // Get prayer zone
    EsolatZone prayerZone;
    try {
      prayerZone = await ref.watch(smartZoneProvider.future);
    } catch (e) {
      print('⚠️ Could not get prayer zone: $e');
      prayerZone = _findNearestZone(position.latitude, position.longitude);
    }
    
    return ComprehensiveLocationInfo(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      cityName: cityName,
      prayerZone: prayerZone,
      timestamp: DateTime.now(),
    );
  } catch (e) {
    print('❌ Error in comprehensive location provider: $e');
    throw Exception('Could not get complete location information: $e');
  }
});

//  HELPER FUNCTIONS

/// Find the nearest eSolat zone based on GPS coordinates
EsolatZone _findNearestZone(double userLat, double userLng) {
  EsolatZone? nearest;
  double minDistance = double.infinity;

  for (final zone in esolatZones) {
    // Calculate distance using more accurate Haversine-like formula
    final distance = _calculateDistance(userLat, userLng, zone.latitude, zone.longitude);
    
    if (distance < minDistance) {
      minDistance = distance;
      nearest = zone;
    }
  }
  
  print('📐 Nearest zone distance: ${minDistance.toStringAsFixed(2)} km to ${nearest!.code}');
  return nearest;
}

/// Calculate distance between two coordinates (in kilometers)
double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371; // Earth's radius in km
  
  final double dLat = _degreesToRadians(lat2 - lat1);
  final double dLon = _degreesToRadians(lon2 - lon1);
  
  final double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) *
      sin(dLon / 2) * sin(dLon / 2);
  
  final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return earthRadius * c;
}

double _degreesToRadians(double degrees) {
  return degrees * (pi / 180);
}

/// Enhanced city-to-zone mapping with intelligent fallbacks
EsolatZone _mapCityToZone(String cityName, double lat, double lon) {
  final city = cityName.toLowerCase().trim();
  
  // Exact city name matches
  final Map<String, String> cityToZoneMap = {
    // Kuala Lumpur & Selangor
    'kuala lumpur': 'SGR01',
    'petaling jaya': 'SGR01', 
    'shah alam': 'SGR01',
    'subang jaya': 'SGR01',
    'klang': 'SGR03',
    'kajang': 'SGR01',
    'ampang': 'SGR01',
    'cheras': 'SGR01',
    'puchong': 'SGR01',
    'bangi': 'SGR01',
    'serdang': 'SGR01',
    'cyberjaya': 'SGR01',
    'putrajaya': 'SGR01',
    'lembah klang': 'SGR01',
    
    // Johor
    'johor bahru': 'JHR02',
    'johor': 'JHR02',
    'skudai': 'JHR02',
    'iskandar puteri': 'JHR02',
    'kluang': 'JHR03',
    'pontian': 'JHR03',
    'batu pahat': 'JHR04',
    'muar': 'JHR04',
    'segamat': 'JHR04',
    
    // Penang
    'george town': 'PNG01',
    'penang': 'PNG01',
    'pulau pinang': 'PNG01',
    'georgetown': 'PNG01',
    'butterworth': 'PNG01',
    
    // Perak
    'ipoh': 'PRK02',
    'taiping': 'PRK06',
    'teluk intan': 'PRK05',
    'kuala kangsar': 'PRK02',
    'tanjung malim': 'PRK01',
    
    // Other states
    'melaka': 'MLK01',
    'malacca': 'MLK01',
    'kuantan': 'PHG02',
    'kota bharu': 'KTN01',
    'kuala terengganu': 'TRG01',
    'kuching': 'SWK08',
    'kota kinabalu': 'SBH07',
    'miri': 'SWK02',
    'sibu': 'SWK04',
  };
  
  // Direct city match
  if (cityToZoneMap.containsKey(city)) {
    final zoneCode = cityToZoneMap[city]!;
    final zone = esolatZones.firstWhere((z) => z.code == zoneCode);
    print('🎯 Direct city match: $cityName → ${zone.code}');
    return zone;
  }
  
  // Partial city name matching
  for (String cityKey in cityToZoneMap.keys) {
    if (city.contains(cityKey) || cityKey.contains(city)) {
      final zoneCode = cityToZoneMap[cityKey]!;
      final zone = esolatZones.firstWhere((z) => z.code == zoneCode);
      print('🔍 Partial city match: $cityName → ${zone.code} (via $cityKey)');
      return zone;
    }
  }
  
  // State-level fallbacks
  final stateToZoneMap = {
    'selangor': 'SGR01',
    'johor': 'JHR02', 
    'perak': 'PRK02',
    'pulau pinang': 'PNG01',
    'penang': 'PNG01',
    'melaka': 'MLK01',
    'negeri sembilan': 'NGS02',
    'pahang': 'PHG02',
    'terengganu': 'TRG01',
    'kelantan': 'KTN01',
    'kedah': 'KDH01',
    'perlis': 'PLS01',
    'sabah': 'SBH07',
    'sarawak': 'SWK08',
  };
  
  for (String state in stateToZoneMap.keys) {
    if (city.contains(state)) {
      final zoneCode = stateToZoneMap[state]!;
      final zone = esolatZones.firstWhere((z) => z.code == zoneCode);
      print('🗺️ State-level match: $cityName → ${zone.code} (state: $state)');
      return zone;
    }
  }
  
  // Ultimate fallback: coordinate-based nearest zone
  print('📍 No city/state match found, using coordinate-based selection');
  return _findNearestZone(lat, lon);
}