// 🔋 PERFORMANCE-OPTIMIZED LOCATION SETTINGS

// Option 1: Adaptive accuracy based on app state
final adaptiveLocationProvider = StreamProvider<Position>((ref) async* {
  // Lower accuracy when app is in background
  final isAppActive = ref.watch(appLifecycleProvider);
  
  final LocationSettings settings = LocationSettings(
    accuracy: isAppActive ? LocationAccuracy.high : LocationAccuracy.medium,
    distanceFilter: isAppActive ? 10 : 50, // Larger filter when inactive
    timeLimit: const Duration(seconds: 30), // Timeout for battery saving
  );
  
  yield* Geolocator.getPositionStream(locationSettings: settings);
});

// Option 2: Prayer-time aware location (only active during prayer times)
final smartLocationProvider = StreamProvider<Position>((ref) async* {
  final nextPrayer = ref.watch(nextPrayerProvider);
  final timeToNextPrayer = nextPrayer.time.difference(DateTime.now());
  
  // More frequent updates near prayer times
  final bool isPrayerTime = timeToNextPrayer.inMinutes < 30;
  
  final LocationSettings settings = LocationSettings(
    accuracy: isPrayerTime ? LocationAccuracy.high : LocationAccuracy.medium,
    distanceFilter: isPrayerTime ? 5 : 25,
  );
  
  yield* Geolocator.getPositionStream(locationSettings: settings);
});

// Option 3: Battery-conscious mode
final ecoLocationProvider = StreamProvider<Position>((ref) async* {
  const LocationSettings ecoSettings = LocationSettings(
    accuracy: LocationAccuracy.medium, // Balanced accuracy
    distanceFilter: 25, // Update every 25 meters  
    timeLimit: Duration(minutes: 5), // Max 5 min GPS usage
  );
  
  yield* Geolocator.getPositionStream(locationSettings: ecoSettings);
});