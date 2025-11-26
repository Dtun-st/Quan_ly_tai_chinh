import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

class TransactionService {
  static const String baseUrl = "http://localhost:3000/api"; // đổi theo server

  /// Lấy danh sách giao dịch
  static Future<List<dynamic>> getTransactions(int userId) async {
    final url = Uri.parse("$baseUrl/transactions?userId=$userId");
    final res = await http.get(url);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Lỗi tải giao dịch");
    }
  }

  /// Lưu giao dịch
  static Future<bool> saveTransaction({
    required int userId,
    required int accountId,
    required int categoryId,
    required String type,
    required double amount,
    required String description,
    required DateTime date,
    File? imageFile,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/transactions"),
    );

    request.fields['userId'] = userId.toString();
    request.fields['accountId'] = accountId.toString();
    request.fields['categoryId'] = categoryId.toString();
    request.fields['type'] = type;
    request.fields['amount'] = amount.toString();
    request.fields['description'] = description;
    request.fields['date'] = date.toIso8601String();

    // Upload file nếu có
    if (kIsWeb && imageBytes != null && imageName != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: imageName,
        ),
      );
    } else if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    }

    final res = await request.send();
    return res.statusCode == 200;
  }
}
