import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/regist_controller.dart';

class RegistView extends GetView<RegistController> {
  const RegistView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RegistView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RegistView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
