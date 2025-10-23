class EsolatZone {
  final String code;
  final String state;
  final String description;
  final double latitude;
  final double longitude;

  EsolatZone({
    required this.code,
    required this.state,
    required this.description,
    required this.latitude,
    required this.longitude,
  });
}

EsolatZone findNearestZone(double userLat, double userLng, List<EsolatZone> zones) {
  EsolatZone? nearest;
  double minDistance = double.infinity;

  for (final zone in zones) {
    final distance = (zone.latitude - userLat) * (zone.latitude - userLat) +
        (zone.longitude - userLng) * (zone.longitude - userLng);
    if (distance < minDistance) {
      minDistance = distance;
      nearest = zone;
    }
  }
  return nearest!;
}

// Senarai lengkap zon solat di Malaysia (dengan koordinat utama)
final List<EsolatZone> esolatZones = [
  // Johor
  EsolatZone(code: 'JHR01', state: 'Johor', description: 'Pulau Aur dan Pulau Pemanggil', latitude: 2.4412, longitude: 104.5322),
  EsolatZone(code: 'JHR02', state: 'Johor', description: 'Johor Bahru, Kota Tinggi, Mersing', latitude: 1.4927, longitude: 103.7414),
  EsolatZone(code: 'JHR03', state: 'Johor', description: 'Kluang, Pontian', latitude: 2.0322, longitude: 103.3179),
  EsolatZone(code: 'JHR04', state: 'Johor', description: 'Batu Pahat, Muar, Segamat, Gemas Johor', latitude: 2.0500, longitude: 102.5667),
  // Kedah
  EsolatZone(code: 'KDH01', state: 'Kedah', description: 'Kota Setar, Kubang Pasu, Pokok Sena', latitude: 6.1210, longitude: 100.3678),
  EsolatZone(code: 'KDH02', state: 'Kedah', description: 'Kuala Muda, Yan, Pendang', latitude: 5.8000, longitude: 100.3833),
  EsolatZone(code: 'KDH03', state: 'Kedah', description: 'Padang Terap, Sik', latitude: 6.2500, longitude: 100.8000),
  EsolatZone(code: 'KDH04', state: 'Kedah', description: 'Baling', latitude: 5.6700, longitude: 100.9100),
  EsolatZone(code: 'KDH05', state: 'Kedah', description: 'Bandar Baharu, Kulim', latitude: 5.3650, longitude: 100.5610),
  EsolatZone(code: 'KDH06', state: 'Kedah', description: 'Langkawi', latitude: 6.3500, longitude: 99.8000),
  EsolatZone(code: 'KDH07', state: 'Kedah', description: 'Puncak Gunung Jerai', latitude: 5.7920, longitude: 100.4360),
  // Kelantan
  EsolatZone(code: 'KTN01', state: 'Kelantan', description: 'Bachok, Kota Bharu, Machang, Pasir Mas, dll.', latitude: 6.1254, longitude: 102.2381),
  EsolatZone(code: 'KTN03', state: 'Kelantan', description: 'Gua Musang, Jeli', latitude: 4.8846, longitude: 101.9631),
  // Melaka
  EsolatZone(code: 'MLK01', state: 'Melaka', description: 'Seluruh Negeri Melaka', latitude: 2.1896, longitude: 102.2501),
  // Negeri Sembilan
  EsolatZone(code: 'NGS01', state: 'Negeri Sembilan', description: 'Tampin, Jempol', latitude: 2.4700, longitude: 102.2300),
  EsolatZone(code: 'NGS02', state: 'Negeri Sembilan', description: 'Jelebu, Kuala Pilah, Port Dickson, dll.', latitude: 2.7300, longitude: 102.2400),
  // Pahang
  EsolatZone(code: 'PHG01', state: 'Pahang', description: 'Pulau Tioman', latitude: 2.8170, longitude: 104.1830),
  EsolatZone(code: 'PHG02', state: 'Pahang', description: 'Kuantan, Pekan, Rompin, Muadzam Shah', latitude: 3.8000, longitude: 103.3250),
  EsolatZone(code: 'PHG03', state: 'Pahang', description: 'Jerantut, Temerloh, Maran, Bera, dll.', latitude: 3.9000, longitude: 102.3667),
  EsolatZone(code: 'PHG04', state: 'Pahang', description: 'Bentong, Lipis, Raub', latitude: 4.1833, longitude: 101.8667),
  EsolatZone(code: 'PHG05', state: 'Pahang', description: 'Genting Sempah, Janda Baik, Bukit Tinggi', latitude: 3.4000, longitude: 101.8000),
  EsolatZone(code: 'PHG06', state: 'Pahang', description: 'Cameron Highlands, Genting Highlands, Fraser', latitude: 4.4700, longitude: 101.3700),
  // Perlis
  EsolatZone(code: 'PLS01', state: 'Perlis', description: 'Kangar, Padang Besar, Arau', latitude: 6.4447, longitude: 100.1986),
  // Pulau Pinang
  EsolatZone(code: 'PNG01', state: 'Pulau Pinang', description: 'Seluruh Negeri Pulau Pinang', latitude: 5.4164, longitude: 100.3327),
  // Perak
  EsolatZone(code: 'PRK01', state: 'Perak', description: 'Tapah, Slim River, Tanjung Malim', latitude: 3.8500, longitude: 101.3000),
  EsolatZone(code: 'PRK02', state: 'Perak', description: 'Kuala Kangsar, Sg. Siput, Ipoh, dll.', latitude: 4.7500, longitude: 100.9333),
  EsolatZone(code: 'PRK03', state: 'Perak', description: 'Lenggong, Pengkalan Hulu, Grik', latitude: 5.4000, longitude: 101.0000),
  EsolatZone(code: 'PRK04', state: 'Perak', description: 'Temengor, Belum', latitude: 5.6000, longitude: 101.3000),
  EsolatZone(code: 'PRK05', state: 'Perak', description: 'Kg Gajah, Teluk Intan, Bagan Datuk, dll.', latitude: 4.0000, longitude: 100.9833),
  EsolatZone(code: 'PRK06', state: 'Perak', description: 'Selama, Taiping, Bagan Serai, Parit Buntar', latitude: 5.0000, longitude: 100.7167),
  EsolatZone(code: 'PRK07', state: 'Perak', description: 'Bukit Larut', latitude: 4.8500, longitude: 100.8000),
  // Sabah
  EsolatZone(code: 'SBH01', state: 'Sabah', description: 'Bahagian Sandakan (Timur), dll.', latitude: 5.8400, longitude: 118.1170),
  EsolatZone(code: 'SBH02', state: 'Sabah', description: 'Beluran, Telupid, Pinangah, dll.', latitude: 6.3500, longitude: 117.4500),
  EsolatZone(code: 'SBH03', state: 'Sabah', description: 'Lahad Datu, Kunak, Semporna, dll.', latitude: 5.0200, longitude: 118.3300),
  EsolatZone(code: 'SBH04', state: 'Sabah', description: 'Bandar Tawau, Balong, Merotai, dll.', latitude: 4.2447, longitude: 117.8912),
  EsolatZone(code: 'SBH05', state: 'Sabah', description: 'Kudat, Kota Marudu, Pitas, Pulau Banggi', latitude: 6.8833, longitude: 116.8333),
  EsolatZone(code: 'SBH06', state: 'Sabah', description: 'Gunung Kinabalu', latitude: 6.0750, longitude: 116.5583),
  EsolatZone(code: 'SBH07', state: 'Sabah', description: 'Kota Kinabalu, Ranau, Kota Belud, dll.', latitude: 5.9804, longitude: 116.0735),
  EsolatZone(code: 'SBH08', state: 'Sabah', description: 'Pensiangan, Keningau, Tambunan, dll.', latitude: 5.3267, longitude: 116.1700),
  EsolatZone(code: 'SBH09', state: 'Sabah', description: 'Beaufort, Kuala Penyu, Sipitang, dll.', latitude: 5.3372, longitude: 115.7448),
  // Selangor
  EsolatZone(code: 'SGR01', state: 'Selangor', description: 'Gombak, Petaling, Sepang, Hulu Langat, dll.', latitude: 3.0738, longitude: 101.5183),
  EsolatZone(code: 'SGR02', state: 'Selangor', description: 'Kuala Selangor, Sabak Bernam', latitude: 3.3500, longitude: 101.2500),
  EsolatZone(code: 'SGR03', state: 'Selangor', description: 'Klang, Kuala Langat', latitude: 2.9996, longitude: 101.4344),
  // Sarawak
  EsolatZone(code: 'SWK01', state: 'Sarawak', description: 'Limbang, Lawas, Sundar, Trusan', latitude: 4.7500, longitude: 115.4000),
  EsolatZone(code: 'SWK02', state: 'Sarawak', description: 'Miri, Niah, Bekenu, Sibuti, Marudi', latitude: 4.3993, longitude: 113.9916),
  EsolatZone(code: 'SWK03', state: 'Sarawak', description: 'Pandan, Belaga, Suai, Tatau, Bintulu', latitude: 3.1667, longitude: 113.0333),
  EsolatZone(code: 'SWK04', state: 'Sarawak', description: 'Sibu, Mukah, Dalat, Song, Igan, dll.', latitude: 2.3000, longitude: 111.8167),
  EsolatZone(code: 'SWK05', state: 'Sarawak', description: 'Sarikei, Matu, Julau, Rajang, Daro, dll.', latitude: 2.1167, longitude: 111.5167),
  EsolatZone(code: 'SWK06', state: 'Sarawak', description: 'Lubok Antu, Sri Aman, Roban, Debak, dll.', latitude: 1.2400, longitude: 111.5600),
  EsolatZone(code: 'SWK07', state: 'Sarawak', description: 'Serian, Simunjan, Samarahan, Sebuyau', latitude: 1.2833, longitude: 110.5000),
  EsolatZone(code: 'SWK08', state: 'Sarawak', description: 'Kuching, Bau, Lundu, Sematan', latitude: 1.5533, longitude: 110.3592),
  EsolatZone(code: 'SWK09', state: 'Sarawak', description: 'Zon Khas (Kampung Patarikan)', latitude: 2.0000, longitude: 112.0000),
  // Terengganu
  EsolatZone(code: 'TRG01', state: 'Terengganu', description: 'Kuala Terengganu, Marang, Kuala Nerus', latitude: 5.3302, longitude: 103.1408),
  EsolatZone(code: 'TRG02', state: 'Terengganu', description: 'Besut, Setiu', latitude: 5.6500, longitude: 102.5500),
  EsolatZone(code: 'TRG03', state: 'Terengganu', description: 'Hulu Terengganu', latitude: 5.0833, longitude: 102.7833),
  EsolatZone(code: 'TRG04', state: 'Terengganu', description: 'Dungun, Kemaman', latitude: 4.7500, longitude: 103.4167),
  // Wilayah Persekutuan
  EsolatZone(code: 'WLY01', state: 'Wilayah Persekutuan', description: 'Kuala Lumpur, Putrajaya', latitude: 3.1390, longitude: 101.6869),
  EsolatZone(code: 'WLY02', state: 'Wilayah Persekutuan', description: 'Labuan', latitude: 5.2803, longitude: 115.2475),
];