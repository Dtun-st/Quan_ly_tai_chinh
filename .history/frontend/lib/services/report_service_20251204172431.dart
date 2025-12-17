// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'api_config.dart';

// class ReportService {
//   Future<Map<String, double>> getReport(String type) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final userId = prefs.getInt('userId');
//       if (userId == null) {
//         print(" UserId chưa được lưu trong SharedPreferences");
//         return {};
//       }

//       final url = Uri.parse('${ApiConfig.baseUrl}/api/report?userId=$userId');
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success'] == true && data != null) {
//           final report = data;
//           Map<String, dynamic> raw = {};
//           switch (type) {
//             case 'daily':
//               raw = report['daily'] ?? {};
//               break;
//             case 'weekly':
//               raw = report['weekly'] ?? {};
//               break;
//             case 'monthly':
//               raw = report['monthly'] ?? {};
//               break;
//             default:
//               raw = {};
//           }
//           return raw.map((key, value) => MapEntry(key, (value as num).toDouble()));
//         } else {
//           print(" Backend trả về lỗi hoặc report null: $data");
//         }
//       } else {
//         print(" HTTP ${response.statusCode}: ${response.body}");
//       }
//     } catch (e) {
//       print(" Lỗi khi lấy báo cáo: $e");
//     }
//     return {};
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';
class ReportService {
  Future<Map<String, double>> getReportByDateRange(DateTime start, DateTime end) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      final url = Uri.parse(
        "${ApiConfig.baseUrl}/api/report/range?userId=$userId&start=${start.toIso8601String()}&end=${end.toIso8601String()}"
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        if (result['success'] == true) {
          return (result['data'] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, (value as num).toDouble()));
        }
      }
    } catch (e) {
      print("Lỗi lấy báo cáo khoảng thời gian: $e");
    }

    return {};
  }

  Future<Map<String, double>> getDailyReport() async {
    return _fetchFixedReport("daily");
  }

  Future<Map<String, double>> getWeeklyReport() async {
    return _fetchFixedReport("weekly");
  }

  Future<Map<String, double>> getMonthlyReport() async {
    return _fetchFixedReport("monthly");
  }

  Future<Map<String, double>> _fetchFixedReport(String filter) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      final url = Uri.parse(
        "${ApiConfig.baseUrl}/api/report?userId=$userId&filter=$filter"
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        if (result['success'] == true) {
          return (result['data'] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, (value as num).toDouble()));
        }
      }
    } catch (e) {
      print("Lỗi lấy báo cáo $filter: $e");
    }

    return {};
  }
}
