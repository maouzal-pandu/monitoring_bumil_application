import 'package:get/get.dart';

import '../controllers/bumil_schedule_controller.dart';

class BumilScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BumilScheduleController>(
      () => BumilScheduleController(),
    );
  }
}
