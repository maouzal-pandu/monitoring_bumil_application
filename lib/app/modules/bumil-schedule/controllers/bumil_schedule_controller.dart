import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:monitoring_bumil_application/app/core/widgets/snackbar_helper.dart';
import 'package:monitoring_bumil_application/app/data/models/schedule_anc.dart';
import 'package:monitoring_bumil_application/app/data/services/anc_schedule_service.dart';

enum Filter { semua, harian, mingguan }

enum Sort { terbaru, terlama }

class BumilScheduleController extends GetxController {
  final _ancScheduleService = Get.find<AncScheduleService>();
  RxList<JadwalAnc> get schedule => _ancScheduleService.schedule;

  final _box = GetStorage();

  final isLoading = false.obs;
  final Rx<DateTime> now = DateTime.now().obs;
  final Rx<DateTime> selectedDay = DateTime.now().obs;
  final Rx<Filter> activeFilter = Filter.harian.obs;
  final Rx<Sort> activeSort = Sort.terbaru.obs;

  String getFilterName() {
    switch (activeFilter.value) {
      case Filter.semua:
        return "Semua";
      case Filter.harian:
        return "Harian";
      case Filter.mingguan:
        return "Mingguan";
    }
  }

  List<JadwalAnc> get getFilteredSchedule {
    final List<JadwalAnc> filtered = List.from(schedule)
      ..sort(
        (a, b) => _isNewest()
            ? b.tanggalJadwal.compareTo(a.tanggalJadwal)
            : a.tanggalJadwal.compareTo(b.tanggalJadwal),
      );

    switch (activeFilter.value) {
      case Filter.semua:
        return filtered;
      case Filter.harian:
        return filtered
            .where((item) => _isSameDay(item.tanggalJadwal, selectedDay.value))
            .toList();
      case Filter.mingguan:
        final start = _startOfWeek(selectedDay.value);
        final end = start.add(const Duration(days: 6));
        return filtered.where((item) {
          final tgl = item.tanggalJadwal;
          return !tgl.isBefore(start) && !tgl.isAfter(end);
        }).toList();
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  DateTime _startOfWeek(DateTime date) {
    final d = date.subtract(Duration(days: date.weekday - 1));
    return DateTime(d.year, d.month, d.day);
  }

  String getStatus(StatusJadwalAnc status) {
    switch (status) {
      case StatusJadwalAnc.terjadwal:
        return "Terjadwal";
      case StatusJadwalAnc.selesai:
        return "Selesai";
      case StatusJadwalAnc.terlewat:
        return "";
      case StatusJadwalAnc.dibatalkan:
        return "";
    }
  }

  bool _isNewest() {
    return activeSort.value == Sort.terbaru;
  }

  String getSortName() {
    switch (activeSort.value) {
      case Sort.terbaru:
        return "Terbaru";
      case Sort.terlama:
        return "Terlama";
    }
  }

  Future<void> refreshSchedule() async {
    final kehamilanId = _box.read("kehamilan")["id"];

    try {
      isLoading.value = true;

      _ancScheduleService.schedule.clear();
      _ancScheduleService.fetched = false;
      _ancScheduleService.fetchSchedule(kehamilanId: kehamilanId);
    } catch (e) {
      SnackbarHelper.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
