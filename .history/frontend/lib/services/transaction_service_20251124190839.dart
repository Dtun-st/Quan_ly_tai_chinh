import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class TransactionService {
  final String baseUrl = "http://localhost:3000"; // đổi theo server của bạn

  Future<bool> addTransaction({
    required double amount,
    required int accountId,
    required int categoryId,
    required DateTime date,
    String? desc,
    required String type,
    File? receiptFile,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl/transactions/add');
      var request = http.MultipartRequest('POST', uri);

      request.fields['amount'] = amount.toString();
      request.fields['account_id'] = accountId.toString();
      request.fields['category_id'] = categoryId.toString();
      request.fields['date'] = date.toIso8601String();
      request.fields['desc'] = desc ?? '';
      request.fields['type'] = type;

      if (receiptFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'receipt',
          receiptFile.path,
          filename: basename(receiptFile.path),
        ));
      }

      var response = await request.send();
      if (response.statusCode == 200) return true;
      return false;
    } catch (e) {
      print("Upload error: $e");
      return false;
    }
  }
}
