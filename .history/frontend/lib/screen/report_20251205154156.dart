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
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTimeRange? _selectedRange;

  // ===== DỮ LIỆU CỨNG (MẪU) =====
  final List<Map<String, dynamic>> mockData = [
    {"month": "01/2025", "income": 12000000, "expense": 8000000},
    {"month": "02/2025", "income": 9000000, "expense": 7500000},
    {"month": "03/2025", "income": 15000000, "expense": 5000000},
    {"month": "04/2025", "income": 11000000, "expense": 9000000},
    {"month": "05/2025", "income": 14000000, "expense": 9500000},
  ];

  String get formattedMonth => DateFormat('MM/yyyy').format(_selectedMonth);
  String get formattedRange {
    if (_selectedRange == null) return "Chưa chọn";
    return "${DateFormat('dd/MM/yyyy').format(_selectedRange!.start)} - ${DateFormat('dd/MM/yyyy').format(_selectedRange!.end)}";
  }

  @override
  Widget build(BuildContext context) {
    // GET DATA THEO THÁNG
    final currentData = mockData.firstWhere(
      (item) => item["month"] == formattedMonth,
      orElse: () => {"income": 0, "expense": 0},
    );

    double income = currentData["income"] * 1.0;
    double expense = currentData["expense"] * 1.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Báo cáo tài chính"),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====== BỘ LỌC ======
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Lọc dữ liệu",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  // Chọn tháng
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Tháng:", style: TextStyle(fontSize: 16)),
                      TextButton(
                        onPressed: () async {
                          final picked = await showMonthPicker(
                            context: context,
                            initialDate: _selectedMonth,
                          );
                          if (picked != null) {
                            setState(() {
                              _selectedMonth = picked;
                              _selectedRange = null; // reset khi chọn tháng
                            });
                          }
                        },
                        child: Text(
                          formattedMonth,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),

                  const Divider(),

                  // Chọn khoảng thời gian
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Khoảng thời gian:", style: TextStyle(fontSize: 16)),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setState(() {
                              _selectedRange = picked;
                            });
                          }
                        },
                        child: Text(
                          formattedRange,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ====== BIỂU ĐỒ THU CHI ======
            const Text(
              "Biểu đồ thu & chi",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  barGroups: [
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(toY: income, color: Colors.green),
                        BarChartRodData(toY: expense, color: Colors.red),
                      ],
                    ),
                  ],
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // **CHÚ THÍCH**
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.square, color: Colors.green, size: 14),
                SizedBox(width: 4),
                Text("Thu nhập"),
                SizedBox(width: 20),
                Icon(Icons.square, color: Colors.red, size: 14),
                SizedBox(width: 4),
                Text("Chi tiêu"),
              ],
            ),

            const SizedBox(height: 20),

            // ====== TỔNG QUAN ======
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  summaryRow("Tổng thu:", income),
                  summaryRow("Tổng chi:", expense),
                  summaryRow("Còn lại:", (income - expense)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget summaryRow(String title, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(
            NumberFormat("#,###").format(value),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// ====== CUSTOM MONTH PICKER ======
Future<DateTime?> showMonthPicker({
  required BuildContext context,
  required DateTime initialDate,
}) async {
  DateTime temp = initialDate;

  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Chọn tháng"),
      content: SizedBox(
        height: 200,
        child: CalendarDatePicker(
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          initialDate: initialDate,
          onDateChanged: (value) => temp = value,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text("Hủy"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context,
              DateTime(temp.year, temp.month)), // chỉ lấy tháng
          child: const Text("Chọn"),
        ),
      ],
    ),
  );
}
