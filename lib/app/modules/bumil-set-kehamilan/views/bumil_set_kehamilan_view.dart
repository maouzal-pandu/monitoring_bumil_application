import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/bumil_set_kehamilan_controller.dart';

class BumilSetKehamilanView extends GetView<BumilSetKehamilanController> {
  const BumilSetKehamilanView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BumilSetKehamilanView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BumilSetKehamilanView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
