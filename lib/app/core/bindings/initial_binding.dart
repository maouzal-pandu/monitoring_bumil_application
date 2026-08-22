// app/core/bindings/initial_binding.dart
import 'package:get/get.dart';
import 'package:monitoring_bumil_application/app/data/providers/auth_provider.dart';
import 'package:monitoring_bumil_application/app/data/services/anc_schedule_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AncScheduleService(), permanent: true);
    Get.put(AuthProvider(), permanent: true);
  }
}
