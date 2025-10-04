// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hijriDateHash() => r'b159e4bebc54facaa5637065e781705d1d690d2f';

/// See also [hijriDate].
@ProviderFor(hijriDate)
final hijriDateProvider = AutoDisposeProvider<String>.internal(
  hijriDate,
  name: r'hijriDateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hijriDateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HijriDateRef = AutoDisposeProviderRef<String>;
String _$prayerDataHash() => r'69f1375cc7f2ef3ff5ca837c539b72da91512c0f';

/// See also [PrayerData].
@ProviderFor(PrayerData)
final prayerDataProvider =
    AsyncNotifierProvider<PrayerData, PrayerModel.PrayerData>.internal(
      PrayerData.new,
      name: r'prayerDataProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$prayerDataHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PrayerData = AsyncNotifier<PrayerModel.PrayerData>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
