import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthProvider {
  final _baseUrl = const String.fromEnvironment(
    "API_BASE_URL",
    defaultValue: "http://localhost:8000",
  );

  String get _url => "$_baseUrl/auth";

  Future<Map<String, dynamic>> createUser({
    required String nama,
    required String nik,
    required String email,
    required String nomerTelepon,
    required String password,
    String? alamat,
    required int desaId,
    double? latitude,
    double? longitude,
    required DateTime tanggalLahir,
    required String role, // "admin" | "bidan" | "bumil"
  }) async {
    final url = Uri.parse('$_url/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama': nama,
          'nik': nik,
          'email': email,
          'nomer_telepon': nomerTelepon,
          'password': password,
          'alamat': alamat,
          'desa_id': desaId,
          'latitude': latitude,
          'longitude': longitude,
          'tanggal_lahir': tanggalLahir.toIso8601String().split('T').first,
          'role': role,
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(data['detail'] ?? 'Gagal membuat user');
      }

      return data;
    } catch (e) {
      throw Exception('Error createUser: $e');
    }
  }

  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    final url = Uri.parse("$_url/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"identifier": identifier, "password": password}),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return {"detail": data["detail"]};
      }

      return data;
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<Map<String, dynamic>> verifyRegistOtp({
    required String email,
    required String otp,
  }) async {
    final url = Uri.parse("$_url/verify-regist-otp");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "code": otp}),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        throw Exception(data["detail"] ?? "Kode OTP tidak valid");
      }

      return data;
    } catch (e) {
      throw Exception("Error verify regist otp: $e");
    }
  }

  Future<Map<String, dynamic>> sendResetPasswordEmail({
    required String email,
  }) async {
    final url = Uri.parse("$_url/send-reset-password-otp");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      return data;
    } catch (e) {
      throw Exception("Error send reset password email: $e");
    }
  }

  Future<Map<String, dynamic>> verifyResetPasswordOtp({
    required String email,
    required String otp,
  }) async {
    final url = Uri.parse("$_url/verify-reset-password-otp");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "code": otp}),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        throw Exception(data["detail"] ?? "Kode OTP tidak valid");
      }

      return data;
    } catch (e) {
      throw Exception("Error verify regist otp: $e");
    }
  }

  Future<Map<String, dynamic>> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    final url = Uri.parse("$_url/reset-password");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"reset_token": resetToken, "password": newPassword}),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        throw Exception(data["detail"] ?? "Kode OTP tidak valid");
      }

      return data;
    } catch (e) {
      throw Exception("Error verify regist otp: $e");
    }
  }

  Future<List> getDesas() async {
    final url = Uri.parse("$_url/desa");

    try {
      final response = await http.get(url);

      final data = jsonDecode(response.body);

      return data;
    } catch (e) {
      throw Exception(e);
    }
  }
}
