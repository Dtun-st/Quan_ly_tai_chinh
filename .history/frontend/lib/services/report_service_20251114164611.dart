import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class ReportService {
  String get baseUrl => '${ApiConfig.baseUrl}/api/transaction/report';

  Future<Map<String, double>> getReport(String type) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;

    final url = Uri.parse('$baseUrl?userId=$userId&type=$type');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data.map((key, value) => MapEntry(key, (value as num).toDouble()));
    } else {
      print("❌ Lỗi khi lấy báo cáo: ${response.statusCode}");
      return {};
    }
  }
}
