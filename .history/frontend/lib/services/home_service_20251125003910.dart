import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class HomeService {
  // Lấy tài khoản của user
  Future<List<Map<String, dynamic>>> fetchTaiKhoan(int userId) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/tai_khoan/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['accounts']);
    }
    return [];
  }

  // Lấy giao dịch gần đây
  Future<List<Map<String, dynamic>>> fetchGiaoDich(int userId) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/giao_dich/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['transactions']);
    }
    return [];
  }

  // Lấy thông báo
  Future<List<Map<String, dynamic>>> fetchThongBao(int userId) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/thong_bao/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['notifications']);
    }
    return [];
  }
}
