import 'package:get/get.dart';

import '../controllers/bumil_add_anc_schedule_controller.dart';

class BumilAddAncScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BumilAddAncScheduleController>(
      () => BumilAddAncScheduleController(),
    );
  }
}
