// lib/core/utils/snackbar_helper.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarHelper {
  static void error(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade900,
      snackPosition: SnackPosition.BOTTOM,
      icon: const Icon(Icons.error_outline, color: Colors.red),
      duration: const Duration(seconds: 3),
    );
  }

  static void success(String message) {
    Get.snackbar(
      'Berhasil',
      message,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
      snackPosition: SnackPosition.BOTTOM,
      icon: const Icon(Icons.check_circle_outline, color: Colors.green),
      duration: const Duration(seconds: 3),
    );
  }
}
