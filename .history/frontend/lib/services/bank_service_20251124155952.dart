import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class BankService {
  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  /// Lấy danh sách tài khoản theo userId
  Future<List<Map<String, dynamic>>> getAccounts() async {
    final userId = await _getUserId();
    if (userId == null) return [];

    final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$userId');

    try {
      final response = await http.get(url);

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        return List<Map<String, dynamic>>.from(data['accounts']);
      }
    } catch (e) {
      print("🔥 Lỗi getAccounts: $e");
    }
    return [];
  }

  /// Thêm tài khoản
  Future<bool> addAccount(Map<String, dynamic> account) async {
    final userId = await _getUserId();
    if (userId == null) return false;

    final url = Uri.parse('${ApiConfig.baseUrl}/api/bank');

    final body = {
      "nguoi_dung_id": userId,
      "ten_tai_khoan": account["ten_tai_khoan"],
      "loai_tai_khoan": account["loai_tai_khoan"],
      "so_du": account["so_du"] ?? 0,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      return data['success'] == true;
    } catch (e) {
      print("🔥 Lỗi addAccount: $e");
    }

    return false;
  }

  /// Sửa tài khoản
  Future<bool> editAccount(int id, Map<String, dynamic> account) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$id');

    final body = {
      "ten_tai_khoan": account["ten_tai_khoan"],
      "loai_tai_khoan": account["loai_tai_khoan"],
      "so_du": account["so_du"],
    };

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      return data['success'] == true;
    } catch (e) {
      print("🔥 Lỗi editAccount: $e");
    }
    return false;
  }

  /// Xóa tài khoản
  Future<bool> deleteAccount(int id) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$id');

    try {
      final response = await http.delete(url);
      final data = jsonDecode(response.body);

      return data['success'] == true;
    } catch (e) {
      print("🔥 Lỗi deleteAccount: $e");
    }
    return false;
  }
}
