import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/bumil_schedule_controller.dart';

class BumilScheduleView extends GetView<BumilScheduleController> {
  const BumilScheduleView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BumilScheduleView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BumilScheduleView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
