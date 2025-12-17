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
import 'bottom_nav.dart';

enum MonthMode { single, range, last5 }

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  // --- dữ liệu mock ---
  Map<String, double> categoryThisMonth = {};
  Map<String, double> weeklyData = {};
  Map<String, double> dailyData = {};

  // Dữ liệu cho các chế độ tháng:
  // - singleMonthCategories: category totals for that single month
  // - rangeByMonth: map monthLabel -> total for each month in the chosen range
  // - last5Months: map monthLabel -> total for each of last 5 months
  Map<String, double> singleMonthCategories = {};
  Map<String, double> rangeByMonth = {};
  Map<String, double> last5Months = {};

  bool isLoading = true;

  // Month filter state
  MonthMode mode = MonthMode.last5;
  DateTime? selectedMonth; // when mode == single (we'll pick a date and use its month)
  DateTimeRange? selectedRange; // when mode == range

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  Future<void> _loadMockData() async {
    // giả lập delay load
    await Future.delayed(const Duration(milliseconds: 600));

    // mock category totals for "this month" (used if choose single month)
    singleMonthCategories = {
      "Ăn uống": 1200000,
      "Di chuyển": 450000,
      "Hóa đơn": 900000,
      "Mua sắm": 1600000,
      "Giải trí": 800000,
    };

    // mock weekly & daily (pie charts)
    weeklyData = {
      "Ăn uống": 350000,
      "Di chuyển": 120000,
      "Giải trí": 200000,
    };

    dailyData = {
      "Ăn uống": 80000,
      "Di chuyển": 25000,
    };

    // mock last5 months (label -> total)
    last5Months = {
      "08/2025": 4800000,
      "09/2025": 5100000,
      "10/2025": 4200000,
      "11/2025": 6100000,
      "12/2025": 5700000,
    };

    // mock range example (3 months)
    rangeByMonth = {
      "06/2025": 3800000,
      "07/2025": 4500000,
      "08/2025": 4800000,
      "09/2025": 5100000,
    };

    // default mode is last5; you can change UI to default single if desired
    mode = MonthMode.last5;
    isLoading = false;
    setState(() {});
  }

  // Helpers
  Color getColorForKey(String key) {
    if (key.contains("Tháng")) return Colors.deepOrange;
    switch (key) {
      case "Ăn uống":
        return Colors.deepOrange;
      case "Di chuyển":
        return Colors.blue;
      case "Hóa đơn":
        return Colors.green;
      case "Mua sắm":
        return Colors.purple;
      case "Giải trí":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String monthLabelFromDate(DateTime d) => "${d.month.toString().padLeft(2, '0')}/${d.year}";

  // UI actions
  Future<void> _pickSingleMonth() async {
    // sử dụng showDatePicker nhưng chỉ lấy tháng-năm (lấy ngày đầu trong tháng)
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedMonth ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
      helpText: "Chọn 1 ngày trong tháng bạn muốn (chúng tôi sẽ lấy tháng của ngày đó)",
    );
    if (picked != null) {
      setState(() {
        selectedMonth = picked;
        mode = MonthMode.single;
        // nếu muốn dynamic data từ backend: gọi API ở đây truyền month/year
        // hiện tại dùng dữ liệu mock singleMonthCategories
      });
    }
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        selectedRange = picked;
        mode = MonthMode.range;
        // nếu muốn gọi API: truyền start->end
        // hiện tại sử dụng mock rangeByMonth
      });
    }
  }

  void _setLast5Months() {
    setState(() {
      mode = MonthMode.last5;
      selectedMonth = null;
      selectedRange = null;
      // nếu API, gọi hàm lấy last5
    });
  }

  // Build the chart data for the "month area" according to mode
  Widget buildMonthArea() {
    Widget chart;
    String title;

    if (mode == MonthMode.single) {
      title = selectedMonth == null ? "Chi tiêu theo tháng (chưa chọn)" : "Chi tiêu ${monthLabelFromDate(selectedMonth!)}";
      // show categories bar chart for the selected month (mock: singleMonthCategories)
      chart = buildBarChart(singleMonthCategories, title, useCategoryColor: true);
    } else if (mode == MonthMode.range) {
      title = selectedRange == null
          ? "Chi tiêu theo khoảng (chưa chọn)"
          : "Chi tiêu ${selectedRange!.start.day}/${selectedRange!.start.month}/${selectedRange!.start.year} → ${selectedRange!.end.day}/${selectedRange!.end.month}/${selectedRange!.end.year}";
      // show monthly totals across the chosen range (mock: rangeByMonth)
      chart = buildBarChart(rangeByMonth, title, useCategoryColor: false);
    } else {
      // last5
      title = "Chi tiêu 5 tháng gần nhất";
      chart = buildBarChart(last5Months, title, useCategoryColor: false);
    }

    return Column(
      children: [
        // filter row
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: _pickSingleMonth,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mode == MonthMode.single ? Colors.deepOrange : Colors.grey.shade300,
                  foregroundColor: mode == MonthMode.single ? Colors.white : Colors.black,
                ),
                child: const Text("Chọn tháng"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _pickRange,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mode == MonthMode.range ? Colors.deepOrange : Colors.grey.shade300,
                  foregroundColor: mode == MonthMode.range ? Colors.white : Colors.black,
                ),
                child: const Text("Khoảng thời gian"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _setLast5Months,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mode == MonthMode.last5 ? Colors.deepOrange : Colors.grey.shade300,
                  foregroundColor: mode == MonthMode.last5 ? Colors.white : Colors.black,
                ),
                child: const Text("5 tháng gần nhất"),
              ),
              const Spacer(),
              // show small label for chosen filter
              if (mode == MonthMode.single && selectedMonth != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(monthLabelFromDate(selectedMonth!), style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              if (mode == MonthMode.range && selectedRange != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                      "${selectedRange!.start.day}/${selectedRange!.start.month}/${selectedRange!.start.year} → ${selectedRange!.end.day}/${selectedRange!.end.month}/${selectedRange!.end.year}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        // the chart block
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: chart,
        ),
      ],
    );
  }

  // Generic bar chart builder
  Widget buildBarChart(Map<String, double> data, String title, {bool useCategoryColor = true}) {
    if (data.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Text("$title\n\nKhông có dữ liệu", textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
      );
    }

    final maxY = data.values.reduce((a, b) => a > b ? a : b) * 1.2;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white, boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 8)
      ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY > 0 ? maxY : 100,
              barTouchData: BarTouchData(enabled: true),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= data.length) return const SizedBox();
                      final label = data.keys.elementAt(idx);
                      return Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(label, style: const TextStyle(fontSize: 12)),
                      );
                    },
                  ),
                ),
              ),
              barGroups: List.generate(data.length, (index) {
                final key = data.keys.elementAt(index);
                final val = data[key]!;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: val,
                      color: useCategoryColor ? getColorForKey(key) : Colors.deepOrange,
                      width: 22,
                      borderRadius: BorderRadius.circular(6),
                    )
                  ],
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // legend / listing
        Column(
          children: data.entries.map((e) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(width: 14, height: 14, decoration: BoxDecoration(color: useCategoryColor ? getColorForKey(e.key) : Colors.deepOrange, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(width: 8),
                  Expanded(child: Text(e.key)),
                  Text("${e.value.toStringAsFixed(0)} đ", style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }).toList(),
        )
      ]),
    );
  }

  Widget buildPieChart(Map<String, double> data, String title) {
    final total = data.values.fold(0.0, (a, b) => a + b);
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white, boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 8)
      ]),
      child: Column(children: [
        Align(alignment: Alignment.centerLeft, child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              sections: data.entries.map((e) {
                final percent = total > 0 ? (e.value / total * 100) : 0;
                return PieChartSectionData(
                  value: e.value,
                  radius: 55,
                  color: getColorForKey(e.key),
                  title: "${percent.toStringAsFixed(1)}%",
                  titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Column(
          children: data.entries.map((e) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(width: 14, height: 14, decoration: BoxDecoration(color: getColorForKey(e.key), borderRadius: BorderRadius.circular(4))),
                  const SizedBox(width: 8),
                  Expanded(child: Text(e.key)),
                  Text("${e.value.toStringAsFixed(0)} đ", style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }).toList(),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

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
            // ----- Month area (single chart that changes) -----
            buildMonthArea(),

            // ----- Weekly & Daily (unchanged) -----
            buildPieChart(weeklyData, "Chi tiêu trong tuần"),
            buildPieChart(dailyData, "Chi tiêu hôm nay"),
          ],
        ),
      ),
    );
  }
}
