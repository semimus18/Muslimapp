import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String zoneKey = 'selected_zone';

  // Simpan zon
  Future<void> saveZone(String zoneCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(zoneKey, zoneCode);
  }

  // Ambil zon
  Future<String?> loadZone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(zoneKey);
  }
}