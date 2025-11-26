import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class BankService {
  // Lấy danh sách tài khoản của người dùng
  Future<List<Map<String, dynamic>>> getAccounts(int userId) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return List<Map<String, dynamic>>.from(data['accounts']);
      }
    }
    return [];
  }

  // Thêm tài khoản
  Future<bool> addAccount(Map<String, dynamic> account) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/bank');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(account),
    );
    final data = jsonDecode(response.body);
    return data['success'] == true;
  }

  // Sửa tài khoản
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

  // Xóa tài khoản
  Future<bool> deleteAccount(int id) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$id');
    final response = await http.delete(url);
    final data = jsonDecode(response.body);
    return data['success'] == true;
  }
}
