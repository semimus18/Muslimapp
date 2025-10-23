import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

// 🎯 REACTIVE LOCATION PROVIDER - Auto updates when location changes
final locationStreamProvider = StreamProvider<Position>((ref) async* {
  // Check location permissions first
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permissions are permanently denied.');
  }

  // Get initial position
  final initialPosition = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  yield initialPosition;
  print('🎯 Initial location: ${initialPosition.latitude}, ${initialPosition.longitude}');

  // Start location stream for continuous updates
  const LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10, // Update setiap 10 meter movement
  );

  yield* Geolocator.getPositionStream(locationSettings: locationSettings).map((position) {
    print('📍 Location updated: ${position.latitude}, ${position.longitude}');
    return position;
  });
});

// 🏢 REACTIVE CITY NAME PROVIDER - Auto updates when location changes  
final daerahStreamProvider = StreamProvider<String>((ref) async* {
  await for (final position in ref.watch(locationStreamProvider.stream)) {
    try {
      print('🔄 Updating city name for: ${position.latitude}, ${position.longitude}');
      
      // Solution 1: Coordinate-based detection (FREE & RELIABLE)
      final malaysianCity = _getMalaysianCityFromCoordinates(position.latitude, position.longitude);
      if (malaysianCity != null) {
        print('✅ City found via coordinate mapping: $malaysianCity');
        yield malaysianCity;
        continue;
      }
      
      // Solution 2: OpenStreetMap Nominatim (FREE API - No API Key Required)
      try {
        final osmCity = await _getLocationFromOSM(position.latitude, position.longitude);
        if (osmCity != null && osmCity.isNotEmpty) {
          print('✅ City found via OpenStreetMap: $osmCity');
          yield osmCity;
          continue;
        }
      } catch (e) {
        print('OpenStreetMap geocoding failed: $e');
      }
      
      // Solution 3: Flutter Geocoding (Backup)
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, 
          position.longitude
        );
        
        if (placemarks.isNotEmpty) {
          String? cityName = _extractCityName(placemarks.first);
          if (cityName != null) {
            print('✅ City found via Flutter geocoding: $cityName');
            yield cityName;
            continue;
          }
        }
      } catch (e) {
        print('Flutter geocoding failed: $e');
      }
      
      // Fallback if all methods fail
      yield 'Lokasi tidak diketahui';
    } catch (e) {
      print('❌ Error getting location name: $e');
      yield 'Ralat lokasi';
    }
  }
});

// 🎯 ONE-TIME LOCATION PROVIDER (for backward compatibility)
final locationProvider = FutureProvider<Position>((ref) async {
  
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permissions are permanently denied.');
  }

  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
});

// 🏢 ONE-TIME CITY NAME PROVIDER (for backward compatibility)
final daerahProvider = FutureProvider<String>((ref) async {
  try {
    final position = await ref.watch(locationProvider.future);
    print('Lokasi: ${position.latitude}, ${position.longitude}');
    
    // Solution 1: Coordinate-based detection (FREE & RELIABLE)
    final malaysianCity = _getMalaysianCityFromCoordinates(position.latitude, position.longitude);
    if (malaysianCity != null) {
      print('✅ City found via coordinate mapping: $malaysianCity');
      return malaysianCity;
    }
    
    // Solution 2: OpenStreetMap Nominatim (FREE API - No API Key Required)
    try {
      final osmCity = await _getLocationFromOSM(position.latitude, position.longitude);
      if (osmCity != null && osmCity.isNotEmpty) {
        print('✅ City found via OpenStreetMap: $osmCity');
        return osmCity;
      }
    } catch (e) {
      print('OpenStreetMap geocoding failed: $e');
    }
    
    // Solution 3: Try Flutter's geocoding (FREE but unreliable)
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      ).timeout(const Duration(seconds: 5));
      
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        print('Flutter Geocoding - Placemark: ${placemark.toString()}');
        
        String? cityName = _extractCityName(placemark);
        if (cityName != null && cityName.isNotEmpty) {
          print('✅ City found via Flutter Geocoding: $cityName');
          return cityName;
        }
      }
    } catch (e) {
      print('Flutter geocoding failed: $e');
    }
    
    return 'Lokasi tidak diketahui';
  } catch (e) {
    print('Error in daerahProvider: $e');
    return 'Lokasi tidak diketahui';
  }
});

// Helper function to extract city name from placemark
String? _extractCityName(Placemark placemark) {
  // Try different fields in order of preference for Malaysian locations
  List<String?> possibleNames = [
    placemark.locality,                    // Bandar/Bandaraya (City/Town)
    placemark.subAdministrativeArea,      // Daerah (District) 
    placemark.subLocality,               // Kawasan/Taman (Sub-area/Township)
    placemark.administrativeArea,         // Negeri (State) - fallback
  ];
  
  for (String? name in possibleNames) {
    if (name != null && name.isNotEmpty && name.toLowerCase() != 'unknown') {
      return name;
    }
  }
  return null;
}

