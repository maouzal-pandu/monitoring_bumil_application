import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:monitoring_bumil_application/app/core/theme/app_colors.dart';
import 'package:monitoring_bumil_application/app/data/providers/auth_provider.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SettingsView'), centerTitle: true),
      body: Center(
        child: Obx(
          () => SingleChildScrollView(
            child: Column(
              children: [
                if (controller.currentRole.value == RoleUser.bumil)
                  _bumilSettings(),
                if (controller.currentRole.value == RoleUser.bidan)
                  _bidanSettings(),
                if (controller.currentRole.value == RoleUser.admin)
                  _adminSettings(),

                // logout button
                ListTile(
                  leading: Icon(Icons.logout_rounded, color: AppColors.error),
                  title: Text(
                    'Keluar',
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Get.defaultDialog(
                      title: 'Konfirmasi',
                      middleText: 'Apakah kamu yakin ingin keluar?',
                      textCancel: 'Batal',
                      textConfirm: 'Keluar',
                      confirmTextColor: Colors.white,
                      buttonColor: AppColors.error,
                      onConfirm: () => controller.logout(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bumilSettings() {
    return Column(children: [const Text("Bumil Setting")]);
  }

  Widget _bidanSettings() {
    return Column(children: [const Text("Bidan Setting")]);
  }

  Widget _adminSettings() {
    return Column(children: [const Text("Admin Setting")]);
  }
}
