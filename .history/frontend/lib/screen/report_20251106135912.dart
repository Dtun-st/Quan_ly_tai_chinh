import 'package:flutter/material.dart';
import 'package:frontend/screen/bottom_nav.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  // Mock dữ liệu
  final List<Map<String, dynamic>> data = const [
    {"category": "Ăn uống", "amount": 500000, "color": Colors.orange},
    {"category": "Di chuyển", "amount": 300000, "color": Colors.blue},
    {"category": "Giải trí", "amount": 200000, "color": Colors.green},
    {"category": "Mua sắm", "amount": 400000, "color": Colors.purple},
  ];

  @override
  Widget build(BuildContext context) {
    double total = data.fold(0, (sum, item) => sum + (item['amount'] as double));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Báo cáo'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Tỷ lệ chi tiêu theo danh mục',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Pie chart
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: data.map((item) {
                    final double percent = (item['amount'] as double) / total * 100;
                    return PieChartSectionData(
                      color: item['color'],
                      value: item['amount'].toDouble(),
                      title: '${percent.toStringAsFixed(1)}%',
                      titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Legend
            Column(
              children: data.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        color: item['color'],
                      ),
                      const SizedBox(width: 8),
                      Text('${item['category']} - ${item['amount']} VND'),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),

      // bottom nav (tab index 3)
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
    );
  }
}
