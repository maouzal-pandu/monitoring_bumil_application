import 'package:get/get.dart';
import 'package:monitoring_bumil_application/app/data/providers/auth_provider.dart';

class SettingsController extends GetxController {
  final AuthProvider _authService = Get.find<AuthProvider>();

  RxString get currentRole => _authService.role;
}
