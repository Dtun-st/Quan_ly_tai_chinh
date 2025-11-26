import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class CategoryService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<List<Map<String, dynamic>>> getCategories() async {
    final url = Uri.parse('$baseUrl/api/category');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return List<Map<String, dynamic>>.from(data['categories']);
        }
      }
    } catch (e) {
      print("❌ Lỗi khi gọi API getCategories: $e");
    }
    return [];
  }
}
