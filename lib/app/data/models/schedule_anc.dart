import 'package:flutter/material.dart';

enum StatusJadwalAnc { terjadwal, selesai, terlewat, dibatalkan }

StatusJadwalAnc _statusFromString(String value) {
  return StatusJadwalAnc.values.firstWhere(
    (e) => e.name == value,
    orElse: () => StatusJadwalAnc.terjadwal,
  );
}

extension StatusJadwalAncX on StatusJadwalAnc {
  IconData get icon {
    switch (this) {
      case StatusJadwalAnc.terjadwal:
        return Icons.schedule;
      case StatusJadwalAnc.selesai:
        return Icons.check_circle;
      case StatusJadwalAnc.terlewat:
        return Icons.error;
      case StatusJadwalAnc.dibatalkan:
        return Icons.cancel;
    }
  }
}

class JadwalAnc {
  final int id;
  final int kehamilanId;
  final DateTime tanggalJadwal;
  final StatusJadwalAnc status;
  final String? catatan;

  JadwalAnc({
    required this.id,
    required this.kehamilanId,
    required this.tanggalJadwal,
    required this.status,
    this.catatan,
  });

  factory JadwalAnc.fromJson(Map<String, dynamic> json) {
    return JadwalAnc(
      id: json["id"],
      kehamilanId: json["kehamilan_id"],
      tanggalJadwal: DateTime.parse(json["tanggal_jadwal"]),
      status: _statusFromString(json["status"]),
      catatan: json["catatan"],
    );
  }
}
