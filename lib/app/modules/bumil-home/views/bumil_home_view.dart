import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/bumil_home_controller.dart';

class BumilHomeView extends GetView<BumilHomeController> {
  const BumilHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BumilHomeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BumilHomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
