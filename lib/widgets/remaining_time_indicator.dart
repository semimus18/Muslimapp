import 'dart:async';
import 'package:flutter/material.dart';

class RemainingTimeIndicator extends StatefulWidget {
  final TimeOfDay prayerTime;
  final List<Color> colors;
  
  const RemainingTimeIndicator({
    Key? key,
    required this.prayerTime,
    required this.colors,
  }) : super(key: key);

  @override
  State<RemainingTimeIndicator> createState() => _RemainingTimeIndicatorState();
}

class _RemainingTimeIndicatorState extends State<RemainingTimeIndicator> {
  late Timer _timer;
  late Duration _remainingTime;
  
  @override
  void initState() {
    super.initState();
    _calculateRemainingTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateRemainingTime();
    });
  }
  
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  
  void _calculateRemainingTime() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Waktu solat hari ini
    final prayerDateTime = DateTime(
      today.year,
      today.month,
      today.day,
      widget.prayerTime.hour,
      widget.prayerTime.minute,
    );
    
    // Jika waktu solat sudah lewat, gunakan waktu solat untuk besok
    final targetTime = prayerDateTime.isBefore(now)
        ? prayerDateTime.add(const Duration(days: 1))
        : prayerDateTime;
    
    setState(() {
      _remainingTime = targetTime.difference(now);
    });
  }
  
  String get formattedRemainingTime {
    final hours = _remainingTime.inHours;
    final minutes = _remainingTime.inMinutes.remainder(60);
    final seconds = _remainingTime.inSeconds.remainder(60);
    
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  double get progressValue {
    // Asumsi maksimum adalah 24 jam
    final maxHours = 24.0;
    final totalHoursRemaining = _remainingTime.inSeconds / 3600;
    
    // Progress inversi (semakin sedikit waktu tersisa, semakin besar nilai)
    return 1 - (totalHoursRemaining / maxHours);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Masa tersisa',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          formattedRemainingTime,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(widget.colors[0]),
            ),
          ),
        ),
      ],
    );
  }
}