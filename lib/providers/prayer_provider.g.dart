// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hijriDateHash() => r'2f8e16c6badbabb149d1cc9a8961e990f8532a9c';

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
String _$prayerDataHash() => r'd299ecda36c4ca8eb952730cf95e35f8911b7e69';

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
