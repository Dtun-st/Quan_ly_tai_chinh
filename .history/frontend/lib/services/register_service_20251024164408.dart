import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class RegisterService {
  Future<void> register(String name, String email, String phone, String password) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/register');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "ho_ten": name,
        "email": email,
        "so_dien_thoai": phone,
        "mat_khau": password,
      }),
    );

    if (response.statusCode == 200) {
      print("Đăng ký thành công: ${response.body}");
    } else {
      print("Lỗi đăng ký: ${response.body}");
    }
  }
}
