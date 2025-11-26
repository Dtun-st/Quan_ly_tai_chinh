// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'api_config.dart';

// class TransactionService {
//   String get baseUrl => '${ApiConfig.baseUrl}/api/transaction';

//   /// 🧩 Lưu giao dịch mới
//   Future<bool> saveTransaction(Map<String, dynamic> data) async {
//     try {
//       final response = await http.post(
//         Uri.parse(baseUrl),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(data),
//       );

//       if (response.statusCode == 200) {
//         final result = jsonDecode(response.body);
//         return result['success'] == true;
//       } else {
//         print("❌ HTTP ${response.statusCode}: ${response.body}");
//         return false;
//       }
//     } catch (e) {
//       print("❌ Lỗi khi lưu giao dịch: $e");
//       return false;
//     }
//   }

//   /// 🧩 Lấy danh sách giao dịch
//   Future<List<Map<String, dynamic>>> getTransactions({int? nguoiDungId}) async {
//     try {
//       var url = Uri.parse(baseUrl);
//       if (nguoiDungId != null) {
//         url = url.replace(queryParameters: {'nguoiDungId': nguoiDungId.toString()});
//       }

//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data is List) {
//           // map lại key backend -> key Flutter
//           return List<Map<String, dynamic>>.from(data).map((tx) {
//             return {
//               'amount': tx['so_tien'],
//               'type': tx['loai_gd'],
//               'desc': tx['mo_ta'],
//               'date': tx['ngay_giao_dich'],
//               'accountId': tx['tai_khoan_id'],
//               'categoryId': tx['han_muc_id'],
//             };
//           }).toList();
//         }
//       } else {
//         print("❌ HTTP ${response.statusCode}: ${response.body}");
//       }
//     } catch (e) {
//       print("❌ Lỗi khi lấy giao dịch: $e");
//     }
//     return [];
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';
class TransactionService {
  final String baseUrl = ApiConfig.baseUrl;

  /// 🧩 Lấy userId từ SharedPreferences
  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) {
      print("⚠️ Không tìm thấy userId trong SharedPreferences");
    }
    return userId;
  }

  /// 📌 Lấy danh sách giao dịch
  Future<List<Map<String, dynamic>>> getTransactions({required int? nguoiDungId}) async {
    if (nguoiDungId == null) return [];

    final url = Uri.parse("$baseUrl/api/transaction/$nguoiDungId");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return List<Map<String, dynamic>>.from(body["data"]);
    }
    return [];
  }

  /// 📌 Thêm giao dịch
  Future<bool> saveTransaction(Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl/api/transaction");
    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    return res.statusCode == 200;
  }

  /// 📌 Cập nhật giao dịch
  Future<bool> updateTransaction(int id, Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl/api/transaction/$id");
    final res = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    return res.statusCode == 200;
  }

  /// 📌 Xóa giao dịch
  Future<bool> deleteTransaction(int id) async {
    final url = Uri.parse("$baseUrl/api/transaction/$id");
    final res = await http.delete(url);

    return res.statusCode == 200;
  }
}
