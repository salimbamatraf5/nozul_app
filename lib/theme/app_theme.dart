import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static final ValueNotifier<ThemeMode> appThemeMode = ValueNotifier<ThemeMode>(
    ThemeMode.dark,
  );
  static ThemeData darkTheme = ThemeData(
    fontFamily: 'IBMPlexArabic',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.gold,
      brightness: Brightness.dark,
      surface: AppColors.DarkSurface,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.lightText),
    ),
  );
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'IBMPlexArabic',

    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.gold,
      surface: AppColors.lightSurface,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.darkText),
    ),
  );
}
