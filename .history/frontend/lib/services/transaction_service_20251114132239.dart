import 'dart:convert';
import 'package:http/http.dart' as http;

class TransactionService {
  static const String baseUrl = "http://localhost:3000/api"; // URL backend

  // Tạo giao dịch mới
  static Future<bool> createTransaction(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transactions'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("Lỗi backend: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Lỗi kết nối: $e");
      return false;
    }
  }

  // Lấy danh sách giao dịch
  static Future<List<dynamic>> getTransactions() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/transactions'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print("Lỗi kết nối: $e");
      return [];
    }
  }
}
