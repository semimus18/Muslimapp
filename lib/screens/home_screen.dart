import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:muslimapp/models/features_model.dart';
import 'package:muslimapp/models/prayer_model.dart'; // Import pakej ikon
import 'package:muslimapp/models/zone_model.dart';
import 'package:muslimapp/providers/time_provider.dart';
import 'package:muslimapp/providers/prayer_provider.dart';


class HomeScreen extends StatelessWidget {

  final Color textColor;
  final Prayer nextPrayer;
  final List<Prayer> dailyPrayers; // BARU
  final String location; // BARU
  final List<EsolatZone> allZones;
  final String selectedZoneCode;
  final ValueChanged<String?> onZoneChanged;
  

  const HomeScreen({
    super.key,
    required this.textColor,
    required this.nextPrayer,
    required this.dailyPrayers,
    required this.location,
    required this.allZones,
    required this.selectedZoneCode,
    required this.onZoneChanged,
  });

@override
Widget build(BuildContext context) {
  final selectedZone = allZones.firstWhere(
    (zone) => zone.code == selectedZoneCode,
    orElse: () => EsolatZone(code: '?', state: '', description: ''),
  );

  final zonDesc = selectedZone.description;
  return SafeArea(
  child: LayoutBuilder(
    builder: (context, constraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight, // Guna ketinggian MAKSIMUM YANG DIBENARKAN
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildNextPrayerCard(zonDesc),
                const SizedBox(height: 32),
                _buildDailyPrayerList(),
                const SizedBox(height: 32),
                const Text(
                  'Features',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 10),
                _buildFeaturesList(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      );
    }
    ),
  );
}

 
  Widget _buildHeader(){
    return Consumer(
      builder: (context, ref, child) {
        final currentTimeAsync = ref.watch(currentTimeProvider);
        
        // 3. Dapatkan nilai DateTime, guna waktu semasa sebagai sandaran
        final currentTime = currentTimeAsync.valueOrNull ?? DateTime.now();

        // 4. Format masa untuk paparan (HH:MM:SS)
        final formattedTime = DateFormat('HH:mm:ss').format(currentTime);

        return Column(
      children: [
        const Text(
          'IslamVerse ✨',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3A8A),
          ),
        ),
            const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.sparkle,size: 14, color: textColor.withOpacity(0.8)),
            const SizedBox(width: 8,),
            Text(
              ref.watch(hijriDateProvider),
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(width: 8,),
            Icon(LucideIcons.sparkle,size: 14, color: Color(0xFF1E3A8A).withOpacity(0.8))
            
          ],
        ),
        const SizedBox(height: 2),
            // PAPARKAN JAM DIGITAL DI SINI
            Text(
              formattedTime,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E3A8A),
              ),
            ),
      ],
    );
      }
    );
    
  }

  Widget _buildNextPrayerCard(final zonDesc){
    // ... di dalam _buildNextPrayerCard()
final formattedTime =
    '${NumberFormat("00").format(nextPrayer.time.hour)}:${NumberFormat("00").format(nextPrayer.time.minute)}';
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: nextPrayer.colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10)
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            'Solat Seterusnya',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
          SizedBox(height: 8,),
          Text(
            nextPrayer.name,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
          SizedBox(height: 8,),
          Text(
            formattedTime,
            style: TextStyle(
              fontSize: 24,
              color: Colors.white70
            )
          ),
          SizedBox(height: 16,),
          Text(
            zonDesc,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDailyPrayerList(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: dailyPrayers.map((prayer){
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _buildPrayerItem(prayer)
          )
          
        );
         
      }).toList(),
    );
  }

  Widget _buildPrayerItem(Prayer prayer){
    final formatedTime = '${prayer.time.hour.toString().padLeft(2,'0')}:${prayer.time.minute.toString().padLeft(2,'0')}';
    final bool isNextPrayer = prayer.name ==nextPrayer.name;
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10)
          )
        ],
      ),
      child: Column(
          children: [
            const SizedBox(height: 8,),
            Text(
              prayer.icon,
              style: const TextStyle(
                fontSize: 24
              ),
            ),
            const SizedBox(height: 8,),
            Text(
              prayer.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isNextPrayer ? const Color(0xFF1E3A8A) : textColor,
              ),
            ),
            const SizedBox(height: 8,),
            Text(
              formatedTime,
              style: TextStyle(
                fontSize: 12,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8,),
          ],
        )
    );
    
  }

  Widget _buildFeaturesList(){
    final features = [
      const Feature(icon: Icons.menu_book, label: "Doa"),
      const Feature(icon: Icons.book, label: "Al-Quran"),
      const Feature(icon: Icons.explore, label: "Kiblat"),
      const Feature(icon: Icons.access_time, label: "Haji"),
      const Feature(icon: Icons.menu_book, label: "Tasbih"),
      const Feature(icon: Icons.book, label: "Halal Finder"),
      const Feature(icon: Icons.explore, label: "Meditation"),
      const Feature(icon: Icons.access_time, label: "Mathurat"),
    ];
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10)
          )
        ],
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        mainAxisSpacing: 18,
        crossAxisSpacing: 18,
        children: features.map((feature) {
          return _buildFeatureIcon(feature.icon, feature.label);
        }).toList(),
      ),
    );
  }

  Widget _buildFeatureIcon (IconData icon, String label){
     return Column(
    mainAxisSize: MainAxisSize.min,
    children: [

      Icon(icon,size: 28),
      
      const SizedBox(height: 8),
      Flexible(
        child: Text(
          label,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
)
    ],
  );
  }
}