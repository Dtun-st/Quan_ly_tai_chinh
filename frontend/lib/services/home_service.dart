// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'api_config.dart';

// class HomeService {
//   // Lấy tài khoản
//   Future<List<Map<String, dynamic>>> fetchTaiKhoan(int userId) async {
//     final url = Uri.parse('${ApiConfig.baseUrl}/api/home/tai_khoan/$userId');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return List<Map<String, dynamic>>.from(data['accounts']).map((tk) {
//         tk['so_du'] = double.tryParse(tk['so_du'].toString()) ?? 0;
//         return tk;
//       }).toList();
//     }
//     return [];
//   }

//   // Lấy giao dịch
//   Future<List<Map<String, dynamic>>> fetchGiaoDich(int userId) async {
//     final url = Uri.parse('${ApiConfig.baseUrl}/api/home/giao_dich/$userId');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return List<Map<String, dynamic>>.from(data['transactions']).map((gd) {
//         gd['so_tien'] = double.tryParse(gd['so_tien'].toString()) ?? 0;
//         return gd;
//       }).toList();
//     }
//     return [];
//   }

//   // Lấy thông báo
//   Future<List<Map<String, dynamic>>> fetchThongBao(int userId) async {
//     final url = Uri.parse('${ApiConfig.baseUrl}/api/home/thong_bao/$userId');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return List<Map<String, dynamic>>.from(data['notifications']);
//     }
//     return [];
//   }

//   // 🔥 Lấy ngân sách tháng hiện tại
//   Future<double?> fetchBudget(int userId) async {
//     final url = Uri.parse('${ApiConfig.baseUrl}/api/home/budget/$userId');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return double.tryParse(data['budget'].toString()) ?? null;
//     }
//     return null;
//   }

//   // 🔥 Lưu / cập nhật ngân sách tháng
//   Future<bool> saveBudget(int userId, double budget) async {
//     final url = Uri.parse('${ApiConfig.baseUrl}/api/home/budget');
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         "userId": userId,
//         "so_tien_gioi_han": budget,
//       }),
//     );

//     return response.statusCode == 200;
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class HomeService {
  static const Map<String, String> _jsonHeader = {
    'Content-Type': 'application/json',
  };

  /// =================================================
  /// TÀI KHOẢN
  /// =================================================
  Future<List<Map<String, dynamic>>> fetchTaiKhoan(int userId) async {
    try {
      final url =
          Uri.parse('${ApiConfig.baseUrl}/api/home/tai_khoan/$userId');
      final response = await http.get(url);

      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      final accounts =
          List<Map<String, dynamic>>.from(data['accounts'] ?? []);

      return accounts.map((acc) {
        acc['so_du'] =
            double.tryParse(acc['so_du']?.toString() ?? '0') ?? 0;
        return acc;
      }).toList();
    } catch (_) {
      return [];
    }
  }

  /// =================================================
  /// GIAO DỊCH GẦN ĐÂY
  /// =================================================
  Future<List<Map<String, dynamic>>> fetchGiaoDich(int userId) async {
    try {
      final url =
          Uri.parse('${ApiConfig.baseUrl}/api/home/giao_dich/$userId');
      final response = await http.get(url);

      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      final transactions =
          List<Map<String, dynamic>>.from(data['transactions'] ?? []);

      return transactions.map((tx) {
        tx['so_tien'] =
            double.tryParse(tx['so_tien']?.toString() ?? '0') ?? 0;
        return tx;
      }).toList();
    } catch (_) {
      return [];
    }
  }

  /// =================================================
  /// THÔNG BÁO
  /// =================================================
  Future<List<Map<String, dynamic>>> fetchThongBao(int userId) async {
    try {
      final url =
          Uri.parse('${ApiConfig.baseUrl}/api/home/thong_bao/$userId');
      final response = await http.get(url);

      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(
        data['notifications'] ?? [],
      );
    } catch (_) {
      return [];
    }
  }

  /// =================================================
  /// NGÂN SÁCH THÁNG
  /// =================================================

  /// Lấy ngân sách tháng hiện tại
  Future<double?> fetchBudget(int userId) async {
    try {
      final url =
          Uri.parse('${ApiConfig.baseUrl}/api/home/budget/$userId');
      final response = await http.get(url);

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      return double.tryParse(data['budget']?.toString() ?? '');
    } catch (_) {
      return null;
    }
  }

  /// Lưu / cập nhật ngân sách tháng
  Future<bool> saveBudget(int userId, double budget) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/api/home/budget');
      final response = await http.post(
        url,
        headers: _jsonHeader,
        body: jsonEncode({
          "userId": userId,
          "so_tien_gioi_han": budget,
        }),
      );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Xoá ngân sách tháng
  Future<bool> deleteBudget(int userId) async {
    try {
      final url =
          Uri.parse('${ApiConfig.baseUrl}/api/home/budget/$userId');
      final response = await http.delete(url);
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
