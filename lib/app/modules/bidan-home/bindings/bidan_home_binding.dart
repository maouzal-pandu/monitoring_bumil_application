import 'package:get/get.dart';

import '../controllers/bidan_home_controller.dart';

class BidanHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BidanHomeController>(
      () => BidanHomeController(),
    );
  }
}
