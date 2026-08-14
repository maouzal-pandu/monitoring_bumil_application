import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitoring_bumil_application/app/core/widgets/snackbar_helper.dart';
import 'package:monitoring_bumil_application/app/data/providers/auth_provider.dart';

class ForgotPassController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final isLoading = false.obs;

  final _authProvider = AuthProvider();

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email wajib diisi';
    final regex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!regex.hasMatch(value)) return 'Format email tidak valid';
    return null;
  }

  Future<void> sendResetLink() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final response = await _authProvider.sendResetPasswordEmail(
        email: emailController.text,
      );

      SnackbarHelper.success(response["message"]);

      Get.toNamed(
        "/otp",
        arguments: {"is_reset_password": true, "email": emailController.text},
      );
    } catch (e) {
      SnackbarHelper.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
