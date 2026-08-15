import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:monitoring_bumil_application/app/core/widgets/snackbar_helper.dart';
import 'package:monitoring_bumil_application/app/data/providers/kehamilan_provider.dart';

class BumilSetKehamilanController extends GetxController {
  final isLoading = false.obs;

  final formKey = GlobalKey<FormState>();
  final gravidaController = TextEditingController(text: "0");
  final paritasController = TextEditingController(text: "0");
  final abortusController = TextEditingController(text: "0");
  final beratBadanController = TextEditingController();
  final hphtController = TextEditingController();

  DateTime? hphtDate;
  late int userId;

  final _provider = KehamilanProvider();
  final _box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    userId = Get.arguments["user_id"];
  }

  @override
  void onClose() {
    gravidaController.dispose();
    paritasController.dispose();
    abortusController.dispose();
    beratBadanController.dispose();
    beratBadanController.dispose();
    hphtController.dispose();
  }

  String getTaksiranPersalinan() {
    final x = hphtDate!.add(const Duration(days: 280));

    return "${x.year}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}";
  }

  int getHitungMundurPersalinan() {
    final htp = hphtDate!.add(const Duration(days: 280));
    // hari taksiran persalinan
    final now = DateTime.now();

    final sisaHari = htp.difference(now).inDays;

    final sisaMinggu = (sisaHari / 7).ceil();

    return sisaMinggu;
  }

  int getUmurJanin() {
    final now = DateTime.now();

    final selisihHari = now.difference(hphtDate!).inDays;

    // Umur janin dalam minggu (dibulatkan ke bawah)
    final int umurMinggu = (selisihHari / 7).floor();

    // Supaya tidak minus jika HPHT di masa depan
    return umurMinggu < 0 ? 0 : umurMinggu;
  }

  String formatDate() => DateFormat("yyyy-MM-dd").format(hphtDate!);
  int parseGPA(String gpa) => int.parse(gpa);

  Future<void> setHpht() async {
    isLoading.value = true;

    try {
      final response = await _provider.setHpht(
        userId: userId,
        date: formatDate(),
        gravida: parseGPA(gravidaController.text),
        paritas: parseGPA(paritasController.text),
        abortus: parseGPA(abortusController.text),
        bbAwal: double.parse(beratBadanController.text.replaceAll(",", ".")),
      );

      if (response.containsKey("detail")) {
        SnackbarHelper.error(response["detail"]);
        return;
      }

      _box.write("kehamilan", response["kehamilan"]);

      SnackbarHelper.success(response["massage"]);
      Get.offNamed("/bumil-home");
    } catch (e) {
      SnackbarHelper.error(e.toString());
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
