import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitoring_bumil_application/app/core/widgets/snackbar_helper.dart';
import 'package:monitoring_bumil_application/app/data/models/village_model.dart';
import 'package:monitoring_bumil_application/app/data/providers/auth_provider.dart';

class RegistController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final namaC = TextEditingController();
  final nikC = TextEditingController();
  final teleponC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final confirmPasswordC = TextEditingController();
  final alamatC = TextEditingController();

  final tanggalLahirText = ''.obs;
  DateTime? tanggalLahir;

  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final agreeTerms = false.obs;
  final isLoading = false.obs;

  final selectedVillageId = Rxn<VillageModel>();
  final villages = <VillageModel>[].obs; // ganti sesuai model kamu

  final latitude = Rxn<double>();
  final longitude = Rxn<double>();

  final _authProvider = AuthProvider();

  @override
  void onInit() async {
    super.onInit();
    getDesas();
  }

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;

  void toggleConfirmPasswordVisibility() =>
      obscureConfirmPassword.value = !obscureConfirmPassword.value;

  Future<void> pickTanggalLahir(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      tanggalLahir = picked;
      tanggalLahirText.value = '${picked.day}/${picked.month}/${picked.year}';
    }
  }

  Future<void> pickLocationOnMap() async {
    final result = await Get.toNamed("/maps");
    if (result == null) return; // user cancel/back tanpa pilih
    latitude.value = result.latitude;
    longitude.value = result.longitude;
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    if (!agreeTerms.value) {
      Get.snackbar('Perhatian', 'Anda harus menyetujui syarat & ketentuan');
      return;
    }

    if (latitude.value == null) {
      Get.snackbar('Perhatian', 'Pilih lokasi terlebih dahulu');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _authProvider.createUser(
        nama: namaC.text,
        nik: nikC.text,
        email: emailC.text,
        nomerTelepon: teleponC.text,
        password: passwordC.text,
        desaId: selectedVillageId.value!.id,
        tanggalLahir: tanggalLahir!,
        alamat: alamatC.text,
        latitude: latitude.value,
        longitude: longitude.value,
        role: "bumil",
      );

      if (response.containsKey("detail")) {
        return SnackbarHelper.error(response["detail"]);
      }

      SnackbarHelper.success(response["message"]);
      Get.offNamed(
        "/otp",
        arguments: {"email": emailC.text, "is_reset_password": false},
      );
    } catch (e) {
      SnackbarHelper.error(e.toString());
      print(e.toString());
    } finally {
      isLoading.value = false;
      print(
        "${namaC.text}"
        "${nikC.text}"
        "${emailC.text}"
        "${teleponC.text}"
        "${passwordC.text}"
        "${selectedVillageId.value!.id}"
        "${tanggalLahir}",
      );
    }
  }

  Future<void> getDesas() async {
    final data = await _authProvider.getDesas();
    villages.value = data.map((e) => VillageModel.fromJson(e)).toList();
  }
}
