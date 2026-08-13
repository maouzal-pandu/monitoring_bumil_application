import 'package:get/get.dart';

import '../modules/bumil-home/bindings/bumil_home_binding.dart';
import '../modules/bumil-home/views/bumil_home_view.dart';
import '../modules/bumil-set-kehamilan/bindings/bumil_set_kehamilan_binding.dart';
import '../modules/bumil-set-kehamilan/views/bumil_set_kehamilan_view.dart';
import '../modules/forgot-pass/bindings/forgot_pass_binding.dart';
import '../modules/forgot-pass/views/forgot_pass_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/otp/bindings/otp_binding.dart';
import '../modules/otp/views/otp_view.dart';
import '../modules/regist/bindings/regist_binding.dart';
import '../modules/regist/views/regist_view.dart';
import '../modules/reset-pass/bindings/reset_pass_binding.dart';
import '../modules/reset-pass/views/reset_pass_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGIST,
      page: () => const RegistView(),
      binding: RegistBinding(),
    ),
    GetPage(
      name: _Paths.OTP,
      page: () => const OtpView(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASS,
      page: () => const ForgotPassView(),
      binding: ForgotPassBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASS,
      page: () => const ResetPassView(),
      binding: ResetPassBinding(),
    ),
    GetPage(
      name: _Paths.BUMIL_HOME,
      page: () => const BumilHomeView(),
      binding: BumilHomeBinding(),
    ),
    GetPage(
      name: _Paths.BUMIL_SET_KEHAMILAN,
      page: () => const BumilSetKehamilanView(),
      binding: BumilSetKehamilanBinding(),
    ),
  ];
}
