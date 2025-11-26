// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'api_config.dart';
// class TransactionService {
//   final String baseUrl = ApiConfig.baseUrl;

//   Future<int?> _getUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getInt('userId');
//     if (userId == null) {
//       print("⚠️ Không tìm thấy userId trong SharedPreferences");
//     }
//     return userId;
//   }

//   Future<List<Map<String, dynamic>>> getTransactions({required int? nguoiDungId}) async {
//     if (nguoiDungId == null) return [];

//     final url = Uri.parse("$baseUrl/api/transaction/$nguoiDungId");
//     final res = await http.get(url);

//     if (res.statusCode == 200) {
//       final body = jsonDecode(res.body);
//       return List<Map<String, dynamic>>.from(body["data"]);
//     }
//     return [];
//   }

//   Future<bool> saveTransaction(Map<String, dynamic> data) async {
//     final url = Uri.parse("$baseUrl/api/transaction");
//     final res = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(data),
//     );

//     return res.statusCode == 200;
//   }

//   Future<bool> updateTransaction(int id, Map<String, dynamic> data) async {
//     final url = Uri.parse("$baseUrl/api/transaction/$id");
//     final res = await http.put(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(data),
//     );

//     return res.statusCode == 200;
//   }

//   Future<bool> deleteTransaction(int id) async {
//     final url = Uri.parse("$baseUrl/api/transaction/$id");
//     final res = await http.delete(url);

//     return res.statusCode == 200;
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class TransactionService {
  final String baseUrl = ApiConfig.baseUrl;

  // Lấy userId từ SharedPreferences
  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) {
      print("⚠️ Không tìm thấy userId trong SharedPreferences");
    }
    return userId;
  }

  // GET danh sách giao dịch
  Future<List<Map<String, dynamic>>> getTransactions({required int? nguoiDungId}) async {
    if (nguoiDungId == null) return [];

    final url = Uri.parse("$baseUrl/api/transaction?userId=$nguoiDungId");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return List<Map<String, dynamic>>.from(body["data"]);
    } else {
      print("❌ GET transactions failed: ${res.statusCode}");
      return [];
    }
  }

  // POST thêm mới
  Future<bool> saveTransaction(Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl/api/transaction");
    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (res.statusCode != 200) {
      print("❌ POST transaction failed: ${res.statusCode}");
    }
    return res.statusCode == 200;
  }

  // PUT cập nhật
  Future<bool> updateTransaction(int id, Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl/api/transaction/$id");
    final res = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (res.statusCode != 200) {
      print("❌ PUT transaction failed: ${res.statusCode}");
    }
    return res.statusCode == 200;
  }

  // DELETE
  Future<bool> deleteTransaction(int id) async {
    final url = Uri.parse("$baseUrl/api/transaction/$id");
    final res = await http.delete(url);

    if (res.statusCode != 200) {
      print("❌ DELETE transaction failed: ${res.statusCode}");
    }
    return res.statusCode == 200;
  }
}
