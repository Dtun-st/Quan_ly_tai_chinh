import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
class BankService {
  Future<List<Map<String, dynamic>>> getAccounts(int userId) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$userId'); // sửa đây
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return List<Map<String, dynamic>>.from(data['accounts']);
      }
    }
    return [];
  }

  Future<bool> addAccount(Map<String, dynamic> account) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/bank'); // sửa đây
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(account),
    );
    final data = jsonDecode(response.body);
    return data['success'] == true;
  }

  Future<bool> editAccount(int id, Map<String, dynamic> account) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$id'); // sửa đây
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(account),
    );
    final data = jsonDecode(response.body);
    return data['success'] == true;
  }

  Future<bool> deleteAccount(int id) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$id'); // sửa đây
    final response = await http.delete(url);
    final data = jsonDecode(response.body);
    return data['success'] == true;
  }
}
