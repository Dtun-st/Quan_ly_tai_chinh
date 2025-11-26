// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'api_config.dart';

// class BankService {
//   Future<int?> _getUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getInt('userId');
//   }

//   /// Lấy danh sách tài khoản theo userId
//   Future<List<Map<String, dynamic>>> getAccounts() async {
//     final userId = await _getUserId();
//     if (userId == null) return [];

//     final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$userId');

//     try {
//       final response = await http.get(url);

//       final data = jsonDecode(response.body);

//       if (data['success'] == true) {
//         return List<Map<String, dynamic>>.from(data['accounts']);
//       }
//     } catch (e) {
//       print("🔥 Lỗi getAccounts: $e");
//     }
//     return [];
//   }

//   /// Thêm tài khoản
//   Future<bool> addAccount(Map<String, dynamic> account) async {
//     final userId = await _getUserId();
//     if (userId == null) return false;

//     final url = Uri.parse('${ApiConfig.baseUrl}/api/bank');

//     final body = {
//       "nguoi_dung_id": userId,
//       "ten_tai_khoan": account["ten_tai_khoan"],
//       "loai_tai_khoan": account["loai_tai_khoan"],
//       "so_du": account["so_du"] ?? 0,
//     };

//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(body),
//       );

//       final data = jsonDecode(response.body);

//       return data['success'] == true;
//     } catch (e) {
//       print("🔥 Lỗi addAccount: $e");
//     }

//     return false;
//   }

//   /// Sửa tài khoản
//   Future<bool> editAccount(int id, Map<String, dynamic> account) async {
//     final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$id');

//     final body = {
//       "ten_tai_khoan": account["ten_tai_khoan"],
//       "loai_tai_khoan": account["loai_tai_khoan"],
//       "so_du": account["so_du"],
//     };

//     try {
//       final response = await http.put(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(body),
//       );

//       final data = jsonDecode(response.body);

//       return data['success'] == true;
//     } catch (e) {
//       print("🔥 Lỗi editAccount: $e");
//     }
//     return false;
//   }

//   /// Xóa tài khoản
//   Future<bool> deleteAccount(int id) async {
//     final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$id');

//     try {
//       final response = await http.delete(url);
//       final data = jsonDecode(response.body);

//       return data['success'] == true;
//     } catch (e) {
//       print("🔥 Lỗi deleteAccount: $e");
//     }
//     return false;
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class BankService {
  List<Map<String, dynamic>> _accounts = [];

  List<Map<String, dynamic>> get accounts => _accounts;

  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  /// Load danh sách tài khoản từ server
  Future<void> loadAccounts() async {
    final userId = await _getUserId();
    if (userId == null) return;

    final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$userId');
    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        _accounts = List<Map<String, dynamic>>.from(data['accounts']);
      }
    } catch (e) {
      print("🔥 Lỗi loadAccounts: $e");
    }
  }

  /// Thêm tài khoản và cập nhật state
  Future<bool> addAccount(Map<String, dynamic> account) async {
    final userId = await _getUserId();
    if (userId == null) return false;

    final url = Uri.parse('${ApiConfig.baseUrl}/api/bank');
    final body = {
      "nguoi_dung_id": userId,
      "ten_tai_khoan": account["ten_tai_khoan"],
      "loai_tai_khoan": account["loai_tai_khoan"],
      "so_du": account["so_du"] ?? 0,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        await loadAccounts(); // load lại danh sách sau khi thêm
        return true;
      }
    } catch (e) {
      print("🔥 Lỗi addAccount: $e");
    }
    return false;
  }

  /// Sửa tài khoản và cập nhật state
  Future<bool> editAccount(int id, Map<String, dynamic> account) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$id');
    final body = {
      "ten_tai_khoan": account["ten_tai_khoan"],
      "loai_tai_khoan": account["loai_tai_khoan"],
      "so_du": account["so_du"],
    };

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        // Cập nhật state cục bộ
        _accounts = _accounts.map((acc) {
          if (acc['id'] == id) {
            return {
              ...acc,
              "ten_tai_khoan": account["ten_tai_khoan"],
              "loai_tai_khoan": account["loai_tai_khoan"],
              "so_du": account["so_du"],
            };
          }
          return acc;
        }).toList();
        return true;
      }
    } catch (e) {
      print("🔥 Lỗi editAccount: $e");
    }
    return false;
  }

  /// Xóa tài khoản và cập nhật state
  Future<bool> deleteAccount(int id) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/bank/$id');
    try {
      final response = await http.delete(url);
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        _accounts.removeWhere((acc) => acc['id'] == id);
        return true;
      }
    } catch (e) {
      print("🔥 Lỗi deleteAccount: $e");
    }
    return false;
  }

  /// Cập nhật số dư tài khoản tại chỗ
  void updateBalance(int bankId, double newBalance) {
    for (var account in _accounts) {
      if (account['id'] == bankId) {
        account['so_du'] = newBalance;
        break;
      }
    }
  }
}
