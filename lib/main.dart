import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hijri/hijri.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MuslimApp());
}

class MuslimApp extends StatelessWidget {
  const MuslimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muslim App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF2E7D32),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Amiri',
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Position? _currentPosition;
  Map<String, String> _prayerTimes = {};
  String _hijriDate = '';
  double _qiblaDirection = 0.0;
  bool _isLoading = true;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _requestPermissions();
    await _getCurrentLocation();
    await _calculateHijriDate();
    await _getPrayerTimes();
    await _calculateQiblaDirection();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _requestPermissions() async {
    await Permission.location.request();
  }

  Future<void> _getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      // Use default location (Mecca) if location services fail
      _currentPosition = Position(
        latitude: 21.4225,
        longitude: 39.8262,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
    }
  }

  void _calculateHijriDate() {
    final hijri = HijriCalendar.now();
    _hijriDate = '${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear}';
  }

  Future<void> _getPrayerTimes() async {
    if (_currentPosition == null) return;
    
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.aladhan.com/v1/timings?latitude=${_currentPosition!.latitude}&longitude=${_currentPosition!.longitude}&method=2',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timings = data['data']['timings'];
        
        setState(() {
          _prayerTimes = {
            'Fajr': timings['Fajr'],
            'Dhuhr': timings['Dhuhr'],
            'Asr': timings['Asr'],
            'Maghrib': timings['Maghrib'],
            'Isha': timings['Isha'],
          };
        });
      }
    } catch (e) {
      // Fallback prayer times
      _prayerTimes = {
        'Fajr': '05:30',
        'Dhuhr': '12:30',
        'Asr': '15:45',
        'Maghrib': '18:15',
        'Isha': '19:45',
      };
    }
  }

  void _calculateQiblaDirection() {
    if (_currentPosition == null) return;

    // Mecca coordinates
    const double meccaLat = 21.4225;
    const double meccaLng = 39.8262;

    final double lat1 = _currentPosition!.latitude * (math.pi / 180);
    final double lat2 = meccaLat * (math.pi / 180);
    final double deltaLng = (meccaLng - _currentPosition!.longitude) * (math.pi / 180);

    final double y = math.sin(deltaLng) * math.cos(lat2);
    final double x = math.cos(lat1) * math.sin(lat2) - 
                     math.sin(lat1) * math.cos(lat2) * math.cos(deltaLng);

    _qiblaDirection = math.atan2(y, x) * (180 / math.pi);
    if (_qiblaDirection < 0) {
      _qiblaDirection += 360;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                'Initializing Muslim App...',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Muslim App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomePage(),
          _buildPrayerTimesPage(),
          _buildQiblaPage(),
          _buildDhikrPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Prayer Times',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Qibla',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Dhikr',
          ),
        ],
      ),
    );
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Islamic Greeting Card
          Card(
            elevation: 4,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'السلام عليكم ورحمة الله وبركاته',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Assalamu Alaikum wa Rahmatullahi wa Barakatuh',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Today: $_hijriDate AH',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Quick Actions
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  'Next Prayer',
                  _getNextPrayer(),
                  Icons.access_time,
                  () => setState(() => _selectedIndex = 1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  'Qibla Direction',
                  '${_qiblaDirection.toStringAsFixed(0)}°',
                  Icons.explore,
                  () => setState(() => _selectedIndex = 2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Daily Verse
          Text(
            'Daily Verse',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '"And whoever fears Allah - He will make for him a way out"',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Quran 65:2',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getNextPrayer() {
    if (_prayerTimes.isEmpty) return 'Loading...';
    
    final now = TimeOfDay.now();
    final currentMinutes = now.hour * 60 + now.minute;

    for (final entry in _prayerTimes.entries) {
      final time = entry.value.split(':');
      final prayerMinutes = int.parse(time[0]) * 60 + int.parse(time[1]);
      
      if (prayerMinutes > currentMinutes) {
        return '${entry.key} - ${entry.value}';
      }
    }
    
    // If no prayer left today, show first prayer of tomorrow
    return 'Fajr - ${_prayerTimes['Fajr']}';
  }

  Widget _buildPrayerTimesPage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Prayer Times',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Based on your location',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _prayerTimes.length,
              itemBuilder: (context, index) {
                final entry = _prayerTimes.entries.elementAt(index);
                return _buildPrayerTimeCard(entry.key, entry.value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimeCard(String prayerName, String time) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.access_time,
            color: Colors.white,
          ),
        ),
        title: Text(
          prayerName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        trailing: Text(
          time,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildQiblaPage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Qibla Direction',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Direction to Mecca (Kaaba)',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 4,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            Icons.explore,
                            size: 100,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 0,
                          right: 0,
                          child: Transform.rotate(
                            angle: _qiblaDirection * (math.pi / 180),
                            child: Icon(
                              Icons.navigation,
                              size: 40,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    '${_qiblaDirection.toStringAsFixed(1)}°',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Point your device in this direction',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDhikrPage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dhikr & Prayers',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildDhikrCard(
                  'Istighfar',
                  'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ',
                  'Astaghfirullaha al-azeem',
                  'I seek forgiveness from Allah, the Great',
                ),
                _buildDhikrCard(
                  'Tasbih',
                  'سُبْحَانَ اللَّهِ',
                  'Subhanallah',
                  'Glory be to Allah',
                ),
                _buildDhikrCard(
                  'Tahmid',
                  'الْحَمْدُ لِلَّهِ',
                  'Alhamdulillah',
                  'All praise is due to Allah',
                ),
                _buildDhikrCard(
                  'Takbir',
                  'اللَّهُ أَكْبَرُ',
                  'Allahu Akbar',
                  'Allah is the Greatest',
                ),
                _buildDhikrCard(
                  'Tawhid',
                  'لَا إِلَهَ إِلَّا اللَّهُ',
                  'La ilaha illa Allah',
                  'There is no god but Allah',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDhikrCard(
    String title,
    String arabic,
    String transliteration,
    String translation,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              arabic,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.8,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              transliteration,
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              translation,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}