import 'package:get/get.dart';

import '../controllers/bumil_set_kehamilan_controller.dart';

class BumilSetKehamilanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BumilSetKehamilanController>(
      () => BumilSetKehamilanController(),
    );
  }
}
