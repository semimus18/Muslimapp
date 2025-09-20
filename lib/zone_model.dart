class EsolatZone {
  final String code;
  final String state;
  final String description;

  EsolatZone({required this.code, required this.state, required this.description});
}

// Senarai lengkap zon solat di Malaysia
final List<EsolatZone> esolatZones = [
  // Johor
  EsolatZone(code: 'JHR01', state: 'Johor', description: 'Pulau Aur dan Pulau Pemanggil'),
  EsolatZone(code: 'JHR02', state: 'Johor', description: 'Johor Bahru, Kota Tinggi, Mersing'),
  EsolatZone(code: 'JHR03', state: 'Johor', description: 'Kluang, Pontian'),
  EsolatZone(code: 'JHR04', state: 'Johor', description: 'Batu Pahat, Muar, Segamat, Gemas Johor'),
  // Kedah
  EsolatZone(code: 'KDH01', state: 'Kedah', description: 'Kota Setar, Kubang Pasu, Pokok Sena'),
  EsolatZone(code: 'KDH02', state: 'Kedah', description: 'Kuala Muda, Yan, Pendang'),
  EsolatZone(code: 'KDH03', state: 'Kedah', description: 'Padang Terap, Sik'),
  EsolatZone(code: 'KDH04', state: 'Kedah', description: 'Baling'),
  EsolatZone(code: 'KDH05', state: 'Kedah', description: 'Bandar Baharu, Kulim'),
  EsolatZone(code: 'KDH06', state: 'Kedah', description: 'Langkawi'),
  EsolatZone(code: 'KDH07', state: 'Kedah', description: 'Puncak Gunung Jerai'),
  // Kelantan
  EsolatZone(code: 'KTN01', state: 'Kelantan', description: 'Bachok, Kota Bharu, Machang, Pasir Mas, dll.'),
  EsolatZone(code: 'KTN03', state: 'Kelantan', description: 'Gua Musang, Jeli'),
  // Melaka
  EsolatZone(code: 'MLK01', state: 'Melaka', description: 'Seluruh Negeri Melaka'),
  // Negeri Sembilan
  EsolatZone(code: 'NGS01', state: 'Negeri Sembilan', description: 'Tampin, Jempol'),
  EsolatZone(code: 'NGS02', state: 'Negeri Sembilan', description: 'Jelebu, Kuala Pilah, Port Dickson, dll.'),
  // Pahang
  EsolatZone(code: 'PHG01', state: 'Pahang', description: 'Pulau Tioman'),
  EsolatZone(code: 'PHG02', state: 'Pahang', description: 'Kuantan, Pekan, Rompin, Muadzam Shah'),
  EsolatZone(code: 'PHG03', state: 'Pahang', description: 'Jerantut, Temerloh, Maran, Bera, dll.'),
  EsolatZone(code: 'PHG04', state: 'Pahang', description: 'Bentong, Lipis, Raub'),
  EsolatZone(code: 'PHG05', state: 'Pahang', description: 'Genting Sempah, Janda Baik, Bukit Tinggi'),
  EsolatZone(code: 'PHG06', state: 'Pahang', description: 'Cameron Highlands, Genting Highlands, Fraser'),
  // Perlis
  EsolatZone(code: 'PLS01', state: 'Perlis', description: 'Kangar, Padang Besar, Arau'),
  // Pulau Pinang
  EsolatZone(code: 'PNG01', state: 'Pulau Pinang', description: 'Seluruh Negeri Pulau Pinang'),
  // Perak
  EsolatZone(code: 'PRK01', state: 'Perak', description: 'Tapah, Slim River, Tanjung Malim'),
  EsolatZone(code: 'PRK02', state: 'Perak', description: 'Kuala Kangsar, Sg. Siput, Ipoh, dll.'),
  EsolatZone(code: 'PRK03', state: 'Perak', description: 'Lenggong, Pengkalan Hulu, Grik'),
  EsolatZone(code: 'PRK04', state: 'Perak', description: 'Temengor, Belum'),
  EsolatZone(code: 'PRK05', state: 'Perak', description: 'Kg Gajah, Teluk Intan, Bagan Datuk, dll.'),
  EsolatZone(code: 'PRK06', state: 'Perak', description: 'Selama, Taiping, Bagan Serai, Parit Buntar'),
  EsolatZone(code: 'PRK07', state: 'Perak', description: 'Bukit Larut'),
  // Sabah
  EsolatZone(code: 'SBH01', state: 'Sabah', description: 'Bahagian Sandakan (Timur), dll.'),
  EsolatZone(code: 'SBH02', state: 'Sabah', description: 'Beluran, Telupid, Pinangah, dll.'),
  EsolatZone(code: 'SBH03', state: 'Sabah', description: 'Lahad Datu, Kunak, Semporna, dll.'),
  EsolatZone(code: 'SBH04', state: 'Sabah', description: 'Bandar Tawau, Balong, Merotai, dll.'),
  EsolatZone(code: 'SBH05', state: 'Sabah', description: 'Kudat, Kota Marudu, Pitas, Pulau Banggi'),
  EsolatZone(code: 'SBH06', state: 'Sabah', description: 'Gunung Kinabalu'),
  EsolatZone(code: 'SBH07', state: 'Sabah', description: 'Kota Kinabalu, Ranau, Kota Belud, dll.'),
  EsolatZone(code: 'SBH08', state: 'Sabah', description: 'Pensiangan, Keningau, Tambunan, dll.'),
  EsolatZone(code: 'SBH09', state: 'Sabah', description: 'Beaufort, Kuala Penyu, Sipitang, dll.'),
  // Selangor
  EsolatZone(code: 'SGR01', state: 'Selangor', description: 'Gombak, Petaling, Sepang, Hulu Langat, dll.'),
  EsolatZone(code: 'SGR02', state: 'Selangor', description: 'Kuala Selangor, Sabak Bernam'),
  EsolatZone(code: 'SGR03', state: 'Selangor', description: 'Klang, Kuala Langat'),
  // Sarawak
  EsolatZone(code: 'SWK01', state: 'Sarawak', description: 'Limbang, Lawas, Sundar, Trusan'),
  EsolatZone(code: 'SWK02', state: 'Sarawak', description: 'Miri, Niah, Bekenu, Sibuti, Marudi'),
  EsolatZone(code: 'SWK03', state: 'Sarawak', description: 'Pandan, Belaga, Suai, Tatau, Bintulu'),
  EsolatZone(code: 'SWK04', state: 'Sarawak', description: 'Sibu, Mukah, Dalat, Song, Igan, dll.'),
  EsolatZone(code: 'SWK05', state: 'Sarawak', description: 'Sarikei, Matu, Julau, Rajang, Daro, dll.'),
  EsolatZone(code: 'SWK06', state: 'Sarawak', description: 'Lubok Antu, Sri Aman, Roban, Debak, dll.'),
  EsolatZone(code: 'SWK07', state: 'Sarawak', description: 'Serian, Simunjan, Samarahan, Sebuyau'),
  EsolatZone(code: 'SWK08', state: 'Sarawak', description: 'Kuching, Bau, Lundu, Sematan'),
  EsolatZone(code: 'SWK09', state: 'Sarawak', description: 'Zon Khas (Kampung Patarikan)'),
  // Terengganu
  EsolatZone(code: 'TRG01', state: 'Terengganu', description: 'Kuala Terengganu, Marang, Kuala Nerus'),
  EsolatZone(code: 'TRG02', state: 'Terengganu', description: 'Besut, Setiu'),
  EsolatZone(code: 'TRG03', state: 'Terengganu', description: 'Hulu Terengganu'),
  EsolatZone(code: 'TRG04', state: 'Terengganu', description: 'Dungun, Kemaman'),
  // Wilayah Persekutuan
  EsolatZone(code: 'WLY01', state: 'Wilayah Persekutuan', description: 'Kuala Lumpur, Putrajaya'),
  EsolatZone(code: 'WLY02', state: 'Wilayah Persekutuan', description: 'Labuan'),
];