import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class BankService {
  // Lấy danh sách tài khoản
  Future<List<Map<String, dynamic>>> getAccounts(int userId) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/api/accounts/$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return List<Map<String, dynamic>>.from(data['accounts']);
        }
      }
    } catch (e) {
      print('Lỗi load accounts: $e');
    }
    return [];
  }

  // Thêm tài khoản mới
  Future<bool> addAccount(Map<String, dynamic> accountData) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/api/accounts');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(accountData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] ?? false;
      }
    } catch (e) {
      print('Lỗi add account: $e');
    }
    return false;
  }

  // Sửa tài khoản
  Future<bool> updateAccount(int accountId, Map<String, dynamic> accountData) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/api/accounts/$accountId');
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(accountData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] ?? false;
      }
    } catch (e) {
      print('Lỗi update account: $e');
    }
    return false;
  }

  // Xóa tài khoản
  Future<bool> deleteAccount(int accountId) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/api/accounts/$accountId');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] ?? false;
      }
    } catch (e) {
      print('Lỗi delete account: $e');
    }
    return false;
  }
}
