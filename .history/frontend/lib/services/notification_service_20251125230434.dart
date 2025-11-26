import 'dart:convert';
import 'package:http/http.dart' as http;

class Server {
  static const String baseUrl = "http://10.0.2.2:3000"; // Android emulator

  // Lấy tất cả thông báo
  static Future<List<dynamic>> getNotifications() async {
    final response = await http.get(Uri.parse("$baseUrl/notifications/1"));
    return jsonDecode(response.body);
  }

  // Đánh dấu đã đọc
  static Future<bool> markNotificationRead(int id) async {
    final response = await http.put(Uri.parse("$baseUrl/notifications/read/$id"));
    return response.statusCode == 200;
  }
}
