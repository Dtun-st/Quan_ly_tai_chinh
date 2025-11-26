import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class TransactionService {
  String get baseUrl => '${ApiConfig.baseUrl}/api/transaction';

  /// Lưu giao dịch mới
  Future<bool> saveTransaction(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      final result = jsonDecode(response.body);
      return result['success'] == true;
    } catch (e) {
      print("❌ Lỗi khi lưu giao dịch: $e");
      return false;
    }
  }

  /// Lấy danh sách giao dịch
  Future<List<Map<String, dynamic>>> getTransactions() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        print("❌ HTTP ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      print("❌ Lỗi khi lấy giao dịch: $e");
    }
    return [];
  }
}
