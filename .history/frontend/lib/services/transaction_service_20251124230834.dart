// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'api_config.dart';

// class TransactionService {
//   Future<bool> addTransaction({
//     required int userId,
//     required int accountId,
//     required String type,
//     required String categoryName,
//     required String amount,
//     String? description,
//     required String date,
//     File? imageFile,         // Mobile
//     Uint8List? imageBytes,   // Web
//   }) async {
//     try {
//       final uri = Uri.parse('${ApiConfig.baseUrl}/transactions');
//       final request = http.MultipartRequest("POST", uri);

//       // Text fields
//       request.fields['userId'] = userId.toString();
//       request.fields['accountId'] = accountId.toString();
//       request.fields['type'] = type;
//       request.fields['categoryName'] = categoryName;
//       request.fields['amount'] = amount;
//       request.fields['description'] = description ?? "";
//       request.fields['date'] = date;

//       // File
//       if (kIsWeb && imageBytes != null) {
//         request.files.add(
//           http.MultipartFile.fromBytes(
//             'billImage',
//             imageBytes,
//             filename: 'bill.jpg',
//             contentType: MediaType('image', 'jpeg'),
//           ),
//         );
//       } else if (!kIsWeb && imageFile != null) {
//         request.files.add(
//           await http.MultipartFile.fromPath(
//             'billImage',
//             imageFile.path,
//             contentType: MediaType('image', 'jpeg'),
//           ),
//         );
//       }

//       final response = await request.send();
//       return response.statusCode == 200;
//     } catch (e) {
//       print('❌ addTransaction error: $e');
//       return false;
//     }
//   }
// }
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'api_config.dart';

class TransactionService {
  Future<bool> addTransaction({
    required int userId,
    required int accountId,
    required int danhMucId,
    required String type,
    required String amount,
    String? description,
    required String date,
    File? imageFile,
    Uint8List? imageBytes,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/api/transaction');
      final request = http.MultipartRequest("POST", uri);

      // Fields
      request.fields['userId'] = userId.toString();
      request.fields['accountId'] = accountId.toString();
      request.fields['danhMucId'] = danhMucId.toString();
      request.fields['type'] = type;
      request.fields['amount'] = amount;
      request.fields['description'] = description ?? '';
      request.fields['date'] = date;

      // File upload
      if (kIsWeb && imageBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'billImage',
          imageBytes,
          filename: 'bill.jpg',
          contentType: MediaType('image', 'jpeg'),
        ));
      } else if (!kIsWeb && imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'billImage',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      final response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      print('❌ addTransaction error: $e');
      return false;
    }
  }
}
