import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:monitoring_bumil_application/app/core/theme/app_theme.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Monitoring Bumil App",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
    ),
  );
}
