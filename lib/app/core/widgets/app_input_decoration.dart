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

  static InputDecoration textFieldDecoration({
    required String label,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? hintText,
    String? helperText,
  }) {
    OutlineInputBorder border(Color color, {double width = 1}) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecoration(
      labelText: label,
      hintText: hintText,
      helperText: helperText,
      labelStyle: const TextStyle(color: AppColors.subtext, fontSize: 14),
      hintStyle: const TextStyle(color: AppColors.subtext, fontSize: 14),
      helperStyle: const TextStyle(color: AppColors.subtext, fontSize: 12),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: border(AppColors.surface0),
      enabledBorder: border(AppColors.surface0),
      focusedBorder: border(AppColors.primary, width: 1.5),
      errorBorder: border(AppColors.error),
      focusedErrorBorder: border(AppColors.error, width: 1.5),
      errorStyle: const TextStyle(color: AppColors.error, fontSize: 12),
    );
  }
}
