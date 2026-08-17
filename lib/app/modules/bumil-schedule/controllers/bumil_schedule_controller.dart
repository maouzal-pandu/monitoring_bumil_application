import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:monitoring_bumil_application/app/core/widgets/snackbar_helper.dart';
import 'package:monitoring_bumil_application/app/data/models/schedule_anc.dart';
import 'package:monitoring_bumil_application/app/data/providers/kehamilan_provider.dart';

class BumilScheduleController extends GetxController {
  final _box = GetStorage();
  final _provider = KehamilanProvider();

  final isLoading = false.obs;
  final RxList<JadwalAnc> listJadwalAnc = <JadwalAnc>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAntenatalCareSchedule();
  }

  Future<void> getAntenatalCareSchedule() async {
    isLoading.value = true;
    final kehamilanId = _box.read("kehamilan")["id"];

    try {
      final response = await _provider.getAntenatalCareSchedule(
        kehamilanId: kehamilanId,
      );

      listJadwalAnc.addAll(response);
    } catch (e) {
      SnackbarHelper.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
