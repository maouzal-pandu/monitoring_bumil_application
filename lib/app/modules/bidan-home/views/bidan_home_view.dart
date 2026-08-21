import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/bidan_home_controller.dart';

class BidanHomeView extends GetView<BidanHomeController> {
  const BidanHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BidanHomeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BidanHomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
