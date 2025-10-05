import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:muslimapp/models/prayer_model.dart';
import 'package:muslimapp/widgets/glassmorphic_container.dart';
import 'package:muslimapp/widgets/remaining_time_indicator.dart';

class PrayerInfoScreen extends StatelessWidget {
  final Prayer prayer;

  const PrayerInfoScreen({
    Key? key, 
    required this.prayer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format prayer time to display
    final String formattedTime = '${prayer.time.hour.toString().padLeft(2, '0')}:${prayer.time.minute.toString().padLeft(2, '0')}';
    
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: prayer.colors,
              ),
            ),
          ),
          
          // Blurred background elements
          _buildBackgroundBlurs(),
          
          // Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => context.go('/'), // Menggunakan context.go('/') untuk kembali ke halaman utama
                  ),
                ),
                
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          
                          // Prayer icon and time
                          Row(
                            children: [
                              Text(
                                prayer.icon,
                                style: const TextStyle(fontSize: 48),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedTime,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    prayer.name,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Prayer details card
                          GlassmorphicContainer(
                            borderRadius: 24,
                            blur: 15,
                            tintColor: Colors.white,
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Prayer title in local language
                                Text(
                                  prayer.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                
                                // Translation
                                Text(
                                  prayer.translation,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                
                                // Remaining time indicator
                                RemainingTimeIndicator(
                                  prayerTime: prayer.time,
                                  colors: prayer.colors,
                                ),
                                const SizedBox(height: 24),
                                
                                // Description
                                const Text(
                                  'Keterangan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  prayer.description,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Prayer significance card
                          GlassmorphicContainer(
                            borderRadius: 24,
                            blur: 15,
                            tintColor: Colors.white,
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Keutamaan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildSignificanceContent(prayer.name),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBackgroundBlurs() {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: prayer.colors[0].withOpacity(0.5),
              boxShadow: [
                BoxShadow(
                  color: prayer.colors[0].withOpacity(0.3),
                  blurRadius: 80,
                  spreadRadius: 30,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 150,
          left: -50,
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: prayer.colors[1].withOpacity(0.5),
              boxShadow: [
                BoxShadow(
                  color: prayer.colors[1].withOpacity(0.3),
                  blurRadius: 100,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSignificanceContent(String prayerName) {
    // Different text based on prayer name
    switch (prayerName) {
      case 'Fajr':
        return const Text(
          'Solat Subuh merupakan solat yang paling berat bagi orang munafik. Rasulullah SAW bersabda: "Tidak ada solat yang lebih berat bagi orang munafik daripada solat Fajr dan Isya, dan jika mereka tahu apa yang ada di dalamnya, mereka akan datang walaupun dengan merangkak."',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            height: 1.5,
          ),
        );
      case 'Dhuhr':
        return const Text(
          'Solat Zohor merupakan solat di pertengahan hari dan mengingatkan kita untuk berhenti sejenak daripada kesibukan dan mengingati Allah. Allah SWT berfirman: "Dan dirikanlah solat pada kedua-dua tepi siang (pagi dan petang) dan pada waktu permulaan malam."',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            height: 1.5,
          ),
        );
      case 'Asr':
        return const Text(
          'Solat Asar adalah salah satu solat yang disebut secara khusus dalam Al-Quran sebagai "Solat Wusta" (solat pertengahan). Allah SWT berfirman: "Peliharalah semua solat dan solat pertengahan (Asar), dan berdirilah kerana Allah dengan khusyuk."',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            height: 1.5,
          ),
        );
      case 'Maghrib':
        return const Text(
          'Solat Maghrib menandakan berakhirnya waktu siang dan bermulanya waktu malam. Ia adalah masa untuk berehat dan bersyukur atas nikmat yang diterima sepanjang hari. Nabi Muhammad SAW bersabda: "Janganlah kamu tergesa-gesa berbuka puasa sehinggalah kamu solat Maghrib."',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            height: 1.5,
          ),
        );
      case 'Isha':
        return const Text(
          'Solat Isyak dilakukan sebelum tidur dan ia memberi peluang untuk mengakhiri hari dengan mengingati Allah. Rasulullah SAW bersabda: "Jika manusia tahu keutamaan dalam solat Isyak dan Subuh, mereka akan hadir walaupun dengan merangkak."',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            height: 1.5,
          ),
        );
      default:
        return const Text(
          'Solat merupakan tiang agama dan amalan yang pertama dihisab di akhirat. Menjaga solat 5 waktu adalah kewajipan setiap Muslim.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            height: 1.5,
          ),
        );
    }
  }
}