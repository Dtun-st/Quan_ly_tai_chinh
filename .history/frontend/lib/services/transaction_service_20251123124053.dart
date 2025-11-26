import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'api_config.dart';

class TransactionService {
  /// Lấy danh sách giao dịch của user
  static Future<List<dynamic>> getTransactions(int userId) async {
    final res = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/api/transaction?userId=$userId"),
    );
    if (res.statusCode == 200) {
      return List<dynamic>.from(jsonDecode(res.body));
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
    File? imageFile,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    var uri = Uri.parse("${ApiConfig.baseUrl}/transactions");
    var request = http.MultipartRequest('POST', uri);

    request.fields['userId'] = userId.toString();
    request.fields['tai_khoan_id'] = accountId.toString();
    request.fields['danh_muc_id'] = categoryId.toString();
    request.fields['loai_gd'] = type;
    request.fields['so_tien'] = amount.toString();
    request.fields['mo_ta'] = description ?? "";
    request.fields['ngay_giao_dich'] = (date ?? DateTime.now())
        .toIso8601String();

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'anh_hoa_don',
          imageFile.path,
          filename: basename(imageFile.path),
        ),
      );
    } else if (imageBytes != null && imageName != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'anh_hoa_don',
          imageBytes,
          filename: imageName,
        ),
      );
    }

    var response = await request.send();
    return response.statusCode == 200;
  }

  /// Xóa giao dịch
  static Future<bool> deleteTransaction(int transactionId) async {
    final res = await http.delete(
      Uri.parse("${ApiConfig.baseUrl}/transactions/$transactionId"),
    );
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
    File? imageFile,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    var uri = Uri.parse("${ApiConfig.baseUrl}/transactions/$transactionId");
    var request = http.MultipartRequest('PUT', uri);

    request.fields['tai_khoan_id'] = accountId.toString();
    request.fields['danh_muc_id'] = categoryId.toString();
    request.fields['loai_gd'] = type;
    request.fields['so_tien'] = amount.toString();
    request.fields['mo_ta'] = description ?? "";
    request.fields['ngay_giao_dich'] = (date ?? DateTime.now())
        .toIso8601String();

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'anh_hoa_don',
          imageFile.path,
          filename: basename(imageFile.path),
        ),
      );
    } else if (imageBytes != null && imageName != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'anh_hoa_don',
          imageBytes,
          filename: imageName,
        ),
      );
    }

    var response = await request.send();
    return response.statusCode == 200;
  }
}
