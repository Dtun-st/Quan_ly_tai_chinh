import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_service.dart';
import 'api_config.dart';

class HistoryService {
  final HomeService _homeService = HomeService();
  final String baseUrl = "${ApiConfig.baseUrl}/api/history";

  // Lấy lịch sử giao dịch
  Future<List<Map<String, dynamic>>> fetchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    if (userId != null) {
      return await _homeService.fetchGiaoDich(userId);
    }
    return [];
  }

  // Xóa giao dịch và trả về thông tin giao dịch đã xóa
  Future<Map<String, dynamic>?> deleteHistory(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        return data['deletedTransaction'];
      }
    }
    return null;
  }

  // Cập nhật giao dịch
  Future<bool> updateHistory(int id, double soTien) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"so_tien": soTien}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['success'] == true;
    }
    return false;
  }
}
