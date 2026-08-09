import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  final selectedVillageId = Rxn<int>();
  final villages = [].obs; // ganti sesuai model kamu

  final latitude = Rxn<double>();
  final longitude = Rxn<double>();

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
    // navigasi ke halaman map picker, lalu:
    // final result = await Get.to(() => MapPickerView());
    // latitude.value = result.latitude;
    // longitude.value = result.longitude;
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
      // panggil API registrasi
    } catch (e) {
      Get.snackbar('Gagal', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
