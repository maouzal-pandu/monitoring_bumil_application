import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitoring_bumil_application/app/core/widgets/snackbar_helper.dart';
import 'package:monitoring_bumil_application/app/data/providers/auth_provider.dart';

class OtpController extends GetxController {
  final isLoading = false.obs;
  final errorText = ''.obs;
  final secondsLeft = 60.obs;

  bool isRegister = true;

  late String email;

  final otpControllers = List.generate(6, (_) => TextEditingController());
  final focusNodes = List.generate(6, (_) => FocusNode());

  final _authProvider = AuthProvider();

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();

    _startTimer();

    final args = Get.arguments;
    if (args["is_reset_password"] != null) isRegister = false;
    email = args["email"];
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

      if (isRegister) {
        final response = await _authProvider.verifyRegistOtp(
          email: email,
          otp: otpCode,
        );

        if (response.containsKey("detail")) {
          SnackbarHelper.error(response["detail"]);
          for (var c in otpControllers) {
            c.clear();
          }
          return;
        }

        SnackbarHelper.success(response["message"]);
        Get.offAllNamed("/login");
        return;
      }

      // Verify Reset Password OTP Section
      final response = await _authProvider.verifyResetPasswordOtp(
        email: email,
        otp: otpCode,
      );

      if (response.containsKey("detail")) {
        SnackbarHelper.error(response["detail"]);

        for (var c in otpControllers) {
          c.clear();
        }
      }

      Get.offNamed(
        "/reset-pass",
        arguments: {
          "reset_token": response["reset_token"],
          "is_forgot_password": true,
        },
      );
    } catch (e) {
      errorText.value = e.toString();
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
      _startTimer();

      final response = await _authProvider.sendResetPasswordEmail(email: email);

      SnackbarHelper.success(response["message"]);
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal mengirim ulang kode',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
