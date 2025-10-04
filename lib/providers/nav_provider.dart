// lib/providers/nav_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider untuk simpan index tab yang aktif.
final navIndexProvider = StateProvider<int>((ref) => 0);