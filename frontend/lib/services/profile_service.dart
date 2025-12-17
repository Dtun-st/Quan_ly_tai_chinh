// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'api_config.dart';

// class ProfileService {
//   Future<Map<String, dynamic>?> getProfile(int userId) async {
//     try {
//       final url =
//           Uri.parse('${ApiConfig.baseUrl}/api/profile/$userId');

//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return data['user'];
//       }
//     } catch (e) {
//       print('Profile error: $e');
//     }
//     return null;
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ProfileService {
  // Lấy thông tin profile
  Future<Map<String, dynamic>?> getProfile(int userId) async {
    try {
      final url =
          Uri.parse('${ApiConfig.baseUrl}/api/profile/$userId');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['user'];
      }
    } catch (e) {
      print('Get profile error: $e');
    }
    return null;
  }

  // Cập nhật profile
  Future<bool> updateProfile({
    required int userId,
    required String name,
    required String phone,
  }) async {
    try {
      final url =
          Uri.parse('${ApiConfig.baseUrl}/api/profile/$userId');

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'phone': phone,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }
}
