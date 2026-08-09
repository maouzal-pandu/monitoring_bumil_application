import 'package:flutter/material.dart';
import 'package:monitoring_bumil_application/app/core/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,

      secondary: AppColors.secondary,
      onSecondary: Colors.white,

      surface: AppColors.white,
      onSurface: AppColors.text,

      error: AppColors.error,
      onError: Colors.white,
    ),
  );
}
