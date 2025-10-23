import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muslimapp/providers/location_provider.dart';

/// 🎯 REACTIVE LOCATION DEMO WIDGET
/// Shows how location updates automatically refresh UI
class LocationTestWidget extends ConsumerWidget {
  const LocationTestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationStreamAsync = ref.watch(locationStreamProvider);
    final daerahStreamAsync = ref.watch(daerahStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎯 Reactive Location Test'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📍 LOCATION COORDINATES STREAM
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.gps_fixed, color: Colors.green.shade600),
                        const SizedBox(width: 8),
                        const Text(
                          'Live GPS Coordinates',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    locationStreamAsync.when(
                      data: (position) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('📍 Latitude: ${position.latitude.toStringAsFixed(6)}'),
                          Text('📍 Longitude: ${position.longitude.toStringAsFixed(6)}'),
                          Text('🎯 Accuracy: ±${position.accuracy.toStringAsFixed(1)}m'),
                          Text('⏰ Updated: ${DateTime.now().toString().substring(11, 19)}'),
                        ],
                      ),
                      loading: () => const Row(
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 8),
                          Text('Mendapatkan lokasi GPS...'),
                        ],
                      ),
                      error: (error, stackTrace) => Text(
                        '❌ Error: $error',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 🏢 CITY NAME STREAM
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_city, color: Colors.blue.shade600),
                        const SizedBox(width: 8),
                        const Text(
                          'Live City Detection',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    daerahStreamAsync.when(
                      data: (cityName) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🏢 $cityName',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text('🔄 Auto-updates when you move!'),
                          Text('⏰ Updated: ${DateTime.now().toString().substring(11, 19)}'),
                        ],
                      ),
                      loading: () => const Row(
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 8),
                          Text('Mengesan nama bandar...'),
                        ],
                      ),
                      error: (error, stackTrace) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '❌ Error: $error',
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Location detection failed. Please ensure location services are enabled.',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 📋 INSTRUCTIONS
            Card(
              color: Colors.yellow.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.orange.shade600),
                        const SizedBox(width: 8),
                        const Text(
                          'How To Test',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('1. 🎯 Watch coordinates update automatically'),
                    const Text('2. 🚗 Move 10+ meters to trigger location update'),
                    const Text('3. 🏢 City name will auto-refresh'),
                    const Text('4. ⚡ Fully automatic - no manual intervention needed'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}