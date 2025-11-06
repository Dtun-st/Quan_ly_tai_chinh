import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterService {
  static const String baseUrl = 'http://10.0.2.2:3000'; // localhost cho Android Emulator

  static Future<Map<String, dynamic>> registerUser({
    required String hoTen,
    required String email,
    required String soDienThoai,
    required String matKhau,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/register');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'ho_ten': hoTen,
          'email': email,
          'so_dien_thoai': soDienThoai,
          'mat_khau': matKhau,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'success': false, 'message': jsonDecode(response.body)['message'] ?? 'Lỗi server'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
