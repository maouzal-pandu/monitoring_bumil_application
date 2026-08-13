import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitoring_bumil_application/app/core/widgets/snackbar_helper.dart';
import 'package:monitoring_bumil_application/app/data/providers/auth_provider.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final isPasswordHidden = false.obs;
  final identifierController = TextEditingController();
  final passwordController = TextEditingController();

  final _authProvider = AuthProvider();

  @override
  void onClose() {
    super.onClose();
    identifierController.dispose();
    passwordController.dispose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async {
    try {
      isLoading.value = true;

      final response = await _authProvider.login(
        identifier: identifierController.text,
        password: passwordController.text,
      );

      if (response.containsKey("detail")) {
        SnackbarHelper.error(response["detail"]);
      }

      if (response["has_kehamilan"]) {
        Get.offNamed("/bumil-home");
        SnackbarHelper.success("Selamat Datang");
      }

      Get.offNamed("/bumil-set-kehamilan");
    } catch (e) {
      SnackbarHelper.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
