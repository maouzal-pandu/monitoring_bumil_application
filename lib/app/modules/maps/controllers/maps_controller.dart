import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapsController extends GetxController {
  final MapController mapController = MapController();

  final Rx<LatLng> pickedLocation = const LatLng(
    -6.9147,
    109.1256,
  ).obs; // default: Balapulang area
  final currentZoom = 15.0.obs;

  final latController = TextEditingController();
  final lngController = TextEditingController();
  final isLoadingLocation = false.obs;

  @override
  void onInit() {
    super.onInit();
    _syncTextFields();
  }

  void _syncTextFields() {
    latController.text = pickedLocation.value.latitude.toStringAsFixed(6);
    lngController.text = pickedLocation.value.longitude.toStringAsFixed(6);
  }

  void onMapTapped(TapPosition tapPosition, LatLng point) {
    pickedLocation.value = point;
    _syncTextFields();
  }

  void onTextFieldChanged() {
    final lat = double.tryParse(latController.text);
    final lng = double.tryParse(lngController.text);
    if (lat != null && lng != null) {
      pickedLocation.value = LatLng(lat, lng);
      mapController.move(pickedLocation.value, currentZoom.value);
    }
  }

  void zoomIn() {
    currentZoom.value = (currentZoom.value + 1).clamp(2, 18);
    mapController.move(mapController.camera.center, currentZoom.value);
  }

  void zoomOut() {
    currentZoom.value = (currentZoom.value - 1).clamp(2, 18);
    mapController.move(mapController.camera.center, currentZoom.value);
  }

  Future<void> useCurrentLocation() async {
    isLoadingLocation.value = true;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        final open = await Get.dialog<bool>(
          AlertDialog(
            title: const Text("Aktifkan GPS"),
            content: const Text(
              "Lokasi perangkat sedang nonaktif. Aktifkan GPS untuk menggunakan lokasi sekarang?",
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text("Buka Pengaturan"),
              ),
            ],
          ),
        );
        if (open == true) await Geolocator.openLocationSettings();
        isLoadingLocation.value = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            "Izin Ditolak",
            "Akses lokasi dibutuhkan untuk fitur ini",
          );
          isLoadingLocation.value = false;
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          "Izin Ditolak Permanen",
          "Aktifkan izin lokasi lewat pengaturan aplikasi",
        );
        isLoadingLocation.value = false;
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      pickedLocation.value = LatLng(pos.latitude, pos.longitude);
      _syncTextFields();
      currentZoom.value = 17;
      mapController.move(pickedLocation.value, 17);
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil lokasi: $e");
    } finally {
      isLoadingLocation.value = false;
    }
  }

  void confirmLocation() {
    Get.dialog(
      AlertDialog(
        title: const Text("Konfirmasi Lokasi"),
        content: Text(
          "Lat: ${pickedLocation.value.latitude.toStringAsFixed(6)}\n"
          "Lng: ${pickedLocation.value.longitude.toStringAsFixed(6)}\n\n"
          "Gunakan lokasi ini?",
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
          TextButton(
            onPressed: () {
              Get.back(); // tutup dialog
              Get.back(
                result: pickedLocation.value,
              ); // kembali ke halaman sebelumnya
            },
            child: const Text("Ya, Gunakan"),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    latController.dispose();
    lngController.dispose();
    super.onClose();
  }
}
