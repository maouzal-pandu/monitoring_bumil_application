import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:monitoring_bumil_application/app/data/models/schedule_anc.dart';

class KehamilanProvider {
  final _baseUrl = const String.fromEnvironment(
    "API_BASE_URL",
    defaultValue: "http://localhost:8000",
  );

  Future<Map<String, dynamic>> setHpht({
    required int userId,
    required String date,
    required int gravida,
    required int paritas,
    required int abortus,
    required double bbAwal,
  }) async {
    final url = Uri.parse("$_baseUrl/set-hpht");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "hpht": date,
          "bb_awal": bbAwal,
          "gravida": gravida,
          "paritas": paritas,
          "abortus": abortus,
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        throw Exception(data["detail"] ?? {"detail": "Error"});
      }

      return data;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<Map<String, dynamic>> setAntenatalCareSchedule({
    required int kehamilanId,
    required DateTime tanggalJadwal,
    required String catatan,
  }) async {
    final url = Uri.parse("$_baseUrl/set-jadwal-anc");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "kehamilan_id": kehamilanId,
          "tanggal_jadwal": tanggalJadwal,
          "catatan": catatan,
        }),
      );

      final data = jsonDecode(response.body);

      return data;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<List<JadwalAnc>> getAntenatalCareSchedule({
    required int kehamilanId,
  }) async {
    final url = Uri.parse("$_baseUrl/jadwal-anc/$kehamilanId");

    try {
      final response = await http.get(url);

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(data["detail"] ?? "Gagal memuat jadwal anc");
      }

      return (data as List).map((e) => JadwalAnc.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<Map<String, dynamic>> setAntenatalCareScheduleStatus({
    required int scheduleId,
    required String status,
  }) async {
    final url = Uri.parse("$_baseUrl/change-jadwal-anc-status");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"schedule_id": scheduleId, "status": status}),
      );

      final data = jsonDecode(response.body);

      return data;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
