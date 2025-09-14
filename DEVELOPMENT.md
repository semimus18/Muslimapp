# Muslim App - Flutter Development

## Quick Start

1. **Install Flutter**: Download from [flutter.dev](https://flutter.dev)
2. **Get Dependencies**: Run `flutter pub get` in the project directory
3. **Run the App**: Execute `flutter run` to start the application

## Features Overview

### 🕌 Prayer Times
- Real-time prayer calculations based on GPS location
- Supports multiple calculation methods
- Shows next prayer countdown
- Works offline with cached data

### 🧭 Qibla Compass  
- Accurate direction to Mecca using device sensors
- Visual compass interface
- Works anywhere in the world
- Real-time compass updates

### 📅 Islamic Calendar
- Current Hijri date display
- Automatic date conversion
- Important Islamic dates

### 📿 Dhikr Collection
- Essential daily remembrances
- Arabic text with pronunciation guide
- English translations included
- Easy-to-read Islamic typography

### 📖 Daily Verses
- Selected Quranic verses
- Arabic text with English translation
- Verse references included

## Technical Details

### Architecture
- **MVVM Pattern**: Clean separation of concerns
- **State Management**: Built-in Flutter state management
- **API Integration**: RESTful API for prayer times
- **Local Storage**: SharedPreferences for caching

### Dependencies
- `http`: API requests for prayer times
- `geolocator`: Location services
- `permission_handler`: Runtime permissions
- `flutter_compass`: Device compass access
- `hijri`: Islamic calendar calculations
- `shared_preferences`: Local data storage

### Permissions Required
- **Location**: For accurate prayer times and Qibla direction
- **Internet**: For fetching prayer time data

## Build Instructions

### Android APK
```bash
flutter build apk --release
```

### iOS App
```bash
flutter build ios --release
```

### Web App
```bash
flutter build web --release
```

## Testing
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new features
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.