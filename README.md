## 🌱 Cara Guna Riverpod (Penerangan Lengkap & Praktikal)

Riverpod ialah package state management yang digunakan untuk mengurus data, state, dan logic aplikasi dengan cara yang lebih teratur dan scalable.

### 1. **Setup Riverpod dalam Projek**
- Tambah package `flutter_riverpod` dalam `pubspec.yaml`.
- Import `flutter_riverpod` dalam fail yang perlukan provider.

### 2. **Bungkus Root App dengan `ProviderScope`**
Ini penting supaya semua provider boleh diakses dalam aplikasi.
```dart
void main() {
	runApp(const ProviderScope(child: IslamVerseApp()));
}
```

### 3. **Cipta Provider**
Provider ialah objek yang simpan dan urus data/state. Ada banyak jenis provider, contoh:

- **StateProvider**: Untuk data ringkas yang boleh berubah.
- **FutureProvider**: Untuk data async (contoh: API call).
- **StreamProvider**: Untuk data berterusan (contoh: masa sekarang).
- **Notifier/AsyncNotifier**: Untuk logic lebih kompleks.

**Contoh StateProvider:**
```dart
final counterProvider = StateProvider<int>((ref) => 0);
```

**Contoh FutureProvider (dalam projek):**
```dart
@Riverpod(keepAlive: true)
class PrayerData extends _$PrayerData {
	@override
	Future<PrayerModel.PrayerData> build() async {
		final zone = ref.watch(zoneProvider);
		final prayerData = await loadPrayerTimes(zoneCode: zone);
		return prayerData;
	}
}
```

### 4. **Guna Provider dalam Widget**
Guna `ref.watch()` untuk dapatkan data dari provider.
```dart
class HomeScreen extends ConsumerWidget {
	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final dailyPrayersAsync = ref.watch(prayerDataProvider);
		// ...guna dailyPrayersAsync untuk UI
	}
}
```
- `ConsumerWidget` atau `Consumer` digunakan untuk akses provider dalam widget.
- `ref.watch(provider)` akan rebuild widget bila data berubah.

### 5. **Update State Provider**
Untuk ubah nilai dalam StateProvider:
```dart
ref.read(counterProvider.notifier).state++;
```

### 6. **Tips Praktikal**
- Guna provider untuk semua data/state yang perlu diakses banyak tempat.
- Untuk async data, guna `AsyncValue` (ada `.data`, `.loading`, `.error`).
- Untuk logic yang kompleks, guna Notifier/AsyncNotifier.
- Untuk performance, guna `.select()` untuk hanya rebuild bila value tertentu berubah.

### 7. **Kelebihan Riverpod**
- Mudah untuk test, scalable, dan tidak bergantung pada widget tree.
- Boleh combine dengan GoRouter untuk navigation yang lebih kemas.

---

# Muslimapp

## 📱 Project Overview
Muslimapp is a Flutter application to display daily prayer times (waktu solat) for different zones in Malaysia. It features zone selection, next prayer calculation, and a modern UI.

---

## 🚀 Technologies Used
- **Flutter**: Main framework for cross-platform mobile development
- **Riverpod**: State management (providers)
- **GoRouter**: Routing/navigation
- **HTTP**: Fetch prayer times from e-solat.gov.my
- **intl**: Date/time formatting
- **Custom Widgets**: Glassmorphic UI, custom themes

---

## 📂 Folder & File Structure (Penjelasan)

