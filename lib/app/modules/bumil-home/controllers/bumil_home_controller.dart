import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:monitoring_bumil_application/app/data/models/schedule_anc.dart';
import 'package:monitoring_bumil_application/app/data/services/anc_schedule_service.dart';

class BumilHomeController extends GetxController {
  final _ancScheduleService = Get.find<AncScheduleService>();

  final indexPage = 0.obs;
  RxList<JadwalAnc> get schedule => _ancScheduleService.schedule;

  @override
  void onInit() {
    super.onInit();
    final kehamilanId = GetStorage().read("kehamilan")["id"];
    _ancScheduleService.fetchSchedule(kehamilanId: kehamilanId);
  }

  void changeIndexPage(int index) {
    if (indexPage.value == index) return;
    indexPage.value = index;
  }
}
