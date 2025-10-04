import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muslimapp/services/storage_service.dart';

final zoneProvider = StateNotifierProvider<ZoneNotifier, String>((ref) {
  return ZoneNotifier();
});

class ZoneNotifier extends StateNotifier<String> {
  final _storage = StorageService();

  ZoneNotifier() : super('WLY01') { // default zone
    _init();
  }

  Future<void> _init() async {
    final savedZone = await _storage.loadZone();
    if (savedZone != null) {
      state = savedZone;
    }
  }

  void setZone(String zoneCode) {
    state = zoneCode;
    _storage.saveZone(zoneCode);
  }
}

