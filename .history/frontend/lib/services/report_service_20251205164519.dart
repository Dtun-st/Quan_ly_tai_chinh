// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'api_config.dart';

// class ReportService {

//   // Lấy báo cáo tháng hiện tại (daily, weekly, monthly)
//   Future<Map<String, Map<String, double>>> getDefaultReport() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getInt('userId');
//     if (userId == null) return {};

//     final url = Uri.parse("${ApiConfig.baseUrl}/api/report?userId=$userId");
//     final res = await http.get(url);

//     if (res.statusCode == 200) {
//       final data = jsonDecode(res.body);
//       return {
//         "daily": Map<String, double>.from(
//           (data['daily'] as Map).map((k, v) => MapEntry(k.toString(), (v as num).toDouble()))
//         ),
//         "weekly": Map<String, double>.from(
//           (data['weekly'] as Map).map((k, v) => MapEntry(k.toString(), (v as num).toDouble()))
//         ),
//         "monthly": Map<String, double>.from(
//           (data['monthly'] as Map).map((k, v) => MapEntry(k.toString(), (v as num).toDouble()))
//         ),
//       };
//     }
//     return {};
//   }

//   // Lấy báo cáo theo 1 tháng cụ thể
//   Future<Map<String, double>> getMonthReport(DateTime date) async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getInt('userId');
//     if (userId == null) return {};

//     final url = Uri.parse(
//         "${ApiConfig.baseUrl}/api/report/month?userId=$userId&month=${date.month}&year=${date.year}"
//     );

//     final res = await http.get(url);
//     if (res.statusCode == 200) {
//       final data = jsonDecode(res.body);
//       final monthData = data['monthData'] ?? {};
//       return Map<String, double>.from(
//         (monthData as Map).map((k, v) => MapEntry(k.toString(), (v as num).toDouble()))
//       );
//     }
//     return {};
//   }

//   // Lấy báo cáo theo khoảng thời gian
//   Future<Map<String, double>> getRangeReport(DateTime start, DateTime end) async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getInt('userId');
//     if (userId == null) return {};

//     final url = Uri.parse(
//         "${ApiConfig.baseUrl}/api/report/range?userId=$userId&start=${start.toIso8601String()}&end=${end.toIso8601String()}"
//     );

//     final res = await http.get(url);
//     if (res.statusCode == 200) {
//       final data = jsonDecode(res.body);
//       final rangeData = data['rangeData'] ?? {};
//       return Map<String, double>.from(
//         (rangeData as Map).map((k, v) => MapEntry(k.toString(), (v as num).toDouble()))
//       );
//     }
//     return {};
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';
class ReportService {
  Future<Map<String, dynamic>> getDefaultReport() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return {};

    final url = Uri.parse("${ApiConfig.baseUrl}/api/report?userId=$userId");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    return {};
  }

  Future<Map<String, dynamic>> getMonth(int month, int year) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return {};

    final url = Uri.parse("${ApiConfig.baseUrl}/api/report/month?userId=$userId&month=$month&year=$year");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    return {};
  }

  Future<Map<String, dynamic>> getRange(String start, String end) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return {};

    final url = Uri.parse("${ApiConfig.baseUrl}/api/report/range?userId=$userId&start=$start&end=$end");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    return {};
  }
}
