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
    print("Status: ${response.statusCode}");
    print("Body: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body); 
    } else {
      return {
        "success": false,
        "message": "Lỗi kết nối server: ${response.statusCode}",
      };
    }
  }
}
