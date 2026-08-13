import 'package:get/get.dart';

import '../controllers/bumil_home_controller.dart';

class BumilHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BumilHomeController>(
      () => BumilHomeController(),
    );
  }
}
