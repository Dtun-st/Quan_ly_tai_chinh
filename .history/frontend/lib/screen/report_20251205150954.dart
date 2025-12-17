// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../services/report_service.dart';
// import 'bottom_nav.dart'; 

// class ReportScreen extends StatefulWidget {
//   const ReportScreen({super.key});

//   @override
//   State<ReportScreen> createState() => _ReportScreenState();
// }

// class _ReportScreenState extends State<ReportScreen> {
//   final ReportService _service = ReportService();

//   Map<String, double> monthlyData = {};
//   Map<String, double> weeklyData = {};
//   Map<String, double> dailyData = {};
//   bool isLoading = true;
//   String? errorMsg;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     try {
//       final month = await _service.getReport('monthly');
//       final week = await _service.getReport('weekly');
//       final day = await _service.getReport('daily');

//       setState(() {
//         monthlyData = month;
//         weeklyData = week;
//         dailyData = day;
//         isLoading = false;
//         if (month.isEmpty && week.isEmpty && day.isEmpty) {
//           errorMsg = "Chưa có dữ liệu báo cáo";
//         }
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         errorMsg = "Lỗi khi tải báo cáo: $e";
//       });
//     }
//   }

//   Color getColorForCategory(String category) {
//     switch (category) {
//       case "Ăn uống":
//       case "Food":
//         return Colors.deepOrange;
//       case "Di chuyển":
//       case "Transport":
//         return Colors.blue;
//       case "Hóa đơn":
//       case "Bills":
//         return Colors.green;
//       case "Mua sắm":
//       case "Shopping":
//         return Colors.purple;
//       case "Giải trí":
//       case "Entertainment":
//         return Colors.red;
//       case "Thu":
//         return Colors.greenAccent;
//       case "Chi":
//         return Colors.deepOrange;
//       default:
//         return Colors.grey;
//     }
//   }

