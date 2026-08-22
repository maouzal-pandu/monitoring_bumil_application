import 'package:get/get.dart';

class AdminHomeController extends GetxController {
  final indexPage = 0.obs;

  void changeIndexPage(int index) {
    if (indexPage.value == index) return;
    indexPage.value = index;
  }
}
