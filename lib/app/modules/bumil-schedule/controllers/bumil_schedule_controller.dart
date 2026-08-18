import 'package:get/get.dart';

class BumilScheduleController extends GetxController {
  final isLoading = false.obs;

  final Rx<DateTime> now = DateTime.now().obs;

  final Rx<DateTime> selectedDay = DateTime.now().obs;
}
