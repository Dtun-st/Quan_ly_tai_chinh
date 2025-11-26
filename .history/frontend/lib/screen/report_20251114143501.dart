import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/screen/bottom_nav.dart';

void main() {
  runApp(
    MaterialApp(
      home: ReportScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class ReportScreen extends StatelessWidget {
  // Dữ liệu cứng
  final Map<String, double> monthlyData = {
    "Ăn uống": 5000000,
    "Di chuyển": 1200000,
    "Hóa đơn": 2500000,
    "Mua sắm": 3000000,
    "Giải trí": 1500000,
    "Khác": 800000,
  };

  final Map<String, double> weeklyData = {
    "Ăn uống": 1200000,
    "Di chuyển": 300000,
    "Hóa đơn": 500000,
    "Mua sắm": 700000,
  };

  final Map<String, double> dailyData = {
    "Ăn uống": 200000,
    "Di chuyển": 50000,
    "Hóa đơn": 120000,
  };

  final Map<String, Color> colors = {
    "Ăn uống": Colors.deepOrange,
    "Di chuyển": Colors.blue,
    "Hóa đơn": Colors.green,
    "Mua sắm": Colors.purple,
    "Giải trí": Colors.red,
    "Khác": Colors.grey,
  };

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
                  color: colors[key],
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
            // ===== Biểu đồ cột (Monthly) =====
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Chi tiêu tháng",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 6000000,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1000000,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                    "${(value / 1000000).toStringAsFixed(0)}M");
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                int index = value.toInt();
                                String key =
                                    monthlyData.keys.elementAt(index);
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    key,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        barGroups: List.generate(monthlyData.length, (index) {
                          final key = monthlyData.keys.elementAt(index);
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: monthlyData[key]!,
                                color: colors[key] ?? Colors.black,
                                width: 20,
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildLegend(monthlyData),
                ],
              ),
            ),

            // ===== Biểu đồ tròn (Weekly) =====
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Chi tiêu tuần",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 180,
                    child: PieChart(
                      PieChartData(
                        sections: weeklyData.entries.map((e) {
                          final percent = e.value /
                              weeklyData.values.reduce((a, b) => a + b) *
                              100;
                          return PieChartSectionData(
                            color: colors[e.key] ?? Colors.black,
                            value: e.value,
                            radius: 50,
                            title: "${percent.toStringAsFixed(1)}%",
                            titleStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildLegend(weeklyData),
                ],
              ),
            ),

            // ===== Biểu đồ tròn (Daily) =====
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Chi tiêu ngày",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 180,
                    child: PieChart(
                      PieChartData(
                        sections: dailyData.entries.map((e) {
                          final percent = e.value /
                              dailyData.values.reduce((a, b) => a + b) *
                              100;
                          return PieChartSectionData(
                            color: colors[e.key] ?? Colors.black,
                            value: e.value,
                            radius: 50,
                            title: "${percent.toStringAsFixed(1)}%",
                            titleStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildLegend(dailyData),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
