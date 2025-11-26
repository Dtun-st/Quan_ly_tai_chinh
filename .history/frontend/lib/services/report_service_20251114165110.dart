import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class ReportService {
  String get baseUrl => '${ApiConfig.baseUrl}/api/report';

  /// 🧩 Lấy dữ liệu báo cáo cho user hiện tại
  Future<Map<String, Map<String, double>>> getReport() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      if (userId == null) return {"daily": {}, "weekly": {}, "monthly": {}};

      final url = Uri.parse('$baseUrl?userId=$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        Map<String, double> parse(Map<String, dynamic>? map) {
          if (map == null) return {};
          return map.map((key, value) => MapEntry(key, (value as num).toDouble()));
        }

        return {
          "daily": parse(data['daily']),
          "weekly": parse(data['weekly']),
          "monthly": parse(data['monthly']),
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
