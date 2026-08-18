import 'package:get/get.dart';
import 'package:monitoring_bumil_application/app/modules/bumil-history/controllers/bumil_history_controller.dart';
import 'package:monitoring_bumil_application/app/modules/bumil-schedule/controllers/bumil_schedule_controller.dart';

import '../controllers/bumil_home_controller.dart';

class BumilHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BumilHomeController>(() => BumilHomeController());
    Get.lazyPut<BumilScheduleController>(() => BumilScheduleController());
    Get.lazyPut<BumilHistoryController>(() => BumilHistoryController());
  }
}