//   Widget buildLegend(Map<String, double> dataMap) {
//     return Column(
//       children: dataMap.keys.map((key) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 4),
//           child: Row(
//             children: [
//               Container(
//                 width: 18,
//                 height: 18,
//                 decoration: BoxDecoration(
//                   color: getColorForCategory(key),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Text(key, style: const TextStyle(fontSize: 16)),
//               const Spacer(),
//               Text("${dataMap[key]!.toStringAsFixed(0)} đ",
//                   style: const TextStyle(fontWeight: FontWeight.bold)),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (errorMsg != null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text("Báo cáo chi tiêu"),
//           backgroundColor: Colors.deepOrange,
//           centerTitle: true,
//         ),
//         body: Center(
//             child: Text(errorMsg!, style: const TextStyle(fontSize: 18))),
//         bottomNavigationBar:
//             const CustomBottomNav(currentIndex: 3), // ✅ BottomNav luôn hiển thị
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Báo cáo chi tiêu"),
//         backgroundColor: Colors.deepOrange,
//         centerTitle: true,
//       ),
//       bottomNavigationBar:
//           const CustomBottomNav(currentIndex: 3), // ✅ gọi CustomBottomNav
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             if (monthlyData.isNotEmpty)
//               buildBarChart(monthlyData, "Chi tiêu tháng"),
//             if (weeklyData.isNotEmpty)
//               buildPieChart(weeklyData, "Chi tiêu tuần"),
//             if (dailyData.isNotEmpty)
//               buildPieChart(dailyData, "Chi tiêu ngày"),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildBarChart(Map<String, double> data, String title) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       margin: const EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: const [
//           BoxShadow(
//               color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title,
//               style:
//                   const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 10),
//           SizedBox(
//             height: 200,
//             child: BarChart(
//               BarChartData(
//                 alignment: BarChartAlignment.spaceAround,
//                 maxY: (data.values.isNotEmpty)
//                     ? data.values.reduce((a, b) => a > b ? a : b) * 1.2
//                     : 100,
//                 barTouchData: BarTouchData(enabled: false),
//                 titlesData: FlTitlesData(
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       interval: (data.values.isNotEmpty)
//                           ? data.values.reduce((a, b) => a > b ? a : b) / 5
//                           : 100,
//                       getTitlesWidget: (value, meta) =>
//                           Text("${value.toStringAsFixed(0)}"),
//                     ),
//                   ),
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       getTitlesWidget: (value, meta) {
//                         final index = value.toInt();
//                         if (index < 0 || index >= data.keys.length)
//                           return const SizedBox();
//                         final key = data.keys.elementAt(index);
//                         return Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: Text(key, style: const TextStyle(fontSize: 12)),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 barGroups: List.generate(data.length, (index) {
//                   final key = data.keys.elementAt(index);
//                   return BarChartGroupData(
//                     x: index,
//                     barRods: [
//                       BarChartRodData(
//                           toY: data[key]!,
//                           color: getColorForCategory(key),
//                           width: 20)
//                     ],
//                   );
//                 }),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           buildLegend(data),
//         ],
//       ),
//     );
//   }

//   Widget buildPieChart(Map<String, double> data, String title) {
//     final total =
//         data.values.fold<double>(0, (prev, element) => prev + element);
//     return Container(
//       padding: const EdgeInsets.all(20),
//       margin: const EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))
//         ],
//       ),
//       child: Column(
//         children: [
//           Text(title,
//               style:
//                   const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 10),
//           SizedBox(
//             height: 180,
//             child: PieChart(
//               PieChartData(
//                 sections: data.entries.map((e) {
//                   final percent = total > 0 ? e.value / total * 100 : 0;
//                   return PieChartSectionData(
//                     color: getColorForCategory(e.key),
//                     value: e.value,
//                     radius: 50,
//                     title: "${percent.toStringAsFixed(1)}%",
//                     titleStyle: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           buildLegend(data),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/report_service.dart';
import 'bottom_nav.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final ReportService _service = ReportService();

  Map<String, double> monthlyData = {};
  Map<String, double> weeklyData = {};
  Map<String, double> dailyData = {};
  bool isLoading = true;
  String? errorMsg;

  DateTimeRange? selectedRange;
  Map<String, double> rangeData = {}; // Dữ liệu tùy chọn thời gian sau này

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final month = await _service.getReport('monthly');
      final week = await _service.getReport('weekly');
      final day = await _service.getReport('daily');

      setState(() {
        monthlyData = month;
        weeklyData = week;
        dailyData = day;
        isLoading = false;
        if (month.isEmpty && week.isEmpty && day.isEmpty) {
          errorMsg = "Chưa có dữ liệu báo cáo";
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMsg = "Lỗi khi tải báo cáo: $e";
      });
    }
  }

  Color getColorForCategory(String category) {
    switch (category) {
      case "Ăn uống":
      case "Food":
        return Colors.deepOrange;
      case "Di chuyển":
      case "Transport":
        return Colors.blue;
      case "Hóa đơn":
      case "Bills":
        return Colors.green;
      case "Mua sắm":
      case "Shopping":
        return Colors.purple;
      case "Giải trí":
      case "Entertainment":
        return Colors.red;
      case "Thu":
        return Colors.greenAccent;
      case "Chi":
        return Colors.deepOrange;
      default:
        return Colors.grey;
    }
  }

  Widget buildLegend(Map<String, double> dataMap) {
    return Column(
      children: dataMap.keys.map((key) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: getColorForCategory(key),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Text(key, style: const TextStyle(fontSize: 16)),
              const Spacer(),
              Text("${dataMap[key]!.toStringAsFixed(0)} đ",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMsg != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Báo cáo chi tiêu"),
          backgroundColor: Colors.deepOrange,
          centerTitle: true,
        ),
        body: Center(
            child: Text(errorMsg!, style: const TextStyle(fontSize: 18))),
        bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Báo cáo chi tiêu"),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===============================
            // 📍 GIAO DIỆN CHỌN KHOẢNG THỜI GIAN
            // ===============================
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Chọn khoảng thời gian",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final DateTimeRange? result = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (result != null) {
                        setState(() => selectedRange = result);
                      }
                    },
                    icon: const Icon(Icons.calendar_month),
                    label: const Text("Chọn thời gian"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (selectedRange != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${selectedRange!.start.day}/${selectedRange!.start.month}/${selectedRange!.start.year}  →  "
                        "${selectedRange!.end.day}/${selectedRange!.end.month}/${selectedRange!.end.year}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                      ),
                    ),

                  const SizedBox(height: 14),
                  const Text(
                    "⚠ Dữ liệu chưa được tải. Tính năng sẽ hoạt động khi tích hợp API.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            // ===============================
            // 📊 CÁC BIỂU ĐỒ MẶC ĐỊNH
            // ===============================
            if (monthlyData.isNotEmpty)
              buildBarChart(monthlyData, "Chi tiêu tháng"),
            if (weeklyData.isNotEmpty)
              buildPieChart(weeklyData, "Chi tiêu tuần"),
            if (dailyData.isNotEmpty)
              buildPieChart(dailyData, "Chi tiêu ngày"),
          ],
        ),
      ),
    );
  }

  Widget buildBarChart(Map<String, double> data, String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: (data.values.isNotEmpty)
                    ? data.values.reduce((a, b) => a > b ? a : b) * 1.2
                    : 100,
                barGroups: List.generate(data.length, (index) {
                  final key = data.keys.elementAt(index);
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                          toY: data[key]!,
                          color: getColorForCategory(key),
                          width: 20)
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 10),
          buildLegend(data),
        ],
      ),
    );
  }

  Widget buildPieChart(Map<String, double> data, String title) {
    final total =
        data.values.fold<double>(0, (prev, element) => prev + element);
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))
        ],
      ),
      child: Column(
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sections: data.entries.map((e) {
                  final percent = total > 0 ? e.value / total * 100 : 0;
                  return PieChartSectionData(
                    color: getColorForCategory(e.key),
                    value: e.value,
                    radius: 50,
                    title: "${percent.toStringAsFixed(1)}%",
                    titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          buildLegend(data),
        ],
      ),
    );
  }
}
