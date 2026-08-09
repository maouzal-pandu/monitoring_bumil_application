import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/forgot_pass_controller.dart';

class ForgotPassView extends GetView<ForgotPassController> {
  const ForgotPassView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ForgotPassView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ForgotPassView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
