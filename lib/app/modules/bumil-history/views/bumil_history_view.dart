import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/bumil_history_controller.dart';

class BumilHistoryView extends GetView<BumilHistoryController> {
  const BumilHistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BumilHistoryView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BumilHistoryView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
