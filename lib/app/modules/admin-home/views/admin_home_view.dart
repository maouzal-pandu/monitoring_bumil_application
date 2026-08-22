import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:monitoring_bumil_application/app/core/widgets/settings_button.dart';

import '../controllers/admin_home_controller.dart';

class AdminHomeView extends GetView<AdminHomeController> {
  const AdminHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => SafeArea(
          child: IndexedStack(
            index: controller.indexPage.value,
            children: [AdminHome()],
          ),
        ),
      ),
    );
  }
}

class AdminHome extends GetView<AdminHomeController> {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [SettingsButton()]));
  }
}
