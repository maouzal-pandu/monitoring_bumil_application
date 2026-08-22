import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:monitoring_bumil_application/app/core/widgets/snackbar_helper.dart';
import 'package:monitoring_bumil_application/app/data/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  late SharedPreferences prefs;

  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final identifierController = TextEditingController();
  final passwordController = TextEditingController();

  final _authProvider = Get.find<AuthProvider>();

  final _box = GetStorage();

  // @override
  // void onClose() {
  //   super.onClose();
  //   identifierController.dispose();
  //   passwordController.dispose();
  // }

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void onReady() {
    super.onReady();
    autoLogin();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final response = await _authProvider
          .login(
            identifier: identifierController.text,
            password: passwordController.text,
          )
          .timeout(
            Duration(seconds: 5),
            onTimeout: () => {"detail": "Timeout"},
          );

      if (response.containsKey("detail")) {
        SnackbarHelper.error(response["detail"]);
        return;
      }

      _box.write("user", response["user"]);
      prefs.setString("identifier", identifierController.text);
      prefs.setString("password", passwordController.text);

      RoleUser role = _authProvider.parseRole(response["user"]["role"]);

      if (role == RoleUser.bumil) {
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
      }

      if (role == RoleUser.bidan) {
        Get.offNamed("/bidan-home");
      }

      if (role == RoleUser.admin) {
        Get.offNamed("/admin-home");
      }
    } catch (e) {
      SnackbarHelper.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> autoLogin() async {
    if (!prefs.containsKey("identifier") && !prefs.containsKey("password")) {
      return;
    }

    final id = prefs.getString("identifier");
    final pass = prefs.getString("password");

    try {
      isLoading.value = true;

      final response = await _authProvider
          .login(identifier: id!, password: pass!)
          .timeout(
            Duration(seconds: 5),
            onTimeout: () => {"detail": "Timeout"},
          );

      if (response.containsKey("detail")) {
        SnackbarHelper.error(response["detail"]);
        return;
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
