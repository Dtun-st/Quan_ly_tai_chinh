import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class AuthService {
  /// Gửi OTP
  static Future<bool> sendResetCode(String email) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/api/forgot"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error sendResetCode: $e");
      return false;
    }
  }

  /// Reset mật khẩu
  static Future<bool> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/api/forgot/reset"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "code": code,
          "newPassword": newPassword,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error resetPassword: $e");
      return false;
    }
  }
}
