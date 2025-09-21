import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'zone_provider.g.dart';

@riverpod
class Zone extends _$Zone {
  @override
  String build() {
    // Nilai awal untuk kod zon
    return 'WLY01';
  }

  void setZone(String newZoneCode) {
    // Kemas kini nilai zon
    state = newZoneCode;
  }
}