import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportService {
  String get baseUrl => '${ApiConfig.baseUrl}/api/report';

  /// 🧩 Lấy dữ liệu chi tiêu cho người dùng hiện tại
  Future<Map<String, Map<String, double>>> getReport() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      if (userId == null) return {"daily": {}, "weekly": {}, "monthly": {}};

      final url = Uri.parse('$baseUrl?userId=$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        Map<String, double> parseData(Map<String, dynamic>? d) {
          if (d == null) return {};
          return d.map((key, value) => MapEntry(key, (value as num).toDouble()));
        }

        return {
          "daily": parseData(data['daily']),
          "weekly": parseData(data['weekly']),
          "monthly": parseData(data['monthly']),
        };
      } else {
        print("❌ HTTP ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      print("❌ Lỗi khi lấy báo cáo: $e");
    }

    return {"daily": {}, "weekly": {}, "monthly": {}};
  }
}
