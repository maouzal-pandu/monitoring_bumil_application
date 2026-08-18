import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:monitoring_bumil_application/app/core/bindings/initial_binding.dart';
import 'package:monitoring_bumil_application/app/core/theme/app_theme.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  initializeDateFormatting("id_ID");

  runApp(
    GetMaterialApp(
      initialBinding: InitialBinding(),
      title: "Monitoring Bumil App",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
    ),
  );
}
