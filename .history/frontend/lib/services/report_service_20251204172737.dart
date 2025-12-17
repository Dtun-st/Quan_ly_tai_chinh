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
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/report_service.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final ReportService _service = ReportService();

  Map<String, double> chartData = {};
  DateTime? startDate;
  DateTime? endDate;
  bool loading = false;
  String selectedFilter = "monthly";

  @override
  void initState() {
    super.initState();
    _loadFixedData();
  }

  Future<void> _loadFixedData() async {
    setState(() => loading = true);
    final data = await _service.getFixedReport(selectedFilter);
    setState(() {
      chartData = data;
      loading = false;
    });
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      startDate = picked.start;
      endDate = picked.end;
      _loadRangeData();
    }
  }

  Future<void> _loadRangeData() async {
    setState(() => loading = true);
    final data = await _service.getRangeReport(
      startDate!.toIso8601String(),
      endDate!.toIso8601String(),
    );
    setState(() {
      selectedFilter = "custom";
      chartData = data;
      loading = false;
    });
  }

  void _applyPreset(String type) {
    setState(() => selectedFilter = type);
    _loadFixedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Báo cáo tài chính"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 12),
                _buildFilterButtons(),
                const SizedBox(height: 12),
                if (selectedFilter == "custom") _buildRangeInfo(),
                const SizedBox(height: 8),
                Expanded(child: _buildChart()),
              ],
            ),
    );
  }

  Widget _buildFilterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _filterBtn("Ngày", "daily"),
        _filterBtn("Tuần", "weekly"),
        _filterBtn("Tháng", "monthly"),
        ElevatedButton(
          onPressed: _selectDateRange,
          child: const Text("Chọn ngày"),
        ),
      ],
    );
  }

  Widget _filterBtn(String label, String type) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () => _applyPreset(type),
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedFilter == type ? Colors.orange : Colors.grey,
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildRangeInfo() {
    return Text(
      "Từ: ${DateFormat('dd/MM').format(startDate!)} - Đến: ${DateFormat('dd/MM').format(endDate!)}",
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildChart() {
    if (chartData.isEmpty) {
      return const Center(child: Text("Không có dữ liệu"));
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final key = chartData.keys.elementAt(value.toInt());
                  return Text(key, style: const TextStyle(fontSize: 10));
                },
              ),
            ),
          ),
          barGroups: _createBars(),
        ),
      ),
    );
  }

  List<BarChartGroupData> _createBars() {
    return List.generate(chartData.length, (index) {
      final value = chartData.values.elementAt(index);
      return BarChartGroupData(x: index, barRods: [BarChartRodData(toY: value)]);
    });
  }
}