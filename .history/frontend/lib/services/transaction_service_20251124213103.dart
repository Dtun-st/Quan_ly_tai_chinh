import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class TransactionService {
  final String baseUrl = 'http://localhost:3000/transactions';

  Future<bool> addTransaction({
    required int userId,
    required int accountId,
    required String type,
    required String categoryName,
    required String amount,
    String? description,
    required String date,
    File? imageFile,               // ảnh dạng File
  }) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse(baseUrl));

      // Gửi text fields
      request.fields['userId'] = userId.toString();
      request.fields['accountId'] = accountId.toString();
      request.fields['type'] = type;
      request.fields['categoryName'] = categoryName;
      request.fields['amount'] = amount;
      request.fields['description'] = description ?? "";
      request.fields['date'] = date;

      // Gửi file ảnh
      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imageFile.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      final response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      print("❌ Lỗi addTransaction: $e");
      return false;
    }
  }
}
