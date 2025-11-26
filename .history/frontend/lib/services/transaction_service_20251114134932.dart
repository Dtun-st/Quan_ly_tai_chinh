import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class TransactionService {
  String get baseUrl => '${ApiConfig.baseUrl}/api/transaction';

  /// 🧩 Lưu giao dịch mới
  Future<bool> saveTransaction(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl), // chỉ cần baseUrl, không thêm /transactions
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result['success'] == true;
      } else {
        print("❌ HTTP ${response.statusCode}: ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Lỗi khi lưu giao dịch: $e");
      return false;
    }
  }

  /// 🧩 Lấy danh sách giao dịch
  Future<List<Map<String, dynamic>>> getTransactions() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Nếu backend trả về { success: true, transactions: [...] }
        if (data is Map && data['success'] == true) {
          return List<Map<String, dynamic>>.from(data['transactions']);
        }
        // Nếu backend trả trực tiếp danh sách giao dịch
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        }
        print("⚠️ Dữ liệu nhận về không hợp lệ: $data");
      } else {
        print("❌ HTTP ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      print("❌ Lỗi khi lấy giao dịch: $e");
    }
    return [];
  }
}
