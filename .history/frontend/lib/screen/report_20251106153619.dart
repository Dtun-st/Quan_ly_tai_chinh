import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/screen/bottom_nav.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  final List<Map<String, dynamic>> data = const [
    {"category": "Ăn uống", "amount": 500000, "color": Colors.orange},
    {"category": "Di chuyển", "amount": 300000, "color": Colors.blue},
    {"category": "Giải trí", "amount": 200000, "color": Colors.green},
    {"category": "Mua sắm", "amount": 400000, "color": Colors.purple},
    {"category": "Học tập", "amount": 150000, "color": Colors.red},
  ];

  @override
  Widget build(BuildContext context) {
    double total = data.fold(0, (sum, item) => sum + (item['amount'] as int).toDouble());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Báo cáo chi tiêu'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Tổng chi tiêu
            Text(
              'Tổng chi tiêu: ${total.toStringAsFixed(0)} VND',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Pie chart
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: data.map((item) {
                    final double percent = (item['amount'] as int).toDouble() / total * 100;
                    return PieChartSectionData(
                      color: item['color'] as Color,
                      value: (item['amount'] as int).toDouble(),
                      title: '${percent.toStringAsFixed(1)}%',
                      radius: 60,
                      titleStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Danh sách chi tiết
            Expanded(
              child: ListView(
                children: data.map((item) {
                  final double percent = (item['amount'] as int).toDouble() / total * 100;
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: item['color'] as Color,
                        radius: 10,
                      ),
                      title: Text(item['category']),
                      subtitle: Text('${percent.toStringAsFixed(1)}%'),
                      trailing: Text('${item['amount']} VND'),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
    );
  }
}

