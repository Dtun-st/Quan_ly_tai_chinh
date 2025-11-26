import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class ReportService {
  /// 🧩 Lấy báo cáo chi tiêu từ backend theo loại: daily, weekly, monthly
  Future<Map<String, double>> getReport(String type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      if (userId == null) return {};

      final url = Uri.parse('${ApiConfig.baseUrl}/api/report?userId=$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['report'] != null) {
          final report = data['report'];
          Map<String, dynamic> raw;
          switch (type) {
            case 'daily':
              raw = report['daily'] ?? {};
              break;
            case 'weekly':
              raw = report['weekly'] ?? {};
              break;
            case 'monthly':
              raw = report['monthly'] ?? {};
              break;
            default:
              raw = {};
          }
          return raw.map((key, value) => MapEntry(key, (value as num).toDouble()));
        }
      } else {
        print("❌ HTTP ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      print("❌ Lỗi khi lấy báo cáo: $e");
    }
    return {};
  }
}
