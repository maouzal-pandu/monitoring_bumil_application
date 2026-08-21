import 'package:get/get.dart';
import 'package:monitoring_bumil_application/app/data/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final AuthProvider _authService = Get.find<AuthProvider>();

  Rx<RoleUser> get currentRole => _authService.role;

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Get.offAllNamed("/login");
  }
}
