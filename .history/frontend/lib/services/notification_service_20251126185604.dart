import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class Server {
  static Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId'); 
  }

  // Lấy danh sách thông báo
  static Future<List<dynamic>> getNotifications() async {
    final userId = await _getUserId();
    if (userId == null) return [];

    final url = "${ApiConfig.baseUrl}/api/notification/$userId";

    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  // Đánh dấu là đã đọc
  static Future<bool> markNotificationRead(int id) async {
    final url = "${ApiConfig.baseUrl}/notifications/read/$id";
    final response = await http.put(Uri.parse(url));
    return response.statusCode == 200;
  }
}
