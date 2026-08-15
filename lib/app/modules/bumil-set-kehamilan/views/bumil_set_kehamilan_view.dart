import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:monitoring_bumil_application/app/core/theme/app_colors.dart';
import 'package:monitoring_bumil_application/app/core/widgets/app_input_decoration.dart';

import '../controllers/bumil_set_kehamilan_controller.dart';

class BumilSetKehamilanView extends GetView<BumilSetKehamilanController> {
  const BumilSetKehamilanView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tetapkan Profil Kehamilan Anda',
                    style: TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.w800,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Isi data berikut untuk mulai memonitoring kehamilan Anda',
                    style: TextStyle(color: AppColors.subtext, fontSize: 14),
                  ),
                  const SizedBox(height: 24),

                  Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        _formCard(
                          sectionLabel: "Riwayat Haid",
                          txtfields: [
                            TextFormField(
                              controller: controller.hphtController,
                              readOnly: true,
                              decoration:
                                  AppInputDecoration.textFieldDecoration(
                                    label: "Hari Pertama Haid Terakhir",
                                  ),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                  builder: (context, child) => Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: AppColors.primary,
                                        onPrimary: Colors.white,
                                        onSurface: AppColors.text,
                                      ),
                                    ),
                                    child: child!,
                                  ),
                                );

                                if (pickedDate != null) {
                                  controller.hphtController.text =
                                      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

                                  controller.hphtDate = pickedDate;
                                  controller.getTaksiranPersalinan();
                                  controller.getUmurJanin();
                                  controller.getHitungMundurPersalinan();
                                }
                              },
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Wajib diisi' : null,
                            ),
                          ],
                        ),
                        _formCard(
                          sectionLabel: "Riwayat Kehamilan",
                          txtfields: [
                            TextFormField(
                              controller: controller.gravidaController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  AppInputDecoration.textFieldDecoration(
                                    label: "Total Kehamilan (G)",
                                  ),
                              validator: (value) =>
                                  value!.isEmpty ? 'Tidak boleh kosong' : null,
                            ),

                            TextFormField(
                              controller: controller.paritasController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  AppInputDecoration.textFieldDecoration(
                                    label: "Jumlah Persalinan Cukup Bulan (P)",

                                    helperText: "*Cukup Bulan = 37-40 Minggu",
                                  ),
                              validator: (value) =>
                                  value!.isEmpty ? 'Tidak boleh kosong' : null,
                            ),

                            TextFormField(
                              controller: controller.abortusController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  AppInputDecoration.textFieldDecoration(
                                    label: "Jumlah Keguguran (A)",
                                  ),
                              validator: (value) =>
                                  value!.isEmpty ? 'Tidak boleh kosong' : null,
                            ),
                          ],
                        ),
                        _formCard(
                          sectionLabel: "Data Tambahan",
                          txtfields: [
                            TextFormField(
                              controller: controller.beratBadanController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  AppInputDecoration.textFieldDecoration(
                                    label: "Berat Badan (kg)",

                                    // helperText: "*Opsional",
                                  ),
                              validator: (value) =>
                                  value!.isEmpty || value == ""
                                  ? "Berat badan tidak boleh kosong"
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        if (!controller.formKey.currentState!.validate()) {
                          return;
                        }
                        _showSummarySheet(context);
                      },
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: AppColors.subtext,
      fontWeight: FontWeight.w600,
      fontSize: 14.5,
    ),
  );

  Widget _summaryRow(dynamic icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        ClipOval(
          child: Container(
            padding: const EdgeInsets.all(8),
            color: AppColors.primary.withValues(alpha: 0.12),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: const TextStyle(color: AppColors.text, fontSize: 14),
              children: [
                TextSpan(text: label),
                TextSpan(
                  text: value,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showSummarySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 14,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.surface0,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Ringkasan Kehamilan',
                  style: TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                _summaryRow(
                  Icons.calendar_month_sharp,
                  'Perkiraan persalinan pada ',
                  controller.getTaksiranPersalinan(),
                ),
                _summaryRow(
                  Icons.pregnant_woman,
                  'Usia kehamilan saat ini ',
                  '${controller.getUmurJanin()} minggu',
                ),
                _summaryRow(
                  Icons.alarm,
                  'Sekitar ',
                  '${controller.getHitungMundurPersalinan()} minggu lagi menuju persalinan',
                ),
                const SizedBox(height: 8),
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => controller.isLoading.value
                          ? null
                          : controller.setHpht(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Masuk',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _formCard({
    required String sectionLabel,
    required List<TextFormField> txtfields,
  }) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: AppColors.text.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        _sectionLabel(sectionLabel),
        const SizedBox(height: 8),
        ...List.generate(txtfields.length, (index) {
          return Padding(
            padding: index < txtfields.length - 1
                ? const EdgeInsets.only(bottom: 8)
                : EdgeInsets.zero,
            child: txtfields[index],
          );
        }),
      ],
    ),
  );
}
