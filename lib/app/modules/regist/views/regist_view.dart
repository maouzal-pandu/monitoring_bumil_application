import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitoring_bumil_application/app/core/theme/app_colors.dart';
import '../controllers/regist_controller.dart';

class RegistView extends GetView<RegistController> {
  const RegistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Registrasi'),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Buat Akun Baru',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Lengkapi data diri untuk melanjutkan',
                  style: TextStyle(color: AppColors.subtext, fontSize: 13),
                ),
                const SizedBox(height: 24),

                _buildLabel('Nama Lengkap'),
                TextFormField(
                  controller: controller.namaC,
                  decoration: _inputDecoration('Masukkan nama lengkap'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
                ),
                const SizedBox(height: 16),

                _buildLabel('NIK'),
                TextFormField(
                  controller: controller.nikC,
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  decoration: _inputDecoration(
                    '16 digit NIK',
                  ).copyWith(counterText: ''),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'NIK wajib diisi';
                    if (v.length != 16) return 'NIK harus 16 digit';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildLabel('Tanggal Lahir'),
                Obx(
                  () => InkWell(
                    onTap: () => controller.pickTanggalLahir(context),
                    child: InputDecorator(
                      decoration: _inputDecoration('Pilih tanggal lahir'),
                      child: Text(
                        controller.tanggalLahirText.value.isEmpty
                            ? 'dd/mm/yyyy'
                            : controller.tanggalLahirText.value,
                        style: TextStyle(
                          color: controller.tanggalLahirText.value.isEmpty
                              ? AppColors.subtext
                              : AppColors.text,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                _buildLabel('Nomor Telepon'),
                TextFormField(
                  controller: controller.teleponC,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration('08xxxxxxxxxx'),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Nomor telepon wajib diisi'
                      : null,
                ),
                const SizedBox(height: 16),

                _buildLabel('Email'),
                TextFormField(
                  controller: controller.emailC,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration('contoh@email.com'),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email wajib diisi';
                    if (!GetUtils.isEmail(v)) return 'Format email salah';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildLabel('Password'),
                Obx(
                  () => TextFormField(
                    controller: controller.passwordC,
                    obscureText: controller.obscurePassword.value,
                    decoration: _inputDecoration('Minimal 8 karakter').copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.obscurePassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.subtext,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Password wajib diisi';
                      if (v.length < 8) return 'Minimal 8 karakter';
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),

                _buildLabel('Ulangi Password'),
                Obx(
                  () => TextFormField(
                    controller: controller.confirmPasswordC,
                    obscureText: controller.obscureConfirmPassword.value,
                    decoration: _inputDecoration('Ulangi password').copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.obscureConfirmPassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.subtext,
                        ),
                        onPressed: controller.toggleConfirmPasswordVisibility,
                      ),
                    ),
                    validator: (v) {
                      if (v != controller.passwordC.text) {
                        return 'Password tidak sama';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),

                _buildLabel('Desa/Kelurahan'),
                Obx(
                  () => DropdownButtonFormField<int>(
                    initialValue: controller.selectedVillageId.value,
                    decoration: _inputDecoration('Pilih desa'),
                    items: controller.villages
                        .map(
                          (v) => DropdownMenuItem<int>(
                            value: v.id,
                            child: Text(v.nama),
                          ),
                        )
                        .toList(),
                    onChanged: (val) =>
                        controller.selectedVillageId.value = val,
                    validator: (v) => v == null ? 'Desa wajib dipilih' : null,
                  ),
                ),
                const SizedBox(height: 16),

                _buildLabel('Alamat Lengkap'),
                TextFormField(
                  controller: controller.alamatC,
                  maxLines: 3,
                  decoration: _inputDecoration('Nama jalan, RT/RW, dsb'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Alamat wajib diisi' : null,
                ),
                const SizedBox(height: 16),

                _buildLabel('Titik Lokasi'),
                Obx(
                  () => InkWell(
                    onTap: controller.pickLocationOnMap,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.surface0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              controller.latitude.value == null
                                  ? 'Tap untuk pilih lokasi di peta'
                                  : '${controller.latitude.value!.toStringAsFixed(6)}, '
                                        '${controller.longitude.value!.toStringAsFixed(6)}',
                              style: TextStyle(
                                color: controller.latitude.value == null
                                    ? AppColors.subtext
                                    : AppColors.text,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.subtext,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Obx(
                  () => CheckboxListTile(
                    value: controller.agreeTerms.value,
                    onChanged: (v) => controller.agreeTerms.value = v ?? false,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColors.primary,
                    title: const Text(
                      'Saya menyetujui syarat & ketentuan yang berlaku',
                      style: TextStyle(fontSize: 13, color: AppColors.text),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Daftar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      'Sudah punya akun? Masuk',
                      style: TextStyle(color: AppColors.subtext),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
    ),
  );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AppColors.subtext, fontSize: 13),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.surface0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.surface0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.error),
    ),
  );
}
