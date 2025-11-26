// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'api_config.dart';

// class BankService {
//   Future<int?> _getUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getInt('userId');
//     if (userId == null) {
//       print("Không tìm thấy userId trong SharedPreferences");
//     }
//     return userId;
//   }

//   Future<List<Map<String, dynamic>>> getAccounts() async {
//     final userId = await _getUserId();
//     if (userId == null) return [];

//     final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$userId');
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success'] == true) {
//           return List<Map<String, dynamic>>.from(data['accounts']);
//         } else {
//           print(" API trả về success=false: ${data['message']}");
//         }
//       } else {
//         print(" HTTP ${response.statusCode}: ${response.body}");
//       }
//     } catch (e) {
//       print(" Lỗi khi gọi API getAccounts: $e");
//     }
//     return [];
//   }

//   Future<bool> addAccount(Map<String, dynamic> account) async {
//     final userId = await _getUserId();
//     if (userId == null) return false;

//     final url = Uri.parse('${ApiConfig.baseUrl}/api/bank');
//     final body = {...account, 'user_id': userId};

//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(body),
//       );
//       final data = jsonDecode(response.body);
//       if (data['success'] == true) {
//         print(" Thêm tài khoản thành công cho user $userId");
//         return true;
//       } else {
//         print(" Thêm thất bại: ${data['message']}");
//         return false;
//       }
//     } catch (e) {
//       print(" Lỗi khi gọi API addAccount: $e");
//       return false;
//     }
//   }

//   Future<bool> editAccount(int id, Map<String, dynamic> account) async {
//     final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$id');
//     try {
//       final response = await http.put(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(account),
//       );
//       final data = jsonDecode(response.body);
//       return data['success'] == true;
//     } catch (e) {
//       print("Lỗi khi gọi API editAccount: $e");
//       return false;
//     }
//   }

//   Future<bool> deleteAccount(int id) async {
//     final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$id');
//     try {
//       final response = await http.delete(url);
//       final data = jsonDecode(response.body);
//       return data['success'] == true;
//     } catch (e) {
//       print("Lỗi khi gọi API deleteAccount: $e");
//       return false;
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class BankService {
  /// Lấy userId hiện tại từ SharedPreferences
  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) {
      print("Không tìm thấy userId trong SharedPreferences");
    }
    return userId;
  }

  /// Lấy danh sách tài khoản của user
  Future<List<Map<String, dynamic>>> getAccounts() async {
    final userId = await _getUserId();
    if (userId == null) return [];

    final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return List<Map<String, dynamic>>.from(data['accounts']);
        } else {
          print("API trả về success=false: ${data['message']}");
        }
      } else {
        print("HTTP ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      print("Lỗi khi gọi API getAccounts: $e");
    }
    return [];
  }

  /// Thêm tài khoản
  Future<bool> addAccount(Map<String, dynamic> account) async {
    final userId = await _getUserId();
    if (userId == null) return false;

    final url = Uri.parse('${ApiConfig.baseUrl}/api/bank');
    final body = {
      ...account,
      'nguoi_dung_id': userId, // tên trường trùng với DB
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
      print("Lỗi khi gọi API addAccount: $e");
      return false;
    }
  }

  /// Sửa tài khoản
  Future<bool> editAccount(int id, Map<String, dynamic> account) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$id');
    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(account),
      );
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      print("Lỗi khi gọi API editAccount: $e");
      return false;
    }
  }

  /// Xóa tài khoản
  Future<bool> deleteAccount(int id) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$id');
    try {
      final response = await http.delete(url);
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      print("Lỗi khi gọi API deleteAccount: $e");
      return false;
    }
  }
}
