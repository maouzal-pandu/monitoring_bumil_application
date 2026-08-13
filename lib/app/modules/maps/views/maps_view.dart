// map_picker_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:monitoring_bumil_application/app/modules/maps/controllers/maps_controller.dart';
import 'package:monitoring_bumil_application/app/core/theme/app_colors.dart'; // sesuaikan path

class MapsView extends GetView<MapsController> {
  const MapsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => FlutterMap(
              mapController: controller.mapController,
              options: MapOptions(
                initialCenter: controller.pickedLocation.value,
                initialZoom: controller.currentZoom.value,
                onTap: controller.onMapTapped,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName:
                      'com.example.monitoring_bumil_application', // sesuaikan applicationId
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: controller.pickedLocation.value,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Text field lat/lng + tombol centang, di atas
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildCoordField(controller.latController, "Latitude"),
                      const SizedBox(height: 8),
                      _buildCoordField(controller.lngController, "Longitude"),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: AppColors.primary,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: controller.confirmLocation,
                    child: const Padding(
                      padding: EdgeInsets.all(14),
                      child: Icon(Icons.check, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tombol zoom, kiri
          Positioned(
            left: 16,
            bottom: 100,
            child: Column(
              children: [
                _mapButton(icon: Icons.add, onTap: controller.zoomIn),
                const SizedBox(height: 8),
                _mapButton(icon: Icons.remove, onTap: controller.zoomOut),
              ],
            ),
          ),

          // Tombol lokasi sekarang, kanan bawah
          Positioned(
            right: 16,
            bottom: 100,
            child: Obx(
              () => _mapButton(
                icon: Icons.my_location,
                onTap: controller.isLoadingLocation.value
                    ? null
                    : controller.useCurrentLocation,
                loading: controller.isLoadingLocation.value,
              ),
            ),
          ),

          Positioned(
            top: 50,
            left: 0,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.text),
                onPressed: () => Get.back(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoordField(TextEditingController c, String label) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: TextField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        ),
        onSubmitted: (_) => Get.find<MapsController>().onTextFieldChanged(),
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _mapButton({
    required IconData icon,
    VoidCallback? onTap,
    bool loading = false,
  }) {
    return Material(
      color: AppColors.background,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(icon, color: AppColors.text),
        ),
      ),
    );
  }
}
