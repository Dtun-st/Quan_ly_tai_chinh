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
        if (data['success'] == true && data['categories'] != null) {
          return List<Map<String, dynamic>>.from(data['categories']);
        }
      }
    } catch (e) {
      print("❌ Lỗi khi gọi API getCategories: $e");
    }

    // Fallback tạm thời
    return [
      {"id": 1, "name": "Ăn uống", "icon": "restaurant"},
      {"id": 2, "name": "Di chuyển", "icon": "directions_car"},
      {"id": 3, "name": "Giải trí", "icon": "sports_esports"},
      {"id": 4, "name": "Mua sắm", "icon": "shopping_cart"},
      {"id": 5, "name": "Khác", "icon": "more_horiz"},
    ];
  }
}
