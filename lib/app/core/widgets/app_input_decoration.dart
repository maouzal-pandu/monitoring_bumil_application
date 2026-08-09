import 'package:flutter/material.dart';
import 'package:monitoring_bumil_application/app/core/theme/app_colors.dart';

class AppInputDecoration {
  AppInputDecoration._();

  static InputDecoration form({
    required String label,
    IconData? icon,
    Widget? suffixIcon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: AppColors.subtext) : null,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      errorStyle: const TextStyle(color: AppColors.error),
    );
  }
}