### lib/
- **main.dart**: Entry point. Initializes Riverpod and sets up the app with routing and theming.
- **models/**: Data models
	- `features_model.dart`: Model for app features (icon, label)
	- `prayer_model.dart`: Model for prayer data (name, time, icon, color)
	- `zone_model.dart`: Model and list for all prayer zones in Malaysia
- **providers/**: State management
	- `prayer_provider.dart`: Fetches and provides prayer times
	- `zone_provider.dart`: Manages selected prayer zone
	- `time_provider.dart`: Provides current time as a stream
- **routing/**
	- `app_router.dart`: App navigation (home, prayer details)
- **screens/**
	- `home_screen.dart`: Main UI, shows prayer times, zone selection, next prayer
	- `prayer_details_screen.dart`: Details for a selected prayer
- **services/**
	- `prayer_service.dart`: Fetches prayer times from API, parses data
- **themes/**
	- `themes.dart`: App color themes for each prayer
- **util/**
	- `hijri_util.dart`: Converts Gregorian to Hijri date (manual, no external package)
- **widgets/**
	- `glassmorphic_container.dart`: Custom glassmorphic effect container

---

## 🔄 App Flow (Aliran Aplikasi)
1. **main.dart** starts the app, sets up Riverpod and GoRouter.
2. **HomeScreen** (home_screen.dart) is the main screen:
	 - Uses providers to get current time, selected zone, and prayer times.
	 - Calls **prayer_service.dart** to fetch data from API.
	 - Displays next prayer, all prayer times, and allows zone selection.
3. **Zone selection** updates the provider, which triggers a new API fetch.
4. **Clicking a prayer** navigates to **PrayerDetailsScreen** via GoRouter.
5. **Themes** and **widgets** provide consistent look and feel.

---

## 📖 Tips for Reading the Codebase
- Cari fail dalam `lib/` untuk logik utama.
- Semua data dan state dikawal oleh provider (Riverpod).
- API utama: https://www.e-solat.gov.my/index.php?r=esolatApi/takwimsolat
- Kod Hijri adalah manual (lihat `util/hijri_util.dart`).
- Untuk tambah feature, boleh tambah model/provider/screen baru.

---

## 🇲🇾 Penjelasan Ringkas (Bahasa Melayu)
Setiap fail utama sudah diterangkan di atas. Flow aplikasi: App bermula di `main.dart` → HomeScreen → Provider fetch data → User boleh tukar zon → Data waktu solat dikemaskini.

---


## 🚦 Cara Guna GoRouter (Penerangan Lengkap & Praktikal)

GoRouter ialah package untuk uruskan navigation (pindah skrin) dalam Flutter. Ia sangat berguna untuk projek yang ada banyak skrin dan laluan dinamik.

### 1. **Setup GoRouter dalam `app_router.dart`**
Anda perlu sediakan senarai routes (laluan) yang aplikasi anda akan gunakan. Contoh dalam projek ini:

```dart
final goRouterProvider = Provider<GoRouter>((ref) {
	return GoRouter(
		initialLocation: '/', // Laluan permulaan bila app launch
		routes: [
			// Route untuk Home
			GoRoute(
				path: '/',
				name: 'home',
				builder: (context, state) => const HomeScreen(),
			),
			// Route dinamik untuk butiran solat
			GoRoute(
				path: '/prayer/:prayerName',
				name: 'prayerDetails',
				builder: (context, state) {
					// Ambil parameter dari URL
					final prayerName = state.pathParameters['prayerName']!;
					return PrayerDetailsScreen(prayerName: prayerName);
				},
			),
		],
	);
});
```
**Nota:**
- `:prayerName` ialah path parameter. Contoh: `/prayer/Subuh` akan buka skrin butiran untuk solat Subuh.
- Anda boleh tambah route baru ikut keperluan.

### 2. **Integrasi GoRouter dalam `main.dart`**
Anda perlu guna `MaterialApp.router` dan pass `routerConfig` dari provider GoRouter.

```dart
void main() {
	runApp(const ProviderScope(child: IslamVerseApp()));
}

class IslamVerseApp extends ConsumerWidget {
	const IslamVerseApp({super.key});
	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final router = ref.watch(goRouterProvider); // Dapatkan router dari provider
		return MaterialApp.router(
			routerConfig: router, // Penting untuk GoRouter berfungsi
			// ...theme dan lain-lain
		);
	}
}
```
**Nota:**
- `ProviderScope` diperlukan untuk Riverpod.
- `MaterialApp.router` WAJIB untuk enable GoRouter.

### 3. **Navigasi Antara Skrin (Navigation)**
Untuk navigate ke skrin lain, gunakan:
```dart
context.go('/prayer/${prayer.name}'); // Contoh: '/prayer/Subuh'
```
- `context.go()` akan tukar skrin ikut path yang anda bagi.
- Untuk ke Home:
```dart
context.go('/');
```

### 4. **Pastikan Route Wujud**
Setiap path yang anda navigate MESTI ada dalam senarai routes GoRouter. Kalau tiada, navigation tak akan berjaya.

### 5. **Bagaimana Data Dihantar ke Skrin Lain**
Parameter seperti `prayerName` dihantar melalui URL (path parameter). Dalam contoh di atas, `prayerName` diambil dari URL dan digunakan dalam `PrayerDetailsScreen`.

### 6. **Kelebihan GoRouter**
- Mudah untuk uruskan navigation yang kompleks.
- Boleh guna path parameter, query parameter, dan nested routes.
- Integrasi baik dengan Riverpod.

### 7. **Tips Praktikal**
- Untuk tambah skrin baru: Tambah route baru dalam GoRouter dan guna `context.go('/path-baru')` untuk navigate.
- Untuk debug: Pastikan semua path yang anda navigate memang wujud dalam routes.
- Untuk laluan dinamik (macam `/prayer/:prayerName`), pastikan anda pass parameter yang betul.

---

## �📚 Resources
- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod](https://riverpod.dev/)
- [GoRouter](https://pub.dev/packages/go_router)

---

_This documentation is auto-generated for easy future reference._
