import 'dart:convert';
import 'package:http/http.dart' as http;

class TransactionService {
  final String baseUrl = "http://localhost:3000"; // Node.js backend

  Future<bool> saveTransaction(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transactions'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error saving transaction: $e");
      return false;
    }
  }
}
