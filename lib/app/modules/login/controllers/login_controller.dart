import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:monitoring_bumil_application/app/core/widgets/snackbar_helper.dart';
import 'package:monitoring_bumil_application/app/data/providers/auth_provider.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final identifierController = TextEditingController();
  final passwordController = TextEditingController();

  final _authProvider = AuthProvider();

  final _box = GetStorage();

  // @override
  // void onClose() {
  //   super.onClose();
  //   identifierController.dispose();
  //   passwordController.dispose();
  // }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final response = await _authProvider.login(
        identifier: identifierController.text,
        password: passwordController.text,
      );

      if (response.containsKey("detail")) {
        SnackbarHelper.error(response["detail"]);
      }

      _box.write("user", response["user"]);

      if (response["has_kehamilan"]) {
        _box.write("kehamilan", response["kehamilan"]);

        Get.offNamed("/bumil-home");
        SnackbarHelper.success("Selamat Datang");
        return;
      }

      Get.offNamed(
        "/bumil-set-kehamilan",
        arguments: {"user_id": response["user"]["id"]},
      );
    } catch (e) {
      SnackbarHelper.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
