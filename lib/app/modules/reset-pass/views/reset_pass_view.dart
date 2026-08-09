import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/reset_pass_controller.dart';

class ResetPassView extends GetView<ResetPassController> {
  const ResetPassView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ResetPassView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ResetPassView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
