import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class RegisterService {
  Future<Map<String, dynamic>> registerUser({
    required String hoTen,
    required String email,
    required String soDienThoai,
    required String matKhau,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/register');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "ho_ten": hoTen,
          "email": email,
          "so_dien_thoai": soDienThoai,
          "mat_khau": matKhau,
        }),
      );

      final data = jsonDecode(response.body);

      return {
        "success": data["success"] ?? false,
        "message": data["message"] ?? "Có lỗi xảy ra",
      };
    } catch (e) {
      return {
        "success": false,
        "message": "Không thể kết nối đến máy chủ",
      };
    }
  }
}
