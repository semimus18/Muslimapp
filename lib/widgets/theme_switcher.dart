import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muslimapp/models/prayer_model.dart';
import 'package:muslimapp/providers/theme_provider.dart';

class ThemeSwitcher extends ConsumerWidget {
  final List<Prayer> prayers;

  const ThemeSwitcher({
    Key? key,
    required this.prayers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Dapatkan themeType semasa
    final currentThemeType = ref.watch(themeTypeProvider);

    return PopupMenuButton<ThemeType>(
      tooltip: 'Tukar Tema',
      icon: const Icon(Icons.palette, color: Colors.white),
      onSelected: (ThemeType selectedTheme) {
        // Tukar themeType
        ref.read(themeTypeProvider.notifier).state = selectedTheme;
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ThemeType>>[
        const PopupMenuItem<ThemeType>(
          value: ThemeType.auto,
          child: Text('Auto (Ikut Waktu Semasa)'),
        ),
        const PopupMenuDivider(),
        ...ThemeType.values
            .where((type) => type != ThemeType.auto)
            .map((themeType) => PopupMenuItem<ThemeType>(
                  value: themeType,
                  child: Row(
                    children: [
                      Text(getThemeTypeName(themeType)),
                      const SizedBox(width: 8),
                      Icon(
                        currentThemeType == themeType
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        size: 18,
                        color: currentThemeType == themeType ? Colors.blue : Colors.grey,
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }
}