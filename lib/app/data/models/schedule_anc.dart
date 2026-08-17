enum StatusJadwalAnc { terjadwal, selesai, terlewat, dibatalkan }

StatusJadwalAnc _statusFromString(String value) {
  return StatusJadwalAnc.values.firstWhere(
    (e) => e.name == value,
    orElse: () => StatusJadwalAnc.terjadwal,
  );
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
