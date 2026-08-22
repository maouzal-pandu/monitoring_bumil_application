import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/bumil_add_anc_schedule_controller.dart';

class BumilAddAncScheduleView extends GetView<BumilAddAncScheduleController> {
  const BumilAddAncScheduleView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BumilAddAncScheduleView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BumilAddAncScheduleView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
