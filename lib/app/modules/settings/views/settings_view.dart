import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SettingsView'), centerTitle: true),
      body: Center(
        child: Obx(
          () => Text(
            controller.currentRole.value,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
