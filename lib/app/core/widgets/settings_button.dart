import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF222831),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          child: IconButton(
            onPressed: () => Get.toNamed("/settings"),
            icon: const Icon(Icons.settings_rounded, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
