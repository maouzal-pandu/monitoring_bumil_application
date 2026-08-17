import 'package:get/get.dart';

import '../controllers/bumil_history_controller.dart';

class BumilHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BumilHistoryController>(
      () => BumilHistoryController(),
    );
  }
}
