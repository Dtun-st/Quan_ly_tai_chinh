import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ProfileService {
  Future<Map<String, dynamic>?> getProfile(int userId) async {
    try {
      final url = Uri.parse(
        '${ApiConfig.baseUrl}/api/profile/$userId',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) return data['user'];
      }
      return null;
    } catch (e) {
      print("Lỗi fetch profile: $e");
      return null;
    }
  }
}
