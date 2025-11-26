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

class TransactionService {
  final String baseUrl = 'http://localhost:3000/api/transaction';

  // Lấy danh sách giao dịch theo userId
  Future<List<Map<String, dynamic>>> getTransactions({required int? nguoiDungId}) async {
    if (nguoiDungId == null) return [];
    final url = Uri.parse('$baseUrl/$nguoiDungId');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final List data = jsonDecode(resp.body);
      return data.cast<Map<String, dynamic>>();
    }
    return [];
  }

  // Thêm giao dịch mới
  Future<bool> saveTransaction(Map<String, dynamic> tx) async {
    final url = Uri.parse(baseUrl);
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tx),
    );
    return resp.statusCode == 200 || resp.statusCode == 201;
  }

  // Cập nhật giao dịch
  Future<bool> updateTransaction(int id, Map<String, dynamic> tx) async {
    final url = Uri.parse('$baseUrl/$id');
    final resp = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tx),
    );
    return resp.statusCode == 200;
  }

  // Xóa giao dịch
  Future<bool> deleteTransaction(int id) async {
    final url = Uri.parse('$baseUrl/$id');
    final resp = await http.delete(url);
    return resp.statusCode == 200;
  }
}
