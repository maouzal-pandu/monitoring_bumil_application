import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/reset_pass_controller.dart';
import 'package:monitoring_bumil_application/app/core/theme/app_colors.dart';

class ResetPassView extends GetView<ResetPassController> {
  const ResetPassView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.text),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Icon(
                  Icons.password_rounded,
                  size: 64,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Atur Ulang Password',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => Text(
                    controller.isForgotPassword.value
                        ? 'Buat password baru untuk akun kamu.'
                        : 'Masukkan password lama, lalu buat password baru.',
                    style: TextStyle(fontSize: 14, color: AppColors.subtext),
                  ),
                ),
                const SizedBox(height: 32),

                // Password lama, hanya muncul kalau bukan alur forgot password
                Obx(
                  () => controller.isForgotPassword.value
                      ? const SizedBox.shrink()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Password Lama'),
                            const SizedBox(height: 8),
                            Obx(
                              () => _passwordField(
                                controller: controller.oldPasswordController,
                                obscure: controller.obscureOld.value,
                                onToggle: () => controller.obscureOld.value =
                                    !controller.obscureOld.value,
                                validator: controller.validateOldPassword,
                                hint: 'Masukkan password lama',
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                ),

                _label('Password Baru'),
                const SizedBox(height: 8),
                Obx(
                  () => _passwordField(
                    controller: controller.newPasswordController,
                    obscure: controller.obscureNew.value,
                    onToggle: () => controller.obscureNew.value =
                        !controller.obscureNew.value,
                    validator: controller.validateNewPassword,
                    hint: 'Minimal 8 karakter',
                  ),
                ),
                const SizedBox(height: 20),

                _label('Konfirmasi Password Baru'),
                const SizedBox(height: 8),
                Obx(
                  () => _passwordField(
                    controller: controller.confirmPasswordController,
                    obscure: controller.obscureConfirm.value,
                    onToggle: () => controller.obscureConfirm.value =
                        !controller.obscureConfirm.value,
                    validator: controller.validateConfirmPassword,
                    hint: 'Ulangi password baru',
                  ),
                ),
                const SizedBox(height: 32),

                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Simpan Password',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: TextStyle(color: AppColors.text),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.subtext),
        prefixIcon: Icon(Icons.lock_outline, color: AppColors.subtext),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: AppColors.subtext,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.surface0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.surface0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error),
        ),
      ),
    );
  }
}
