import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_service.dart';

class HistoryService {
  final HomeService _homeService = HomeService();
  final String baseUrl = "http://10.0.2.2:3000/api/history";

  Future<List<Map<String, dynamic>>> fetchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    if (userId != null) {
      return await _homeService.fetchGiaoDich(userId);
    }
    return [];
  }

  Future<bool> deleteHistory(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    if (response.statusCode == 200) {
      return json.decode(response.body)['success'] == true;
    }
    return false;
  }

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
