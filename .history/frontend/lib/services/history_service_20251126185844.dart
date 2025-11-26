import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_service.dart';
import 'api_config.dart';

class HistoryService {
  final HomeService _homeService = HomeService();
  final String baseUrl = "${ApiConfig.baseUrl}/api/history";

  /// Lấy lịch sử giao dịch và map dữ liệu về chuẩn của HistoryScreen
  Future<List<Map<String, dynamic>>> fetchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    if (userId != null) {
      final transactions = await _homeService.fetchGiaoDich(userId);
      // Map các key về chuẩn của HistoryScreen
      return transactions.map((g) {
        return {
          'id': g['id'],
          'mo_ta': g['han_muc'] ?? 'Chưa có mô tả',
          'so_tien': g['so_tien'] ?? 0,
          'loai_gd': g['loai'],
          'ngay_giao_dich': g['ngay'] ?? '',
        };
      }).toList();
    }
    return [];
  }

  /// Xóa giao dịch theo ID
  Future<Map<String, dynamic>?> deleteHistory(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        // Map lại transaction để tương thích HistoryScreen
        final deleted = data['deletedTransaction'];
        return {
          'transaction': {
            'id': deleted['id'],
            'mo_ta': deleted['han_muc'] ?? 'Chưa có mô tả',
            'so_tien': deleted['so_tien'],
            'loai_gd': deleted['loai'],
            'ngay_giao_dich': deleted['ngay'],
          },
          'newBalance': data['newBalance'],
        };
      }
    }
    return null;
  }

  /// Cập nhật giao dịch
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
