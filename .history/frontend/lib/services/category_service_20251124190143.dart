import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class CategoryService {
  // Lấy userId từ SharedPreferences
  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  /// Lấy danh sách danh mục, có thể lọc theo loại 'Thu' hoặc 'Chi'
  Future<List<Map<String, dynamic>>> getCategories({String? loai}) async {
    final userId = await _getUserId();
    if (userId == null) return [];

    // Chú ý: thêm userId vào URL để khớp với server
    final url = Uri.parse('${ApiConfig.baseUrl}/api/categories/$userId');
    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        List<Map<String, dynamic>> categories = List<Map<String, dynamic>>.from(
          data['categories'],
        );

        if (loai != null) {
          categories = categories.where((c) => c['loai'] == loai).toList();
        }

        return categories;
      }
    } catch (e) {
      print("🔥 Lỗi getCategories: $e");
    }
    return [];
  }

  /// Thêm danh mục
  Future<bool> addCategory(Map<String, dynamic> category) async {
    final userId = await _getUserId();
    if (userId == null) return false; // đảm bảo có userId

    final url = Uri.parse(
      '${ApiConfig.baseUrl}/api/categories',
    ); // trùng server
    final payload = {
      ...category,
      "nguoi_dung_id": userId, // luôn gửi userId
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      final data = jsonDecode(response.body);
      if (data['success'] == true) return true;

      print("🔥 Server trả về lỗi: ${data['message'] ?? 'Không rõ'}");
    } catch (e) {
      print("🔥 Lỗi addCategory: $e");
    }

    return false;
  }

  /// Sửa danh mục
  Future<bool> editCategory(int id, Map<String, dynamic> updatedFields) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/categories/$id');
    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedFields),
      );
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      print("🔥 Lỗi editCategory: $e");
    }
    return false;
  }

  /// Xóa danh mục
  Future<bool> deleteCategory(int id) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/categories/$id');
    try {
      final response = await http.delete(url);
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      print("🔥 Lỗi deleteCategory: $e");
    }
    return false;
  }
}
