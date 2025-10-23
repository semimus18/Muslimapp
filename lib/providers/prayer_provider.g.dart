// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hijriDateHash() => r'dbeb94f907426e9df04a5e17cc59fd6ecca8c749';

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
String _$prayerDataHash() => r'b68a7026fd39132e52ee53e82653f47f52b79b6a';

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
