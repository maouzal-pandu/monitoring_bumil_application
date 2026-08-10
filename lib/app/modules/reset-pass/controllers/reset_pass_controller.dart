import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPassController extends GetxController {
  // true = alur lupa password (dari OTP, tanpa password lama)
  // false = reset password biasa dari akun yang sudah login (butuh password lama)
  final isForgotPassword = false.obs;

  final formKey = GlobalKey<FormState>();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final obscureOld = true.obs;
  final obscureNew = true.obs;
  final obscureConfirm = true.obs;

  final isLoading = false.obs;

  String email = '';

  @override
  void onInit() {
    super.onInit();
    // Contoh pemanggilan:
    // Get.toNamed(Routes.RESET_PASSWORD, arguments: {'isForgotPassword': true, 'email': email});
    // Get.toNamed(Routes.RESET_PASSWORD, arguments: {'isForgotPassword': false});
    if (Get.arguments != null) {
      isForgotPassword.value = Get.arguments['isForgotPassword'] ?? false;
      email = Get.arguments['email'] ?? '';
    }
  }

  String? validateOldPassword(String? value) {
    if (isForgotPassword.value) return null;
    if (value == null || value.isEmpty) return 'Password lama wajib diisi';
    return null;
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) return 'Password baru wajib diisi';
    if (value.length < 8) return 'Password minimal 8 karakter';
    if (!isForgotPassword.value && value == oldPasswordController.text) {
      return 'Password baru tidak boleh sama dengan password lama';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password wajib diisi';
    }
    if (value != newPasswordController.text) {
      return 'Konfirmasi password tidak cocok';
    }
    return null;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      if (isForgotPassword.value) {
        // TODO: panggil endpoint FastAPI reset-password (via email/OTP), tanpa password lama
        // await AuthService.resetPasswordForgot(
        //   email: email,
        //   newPassword: newPasswordController.text,
        // );
      } else {
        // TODO: panggil endpoint FastAPI change-password, dengan validasi password lama
        // await AuthService.changePassword(
        //   oldPassword: oldPasswordController.text,
        //   newPassword: newPasswordController.text,
        // );
      }

      Get.snackbar(
        'Berhasil',
        'Password berhasil diperbarui',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAllNamed('/login'); // sesuaikan dengan route login kamu
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Terjadi kesalahan, coba lagi nanti',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
