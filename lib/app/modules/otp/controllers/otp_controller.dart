import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  final email = ''.obs;
  final isLoading = false.obs;
  final errorText = ''.obs;
  final secondsLeft = 60.obs;

  final otpControllers = List.generate(6, (_) => TextEditingController());
  final focusNodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // Ambil email dari argument, misal Get.toNamed(Routes.OTP, arguments: {'email': email})
    if (Get.arguments != null && Get.arguments['email'] != null) {
      email.value = Get.arguments['email'];
    }
    _startTimer();
  }

  void _startTimer() {
    secondsLeft.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft.value == 0) {
        timer.cancel();
      } else {
        secondsLeft.value--;
      }
    });
  }

  void onOtpChanged(int index, String value, BuildContext context) {
    errorText.value = '';
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }

    // auto-submit kalau semua kotak udah keisi
    if (otpControllers.every((c) => c.text.isNotEmpty)) {
      FocusScope.of(context).unfocus();
      verifyOtp();
    }
  }

  String get otpCode => otpControllers.map((c) => c.text).join();

  Future<void> verifyOtp() async {
    if (otpCode.length < 6) {
      errorText.value = 'Masukkan 6 digit kode OTP';
      return;
    }

    try {
      isLoading.value = true;
      // TODO: panggil endpoint FastAPI verify-otp kamu di sini
      // await AuthService.verifyOtp(email.value, otpCode);

      Get.snackbar(
        'Berhasil',
        'Verifikasi berhasil',
        snackPosition: SnackPosition.BOTTOM,
      );
      // Get.offNamed(Routes.RESET_PASSWORD, arguments: {'email': email.value});
    } catch (e) {
      errorText.value = 'Kode OTP salah atau kadaluarsa';
      for (var c in otpControllers) {
        c.clear();
      }
      focusNodes[0].requestFocus();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    try {
      // TODO: panggil endpoint FastAPI resend-otp kamu di sini
      // await AuthService.resendOtp(email.value);
      _startTimer();
      Get.snackbar(
        'Terkirim',
        'Kode OTP baru telah dikirim',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal mengirim ulang kode',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var c in otpControllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.onClose();
  }
}
