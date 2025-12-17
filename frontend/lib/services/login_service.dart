// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'api_config.dart';

// class LoginService {
//   Future<Map<String, dynamic>> login({
//     required String emailOrPhone,
//     required String password,
//   }) async {
//     final url = Uri.parse('${ApiConfig.baseUrl}/api/login');

//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "email_or_phone": emailOrPhone,
//         "password": password,
//       }),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);

//       return {
//         "success": data['success'],
//         "message": data['message'],
//         "userId": data['user']?['id'], 
//         "token": data['token'],       
//       };
//     } else {
//       return {
//         "success": false,
//         "message": "Lỗi kết nối server: ${response.statusCode}",
//       };
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class LoginService {
  Future<Map<String, dynamic>> login({
    required String emailOrPhone,
    required String password,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email_or_phone': emailOrPhone,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      return {
        'success': true,
        'message': data['message'],
        'userId': data['user']['id'],
      };
    }

    return {
      'success': false,
      'message': data['message'] ?? 'Đăng nhập thất bại',
    };
  }
}
