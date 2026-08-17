import 'package:get/get.dart';
import 'package:monitoring_bumil_application/app/data/models/schedule_anc.dart';
import 'package:monitoring_bumil_application/app/data/providers/kehamilan_provider.dart';

class AncScheduleService {
  final _provider = KehamilanProvider();

  final RxList<JadwalAnc> schedule = <JadwalAnc>[].obs;
  final isLoading = false.obs;

  bool _fetched = false;

  Future<void> fetchSchedule({
    required int kehamilanId,
    bool force = false,
  }) async {
    if (_fetched && !force) return; // udah ada datanya, skip fetch ulang

    try {
      isLoading.value = true;
      final response = await _provider.getAntenatalCareSchedule(
        kehamilanId: kehamilanId,
      );
      schedule.assignAll(response); // sesuaikan sama bentuk response-nya
      _fetched = true;
    } catch (e) {
      // handle error
    } finally {
      isLoading.value = false;
    }
  }
}
