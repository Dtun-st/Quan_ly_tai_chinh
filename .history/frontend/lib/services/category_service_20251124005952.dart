import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class CategoryService {
  /// Lấy userId hiện tại từ SharedPreferences
  static Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  /// Lấy danh sách danh mục
  static Future<List<Map<String, dynamic>>> getCategories(String type) async {
    final userId = await _getUserId();
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/categories?type=$type&userId=$userId"),
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map<Map<String, dynamic>>((e) => {
        'id': e['id'],
        'name': e['ten_danh_muc'],
        'icon': e['icon'],
        'children': e['children'] ?? [],
      }).toList();
    } else {
      throw Exception("Lấy danh mục thất bại");
    }
  }

  /// Thêm danh mục mới
  static Future<Map<String, dynamic>> addCategory(
      String name, String type, String icon) async {
    final userId = await _getUserId();
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/categories"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'name': name,
        'type': type,
        'icon': icon,
        'userId': userId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Thêm danh mục thất bại");
    }
  }

  /// Thêm danh mục con
  static Future<Map<String, dynamic>> addChildCategory(
      int parentId, String name, String icon) async {
    final userId = await _getUserId();
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/categories/$parentId/children"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'name': name,
        'icon': icon,
        'userId': userId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Thêm danh mục con thất bại");
    }
  }
}
