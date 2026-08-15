import 'dart:convert';

import 'package:http/http.dart' as http;

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
}
