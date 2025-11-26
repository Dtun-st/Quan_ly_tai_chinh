import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ChangePasswordService {
  Future<Map<String, dynamic>> changePassword({
    required int userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/password/change');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "oldPassword": oldPassword,
        "newPassword": newPassword,
      }),
    );

    final data = jsonDecode(response.body);
    return {
      "success": data["success"],
      "message": data["message"],
    };
  }
}
