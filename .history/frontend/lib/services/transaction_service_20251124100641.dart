// import 'dart:io';
// import 'dart:typed_data';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'api_config.dart';

// class TransactionService {
//   static Future<List<dynamic>> getTransactions(int userId) async {
//     final url = Uri.parse('${ApiConfig.baseUrl}/api/transactions/$userId');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body) as List<dynamic>;
//     } else {
//       throw Exception('Failed to load transactions');
//     }
//   }

//   static Future<bool> saveTransaction({
//     required int userId,
//     required int accountId,
//     required String type,
//     required String categoryName,
//     required double amount,
//     String? description,
//     required DateTime date,
//     File? imageFile,
//     Uint8List? imageBytes,
//     String? imageName,
//   }) async {
//     final url = Uri.parse('${ApiConfig.baseUrl}/api/transactions');
//     var request = http.MultipartRequest('POST', url);

//     request.fields['userId'] = userId.toString();
//     request.fields['accountId'] = accountId.toString();
//     request.fields['type'] = type;
//     request.fields['categoryName'] = categoryName;
//     request.fields['amount'] = amount.toString();
//     request.fields['description'] = description ?? '';
//     request.fields['date'] = date.toIso8601String();

//     if (imageFile != null) {
//       request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
//     } else if (imageBytes != null && imageName != null) {
//       request.files.add(http.MultipartFile.fromBytes('image', imageBytes, filename: imageName));
//     }

//     final streamedResponse = await request.send();
//     final response = await http.Response.fromStream(streamedResponse);

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['success'] == true;
//     }
//     return false;
//   }
// }
