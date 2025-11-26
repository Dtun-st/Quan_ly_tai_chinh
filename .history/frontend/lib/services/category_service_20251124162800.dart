// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'api_config.dart';

// class CategoryService {
//   /// Lấy userId hiện tại từ SharedPreferences
//   static Future<int?> _getUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getInt('userId');
//   }

//   /// Lấy danh sách danh mục
//   static Future<List<Map<String, dynamic>>> getCategories(String type) async {
//     final userId = await _getUserId();
//     final url = Uri.parse(
//       "${ApiConfig.baseUrl}/api/categories?type=$type&userId=$userId",
//     );

//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       List data = jsonDecode(response.body);

//       return data
//           .map<Map<String, dynamic>>(
//             (e) => {
//               'id': e['id'],
//               'name': e['name'], // ✅ backend trả 'name'
//               'icon': e['icon'],
//               'children': (e['children'] ?? [])
//                   .map(
//                     (c) => {
//                       'id': c['id'],
//                       'name': c['name'],
//                       'icon': c['icon'],
//                     },
//                   )
//                   .toList(),
//             },
//           )
//           .toList();
//     } else {
//       throw Exception("Lấy danh mục thất bại: ${response.body}");
//     }
//   }

//   /// Thêm danh mục cha
//   static Future<Map<String, dynamic>> addCategory(
//     String name,
//     String type,
//     String icon,
//   ) async {
//     final userId = await _getUserId();
//     final url = Uri.parse("${ApiConfig.baseUrl}/api/categories");

//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         'name': name,
//         'type': type,
//         'icon': icon,
//         'userId': userId,
//       }),
//     );

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception("Thêm danh mục thất bại: ${response.body}");
//     }
//   }

//   /// Thêm danh mục con
//   static Future<Map<String, dynamic>> addChildCategory(
//     int parentId,
//     String name,
//     String icon,
//   ) async {
//     final userId = await _getUserId();
//     final url = Uri.parse(
//       "${ApiConfig.baseUrl}/api/categories/$parentId/children",
//     );

//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({'name': name, 'icon': icon, 'userId': userId}),
//     );

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception("Thêm danh mục con thất bại: ${response.body}");
//     }
//   }

//   // Sửa danh mục
//   static Future<Map<String, dynamic>> updateCategory(
//     int id,
//     String name,
//     String icon,
//   ) async {
//     final url = Uri.parse("${ApiConfig.baseUrl}/api/categories/$id");
//     final response = await http.put(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({'name': name, 'icon': icon}),
//     );

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception("Sửa danh mục thất bại: ${response.body}");
//     }
//   }

//   // Xóa danh mục
//   static Future<void> deleteCategory(int id) async {
//     final url = Uri.parse("${ApiConfig.baseUrl}/api/categories/$id");
//     final response = await http.delete(url);

//     if (response.statusCode != 200) {
//       throw Exception("Xóa danh mục thất bại: ${response.body}");
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class CategoryService {
  // 📌 Lấy userId từ SharedPreferences
  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  // ================================
  // 📌 Lấy danh mục theo loại (Thu / Chi)
  // ================================
  Future<List<dynamic>> getCategories(String type) async {
    try {
      final userId = await _getUserId();
      if (userId == null) {
        print("❌ Không tìm thấy userId trong SharedPreferences");
        return [];
      }

      final url = Uri.parse(
        "${ApiConfig.baseUrl}/api/categories/$userId?type=$type",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("⚠ API lỗi getCategories: ${response.body}");
        return [];
      }
    } catch (e) {
      print("❌ Lỗi getCategories: $e");
      return [];
    }
  }

  // ================================
  // 📌 Thêm danh mục
  // ================================
  Future<bool> addCategory(String name, String type) async {
    try {
      final userId = await _getUserId();
      if (userId == null) return false;

      final url = Uri.parse("${ApiConfig.baseUrl}/api/categories");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "ten": name,
          "loai": type,
          "nguoi_dung_id": userId,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("⚠ API lỗi addCategory: ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Lỗi addCategory: $e");
      return false;
    }
  }

  // ================================
  // 📌 Xóa danh mục
  // ================================
  Future<bool> deleteCategory(int id) async {
    try {
      final url = Uri.parse("${ApiConfig.baseUrl}/api/categories/$id");

      final response = await http.delete(url);

      if (response.statusCode == 200) {
        return true;
      } else {
        print("⚠ API lỗi deleteCategory: ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Lỗi deleteCategory: $e");
      return false;
    }
  }

  // ================================
  // 📌 Cập nhật danh mục
  // ================================
  Future<bool> updateCategory(int id, String name, String icon) async {
    try {
      final url = Uri.parse("${ApiConfig.baseUrl}/api/categories/$id");

      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "ten": name,
          "icon": icon,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("⚠ API lỗi updateCategory: ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Lỗi updateCategory: $e");
      return false;
    }
  }
}
