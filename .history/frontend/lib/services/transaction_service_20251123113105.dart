import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class TransactionService {
  static const String baseUrl = "http://10.0.2.2:3000"; // Android emulator localhost

  /// Lấy danh sách giao dịch của user
  static Future<List<dynamic>> getTransactions(int userId) async {
    final res = await http.get(Uri.parse("$baseUrl/transactions?userId=$userId"));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to load transactions");
    }
  }

  /// Thêm giao dịch mới
  static Future<bool> saveTransaction({
    required int userId,
    required int accountId,
    required int categoryId,
    required String type,
    required double amount,
    String? description,
    DateTime? date,
    File? image,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/transactions"));
    request.fields['userId'] = userId.toString();
    request.fields['tai_khoan_id'] = accountId.toString();
    request.fields['danh_muc_id'] = categoryId.toString();
    request.fields['loai_gd'] = type;
    request.fields['so_tien'] = amount.toString();
    request.fields['mo_ta'] = description ?? "";
    request.fields['ngay_giao_dich'] = (date ?? DateTime.now()).toIso8601String();

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'anh_hoa_don',
        image.path,
        filename: basename(image.path),
      ));
    }

    var response = await request.send();
    return response.statusCode == 200;
  }

  /// Xóa giao dịch theo id
  static Future<bool> deleteTransaction(int transactionId) async {
    final res = await http.delete(Uri.parse("$baseUrl/transactions/$transactionId"));
    return res.statusCode == 200;
  }

  /// Cập nhật giao dịch
  static Future<bool> updateTransaction({
    required int transactionId,
    required int accountId,
    required int categoryId,
    required String type,
    required double amount,
    String? description,
    DateTime? date,
    File? image,
  }) async {
    var request = http.MultipartRequest('PUT', Uri.parse("$baseUrl/transactions/$transactionId"));
    request.fields['tai_khoan_id'] = accountId.toString();
    request.fields['danh_muc_id'] = categoryId.toString();
    request.fields['loai_gd'] = type;
    request.fields['so_tien'] = amount.toString();
    request.fields['mo_ta'] = description ?? "";
    request.fields['ngay_giao_dich'] = (date ?? DateTime.now()).toIso8601String();

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'anh_hoa_don',
        image.path,
        filename: basename(image.path),
      ));
    }

    var response = await request.send();
    return response.statusCode == 200;
  }
}
