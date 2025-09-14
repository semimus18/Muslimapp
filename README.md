# Muslim App

A comprehensive Flutter application designed for Muslims to help with their daily religious practices.

## Features

### 🕌 Prayer Times
- Accurate prayer times based on your location
- Support for different calculation methods
- Next prayer notification display

### 🧭 Qibla Direction
- Compass pointing towards Mecca (Kaaba)
- Accurate direction calculation based on your location
- Visual compass interface

### 📅 Islamic Calendar
- Hijri date display
- Current Islamic date alongside Gregorian date

### 📿 Dhikr & Prayers
- Collection of daily Islamic prayers and remembrances
- Arabic text with transliteration and translation
- Including:
  - Istighfar (Seeking forgiveness)
  - Tasbih (Glorification)
  - Tahmid (Praise)
  - Takbir (Magnification)
  - Tawhid (Declaration of Unity)

### 📖 Daily Verse
- Daily Quranic verse display
- Arabic text with English translation
- Verse reference included

## Screenshots

The app features a beautiful Islamic-themed green interface with:
- Home screen with Islamic greeting and quick actions
- Prayer times page with all five daily prayers
- Qibla compass for finding direction to Mecca
- Dhikr collection with Arabic, transliteration, and translation

## Permissions

The app requires the following permissions:
- **Location**: To calculate accurate prayer times and Qibla direction
- **Internet**: To fetch prayer times from online Islamic API

## Technology Stack

- **Framework**: Flutter 3.0+
- **Programming Language**: Dart
- **APIs**: Aladhan Prayer Times API
- **Location Services**: Geolocator package
- **Islamic Calendar**: Hijri package

## Installation

1. Ensure you have Flutter installed on your system
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the application

## Building

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests to improve the app.

## License

This project is open source and available under the MIT License.