// OpenStreetMap reverse geocoding (FREE - No API key needed!)
Future<String?> _getLocationFromOSM(double lat, double lon) async {
  try {
    final url = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&accept-language=en';
    final response = await http.get(
      Uri.parse(url),
      headers: {'User-Agent': 'MuslimApp/1.0'},
    ).timeout(const Duration(seconds: 10));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final address = data['address'];
      
      if (address != null) {
        // Malaysian location parsing priority:
        // 1. Bandar/Bandaraya (City/Town)
        String? city = address['city'] ?? address['town'];
        if (city != null && city.isNotEmpty) {
          return city;
        }
        
        // 2. Suburban areas/townships  
        String? suburb = address['suburb'] ?? address['village'];
        if (suburb != null && suburb.isNotEmpty) {
          return suburb;
        }
        
        // 3. Administrative areas (usually district level)
        String? admin = address['municipality'] ?? address['county'];
        if (admin != null && admin.isNotEmpty) {
          return admin;
        }
        
        // 4. State as final fallback
        String? state = address['state'];
        if (state != null && state.isNotEmpty) {
          return state;
        }
      }
    }
  } catch (e) {
    print('OSM API error: $e');
  }
  return null;
}

// Malaysian cities and districts based on coordinate ranges  
String? _getMalaysianCityFromCoordinates(double lat, double lon) {
  // Malaysian administrative areas with coordinate boundaries
  final Map<String, Map<String, dynamic>> locations = {
    // KUALA LUMPUR & SELANGOR
    'Kuala Lumpur': {
      'type': 'bandaraya', // Federal Territory City
      'minLat': 3.0, 'maxLat': 3.3, 'minLon': 101.5, 'maxLon': 101.8
    },
    'Petaling Jaya': {
      'type': 'bandar', // City in Petaling District
      'minLat': 3.05, 'maxLat': 3.15, 'minLon': 101.6, 'maxLon': 101.7
    },
    'Shah Alam': {
      'type': 'bandar', // City in Petaling District  
      'minLat': 3.0, 'maxLat': 3.1, 'minLon': 101.4, 'maxLon': 101.6
    },
    'Subang Jaya': {
      'type': 'bandar', // City in Petaling District
      'minLat': 3.0, 'maxLat': 3.1, 'minLon': 101.5, 'maxLon': 101.65
    },
    'Klang': {
      'type': 'bandar', // City in Klang District
      'minLat': 3.0, 'maxLat': 3.1, 'minLon': 101.3, 'maxLon': 101.5
    },
    
    // OTHER STATES
    'Johor Bahru': {
      'type': 'bandar',
      'minLat': 1.4, 'maxLat': 1.6, 'minLon': 103.6, 'maxLon': 103.9
    },
    'George Town': { // Penang
      'type': 'bandar',
      'minLat': 5.2, 'maxLat': 5.5, 'minLon': 100.2, 'maxLon': 100.5
    },
    'Ipoh': {
      'type': 'bandar',
      'minLat': 4.5, 'maxLat': 4.7, 'minLon': 101.0, 'maxLon': 101.2
    },
    'Kota Kinabalu': {
      'type': 'bandar',
      'minLat': 5.9, 'maxLat': 6.1, 'minLon': 116.0, 'maxLon': 116.2
    },
    'Kuching': {
      'type': 'bandar',
      'minLat': 1.5, 'maxLat': 1.6, 'minLon': 110.3, 'maxLon': 110.4
    },
    'Melaka': {
      'type': 'bandar',
      'minLat': 2.1, 'maxLat': 2.3, 'minLon': 102.2, 'maxLon': 102.3
    },
  };
  
  // Check for specific city/town
  for (String locationName in locations.keys) {
    final bounds = locations[locationName]!;
    if (lat >= bounds['minLat']! && lat <= bounds['maxLat']! &&
        lon >= bounds['minLon']! && lon <= bounds['maxLon']!) {
      return locationName;
    }
  }
  
  // If no specific city found, identify by region/daerah
  if (lat >= 3.0 && lat <= 3.5 && lon >= 101.3 && lon <= 101.9) {
    return 'Lembah Klang'; // Klang Valley region
  }
  
  // Broader state-level detection
  if (lat >= 1.0 && lat <= 2.0 && lon >= 103.0 && lon <= 104.5) {
    return 'Johor';
  }
  if (lat >= 5.0 && lat <= 6.0 && lon >= 100.0 && lon <= 101.0) {
    return 'Pulau Pinang';
  }
  if (lat >= 4.0 && lat <= 5.0 && lon >= 100.5 && lon <= 102.0) {
    return 'Perak';
  }
  
  return null;
}