import 'dart:convert';
import 'package:http/http.dart' as http;

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
    String? base64Image,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'accountId': accountId,
          'type': type,
          'categoryName': categoryName,
          'amount': amount,
          'description': description,
          'date': date,
          'image': base64Image,
        }),
      );
      return res.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
