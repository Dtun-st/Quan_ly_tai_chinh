// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'api_config.dart';
// class BankService {
//   Future<List<Map<String, dynamic>>> getAccounts(int userId) async {
//     final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$userId'); // sửa đây
//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       if (data['success'] == true) {
//         return List<Map<String, dynamic>>.from(data['accounts']);
//       }
//     }
//     return [];
//   }

//   Future<bool> addAccount(Map<String, dynamic> account) async {
//     final url = Uri.parse('${ApiConfig.baseUrl}/api/bank'); // sửa đây
//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(account),
//     );
//     final data = jsonDecode(response.body);
//     return data['success'] == true;
//   }

//   Future<bool> editAccount(int id, Map<String, dynamic> account) async {
//     final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$id'); // sửa đây
//     final response = await http.put(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(account),
//     );
//     final data = jsonDecode(response.body);
//     return data['success'] == true;
//   }

//   Future<bool> deleteAccount(int id) async {
//     final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$id'); // sửa đây
//     final response = await http.delete(url);
//     final data = jsonDecode(response.body);
//     return data['success'] == true;
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class BankService {
  /// 🧩 Lấy danh sách tài khoản theo userId
  Future<List<Map<String, dynamic>>> getAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId'); // Lấy ID người dùng đã đăng nhập

    if (userId == null) {
      print("⚠️ Không tìm thấy userId trong SharedPreferences");
      return [];
    }

    final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return List<Map<String, dynamic>>.from(data['accounts']);
      } else {
        print("⚠️ API trả về success = false: ${data['message']}");
      }
    } else {
      print("❌ Lỗi HTTP ${response.statusCode}: ${response.body}");
    }
    return [];
  }

  /// 🧩 Thêm tài khoản mới
  Future<bool> addAccount(Map<String, dynamic> account) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) {
      print("⚠️ Không có userId, không thể thêm tài khoản");
      return false;
    }

    final url = Uri.parse('${ApiConfig.baseUrl}/api/bank');
    final body = {...account, 'user_id': userId}; // gắn userId vào dữ liệu gửi

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);
    if (data['success'] == true) {
      print("✅ Đã thêm tài khoản thành công cho user $userId");
      return true;
    } else {
      print("❌ Thêm thất bại: ${data['message']}");
      return false;
    }
  }

  /// 🧩 Sửa tài khoản
  Future<bool> editAccount(int id, Map<String, dynamic> account) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$id');
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(account),
    );
    final data = jsonDecode(response.body);
    return data['success'] == true;
  }

  /// 🧩 Xóa tài khoản
  Future<bool> deleteAccount(int id) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$id');
    final response = await http.delete(url);
    final data = jsonDecode(response.body);
    return data['success'] == true;
  }
}
