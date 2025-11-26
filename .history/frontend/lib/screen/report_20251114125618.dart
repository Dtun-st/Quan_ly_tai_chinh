// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:frontend/screen/bottom_nav.dart';

// class ReportScreen extends StatelessWidget {
//   const ReportScreen({super.key});

//   final List<Map<String, dynamic>> data = const [
//     {"category": "Ăn uống", "amount": 500000, "color": Colors.orange},
//     {"category": "Di chuyển", "amount": 300000, "color": Colors.blue},
//     {"category": "Giải trí", "amount": 200000, "color": Colors.green},
//     {"category": "Mua sắm", "amount": 400000, "color": Colors.purple},
//     {"category": "Học tập", "amount": 150000, "color": Colors.red},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     double total = data.fold(0, (sum, item) => sum + (item['amount'] as int).toDouble());

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Báo cáo chi tiêu'),
//         backgroundColor: Colors.orange,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Tổng chi tiêu
//             Text(
//               'Tổng chi tiêu: ${total.toStringAsFixed(0)} VND',
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),

//             // Pie chart
//             SizedBox(
//               height: 250,
//               child: PieChart(
//                 PieChartData(
//                   sections: data.map((item) {
//                     final double percent = (item['amount'] as int).toDouble() / total * 100;
//                     return PieChartSectionData(
//                       color: item['color'] as Color,
//                       value: (item['amount'] as int).toDouble(),
//                       title: '${percent.toStringAsFixed(1)}%',
//                       radius: 60,
//                       titleStyle: const TextStyle(
//                           fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
//                     );
//                   }).toList(),
//                   sectionsSpace: 2,
//                   centerSpaceRadius: 40,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Danh sách chi tiết
//             Expanded(
//               child: ListView(
//                 children: data.map((item) {
//                   final double percent = (item['amount'] as int).toDouble() / total * 100;
//                   return Card(
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: item['color'] as Color,
//                         radius: 10,
//                       ),
//                       title: Text(item['category']),
//                       subtitle: Text('${percent.toStringAsFixed(1)}%'),
//                       trailing: Text('${item['amount']} VND'),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/screen/bottom_nav.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  // ===== MOCK DATA =====
  final List<Map<String, dynamic>> monthData = const [
    {"month": "T1", "amount": 500000},
    {"month": "T2", "amount": 700000},
    {"month": "T3", "amount": 300000},
    {"month": "T4", "amount": 900000},
  ];

  final List<Map<String, dynamic>> weekData = const [
    {"category": "Tuần 1", "amount": 400000, "color": Colors.orange},
    {"category": "Tuần 2", "amount": 300000, "color": Colors.blue},
    {"category": "Tuần 3", "amount": 200000, "color": Colors.green},
    {"category": "Tuần 4", "amount": 100000, "color": Colors.red},
  ];

  final List<Map<String, dynamic>> dayData = const [
    {"category": "Thứ 2", "amount": 150000, "color": Colors.orange},
    {"category": "Thứ 3", "amount": 200000, "color": Colors.blue},
    {"category": "Thứ 4", "amount": 100000, "color": Colors.green},
    {"category": "Thứ 5", "amount": 50000, "color": Colors.purple},
    {"category": "Thứ 6", "amount": 300000, "color": Colors.red},
  ];

  // ====================

  @override
  Widget build(BuildContext context) {
    double totalWeek =
        weekData.fold(0, (sum, item) => sum + (item["amount"] as int).toDouble());
    double totalDay =
        dayData.fold(0, (sum, item) => sum + (item["amount"] as int).toDouble());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Báo cáo chi tiêu'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====================================================
            // 1. BIỂU ĐỒ CỘT – CHI TIÊU THEO THÁNG
            // ====================================================
            const Text(
              "Chi tiêu theo tháng",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(),
                    topTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          return Text(monthData[index]["month"]);
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(monthData.length, (i) {
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: (monthData[i]["amount"] as int).toDouble(),
                          width: 20,
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ====================================================
            // 2. BIỂU ĐỒ TRÒN – CHI TIÊU THEO TUẦN
            // ====================================================
            const Text(
              "Chi tiêu theo tuần",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: weekData.map((item) {
                    double percent =
                        (item["amount"] / totalWeek) * 100;
                    return PieChartSectionData(
                      color: item["color"],
                      value: item["amount"].toDouble(),
                      title: "${percent.toStringAsFixed(1)}%",
                      radius: 60,
                      titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    );
                  }).toList(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ====================================================
            // 3. BIỂU ĐỒ TRÒN – CHI TIÊU THEO NGÀY
            // ====================================================
            const Text(
              "Chi tiêu theo ngày",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: dayData.map((item) {
                    double percent = (item["amount"] / totalDay) * 100;
                    return PieChartSectionData(
                      color: item["color"],
                      value: (item["amount"]).toDouble(),
                      title: "${percent.toStringAsFixed(1)}%",
                      radius: 60,
                      titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    );
                  }).toList(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
    );
  }
}
