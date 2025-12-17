// // import 'package:flutter/material.dart';
// // import 'package:fl_chart/fl_chart.dart';
// // import '../services/report_service.dart';
// // import 'bottom_nav.dart'; 

// // class ReportScreen extends StatefulWidget {
// //   const ReportScreen({super.key});

// //   @override
// //   State<ReportScreen> createState() => _ReportScreenState();
// // }

// // class _ReportScreenState extends State<ReportScreen> {
// //   final ReportService _service = ReportService();

// //   Map<String, double> monthlyData = {};
// //   Map<String, double> weeklyData = {};
// //   Map<String, double> dailyData = {};
// //   bool isLoading = true;
// //   String? errorMsg;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadData();
// //   }

// //   Future<void> _loadData() async {
// //     try {
// //       final month = await _service.getReport('monthly');
// //       final week = await _service.getReport('weekly');
// //       final day = await _service.getReport('daily');

// //       setState(() {
// //         monthlyData = month;
// //         weeklyData = week;
// //         dailyData = day;
// //         isLoading = false;
// //         if (month.isEmpty && week.isEmpty && day.isEmpty) {
// //           errorMsg = "Chưa có dữ liệu báo cáo";
// //         }
// //       });
// //     } catch (e) {
// //       setState(() {
// //         isLoading = false;
// //         errorMsg = "Lỗi khi tải báo cáo: $e";
// //       });
// //     }
// //   }

// //   Color getColorForCategory(String category) {
// //     switch (category) {
// //       case "Ăn uống":
// //       case "Food":
// //         return Colors.deepOrange;
// //       case "Di chuyển":
// //       case "Transport":
// //         return Colors.blue;
// //       case "Hóa đơn":
// //       case "Bills":
// //         return Colors.green;
// //       case "Mua sắm":
// //       case "Shopping":
// //         return Colors.purple;
// //       case "Giải trí":
// //       case "Entertainment":
// //         return Colors.red;
// //       case "Thu":
// //         return Colors.greenAccent;
// //       case "Chi":
// //         return Colors.deepOrange;
// //       default:
// //         return Colors.grey;
// //     }
// //   }

// //   Widget buildLegend(Map<String, double> dataMap) {
// //     return Column(
// //       children: dataMap.keys.map((key) {
// //         return Padding(
// //           padding: const EdgeInsets.symmetric(vertical: 4),
// //           child: Row(
// //             children: [
// //               Container(
// //                 width: 18,
// //                 height: 18,
// //                 decoration: BoxDecoration(
// //                   color: getColorForCategory(key),
// //                   borderRadius: BorderRadius.circular(4),
// //                 ),
// //               ),
// //               const SizedBox(width: 8),
// //               Text(key, style: const TextStyle(fontSize: 16)),
// //               const Spacer(),
// //               Text("${dataMap[key]!.toStringAsFixed(0)} đ",
// //                   style: const TextStyle(fontWeight: FontWeight.bold)),
// //             ],
// //           ),
// //         );
// //       }).toList(),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     if (isLoading) {
// //       return const Scaffold(
// //         body: Center(child: CircularProgressIndicator()),
// //       );
// //     }

// //     if (errorMsg != null) {
// //       return Scaffold(
// //         appBar: AppBar(
// //           title: const Text("Báo cáo chi tiêu"),
// //           backgroundColor: Colors.deepOrange,
// //           centerTitle: true,
// //         ),
// //         body: Center(
// //             child: Text(errorMsg!, style: const TextStyle(fontSize: 18))),
// //         bottomNavigationBar:
// //             const CustomBottomNav(currentIndex: 3), // ✅ BottomNav luôn hiển thị
// //       );
// //     }

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Báo cáo chi tiêu"),
// //         backgroundColor: Colors.deepOrange,
// //         centerTitle: true,
// //       ),
// //       bottomNavigationBar:
// //           const CustomBottomNav(currentIndex: 3), // ✅ gọi CustomBottomNav
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             if (monthlyData.isNotEmpty)
// //               buildBarChart(monthlyData, "Chi tiêu tháng"),
// //             if (weeklyData.isNotEmpty)
// //               buildPieChart(weeklyData, "Chi tiêu tuần"),
// //             if (dailyData.isNotEmpty)
// //               buildPieChart(dailyData, "Chi tiêu ngày"),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget buildBarChart(Map<String, double> data, String title) {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       margin: const EdgeInsets.only(bottom: 20),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: const [
// //           BoxShadow(
// //               color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(title,
// //               style:
// //                   const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// //           const SizedBox(height: 10),
// //           SizedBox(
// //             height: 200,
// //             child: BarChart(
// //               BarChartData(
// //                 alignment: BarChartAlignment.spaceAround,
// //                 maxY: (data.values.isNotEmpty)
// //                     ? data.values.reduce((a, b) => a > b ? a : b) * 1.2
// //                     : 100,
// //                 barTouchData: BarTouchData(enabled: false),
// //                 titlesData: FlTitlesData(
// //                   leftTitles: AxisTitles(
// //                     sideTitles: SideTitles(
// //                       showTitles: true,
// //                       interval: (data.values.isNotEmpty)
// //                           ? data.values.reduce((a, b) => a > b ? a : b) / 5
// //                           : 100,
// //                       getTitlesWidget: (value, meta) =>
// //                           Text("${value.toStringAsFixed(0)}"),
// //                     ),
// //                   ),
// //                   bottomTitles: AxisTitles(
// //                     sideTitles: SideTitles(
// //                       showTitles: true,
// //                       getTitlesWidget: (value, meta) {
// //                         final index = value.toInt();
// //                         if (index < 0 || index >= data.keys.length)
// //                           return const SizedBox();
// //                         final key = data.keys.elementAt(index);
// //                         return Padding(
// //                           padding: const EdgeInsets.only(top: 8.0),
// //                           child: Text(key, style: const TextStyle(fontSize: 12)),
// //                         );
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //                 barGroups: List.generate(data.length, (index) {
// //                   final key = data.keys.elementAt(index);
// //                   return BarChartGroupData(
// //                     x: index,
// //                     barRods: [
// //                       BarChartRodData(
// //                           toY: data[key]!,
// //                           color: getColorForCategory(key),
// //                           width: 20)
// //                     ],
// //                   );
// //                 }),
// //               ),
// //             ),
// //           ),
// //           const SizedBox(height: 10),
// //           buildLegend(data),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget buildPieChart(Map<String, double> data, String title) {
// //     final total =
// //         data.values.fold<double>(0, (prev, element) => prev + element);
// //     return Container(
// //       padding: const EdgeInsets.all(20),
// //       margin: const EdgeInsets.only(bottom: 20),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: const [
// //           BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))
// //         ],
// //       ),
// //       child: Column(
// //         children: [
// //           Text(title,
// //               style:
// //                   const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// //           const SizedBox(height: 10),
// //           SizedBox(
// //             height: 180,
// //             child: PieChart(
// //               PieChartData(
// //                 sections: data.entries.map((e) {
// //                   final percent = total > 0 ? e.value / total * 100 : 0;
// //                   return PieChartSectionData(
// //                     color: getColorForCategory(e.key),
// //                     value: e.value,
// //                     radius: 50,
// //                     title: "${percent.toStringAsFixed(1)}%",
// //                     titleStyle: const TextStyle(
// //                         color: Colors.white,
// //                         fontWeight: FontWeight.bold,
// //                         fontSize: 14),
// //                   );
// //                 }).toList(),
// //               ),
// //             ),
// //           ),
// //           const SizedBox(height: 10),
// //           buildLegend(data),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../services/report_service.dart';
// import 'bottom_nav.dart';

// enum MonthMode { single, range }

// class ReportScreen extends StatefulWidget {
//   const ReportScreen({super.key});

//   @override
//   State<ReportScreen> createState() => _ReportScreenState();
// }

// class _ReportScreenState extends State<ReportScreen> {
//   final ReportService _service = ReportService();

//   bool isLoading = true;
//   String? errorMsg;

//   MonthMode mode = MonthMode.single;
//   DateTime selectedMonth = DateTime.now();
//   DateTimeRange? selectedRange;

//   Map<String, double> singleMonthCategories = {};
//   Map<String, double> rangeByMonth = {};
//   Map<String, double> weeklyData = {};
//   Map<String, double> dailyData = {};

//   @override
//   void initState() {
//     super.initState();
//     _loadDefaultData();
//   }

//   Future<void> _loadDefaultData() async {
//     try {
//       final report = await _service.getDefaultReport();
//       setState(() {
//         dailyData = report["daily"] ?? {};
//         weeklyData = report["weekly"] ?? {};
//         singleMonthCategories = report["monthly"] ?? {};
//         isLoading = false;
//         if (dailyData.isEmpty && weeklyData.isEmpty && singleMonthCategories.isEmpty) {
//           errorMsg = "Chưa có dữ liệu báo cáo";
//         }
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         errorMsg = "Lỗi tải dữ liệu: $e";
//       });
//     }
//   }

//   Future<void> _pickSingleMonth() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: selectedMonth,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//       helpText: "Chọn tháng",
//     );

//     if (picked != null) {
//       setState(() {
//         selectedMonth = picked;
//         mode = MonthMode.single;
//         isLoading = true;
//       });
//       try {
//         singleMonthCategories = await _service.getMonthReport(selectedMonth);
//       } catch (e) {
//         errorMsg = "Lỗi tải dữ liệu: $e";
//       }
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> _pickRange() async {
//     final picked = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//       helpText: "Chọn khoảng thời gian",
//     );

//     if (picked != null) {
//       setState(() {
//         selectedRange = picked;
//         mode = MonthMode.range;
//         isLoading = true;
//       });
//       try {
//         rangeByMonth = await _service.getRangeReport(selectedRange!.start, selectedRange!.end);
//       } catch (e) {
//         errorMsg = "Lỗi tải dữ liệu: $e";
//       }
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   String monthLabel(DateTime d) => "${d.month.toString().padLeft(2,'0')}/${d.year}";

//   Color categoryColor(String key) {
//     switch (key) {
//       case "Ăn uống": return Colors.deepOrange;
//       case "Di chuyển": return Colors.blue;
//       case "Hóa đơn": return Colors.green;
//       case "Mua sắm": return Colors.purple;
//       case "Giải trí": return Colors.red;
//       default: return Colors.orange;
//     }
//   }

//   Widget buildBarChart(Map<String, double> data, String title, {bool useColor = true}) {
//     if (data.isEmpty) return Container(
//       padding: const EdgeInsets.all(16),
//       child: const Center(child: Text("Không có dữ liệu")),
//     );

//     final maxY = data.values.reduce((a,b) => a>b?a:b)*1.2;

//     return Container(
//       padding: const EdgeInsets.all(12),
//       margin: const EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,2))]
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title, style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
//           SizedBox(
//             height: 230,
//             child: BarChart(
//               BarChartData(
//                 alignment: BarChartAlignment.spaceAround,
//                 maxY: maxY,
//                 barGroups: List.generate(data.length, (index) {
//                   final key = data.keys.elementAt(index);
//                   return BarChartGroupData(
//                     x: index,
//                     barRods: [
//                       BarChartRodData(
//                         toY: data[key]!,
//                         width: 22,
//                         color: useColor ? categoryColor(key) : Colors.deepOrange,
//                         borderRadius: BorderRadius.circular(6),
//                       )
//                     ],
//                   );
//                 }),
//                 titlesData: FlTitlesData(
//                   leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       getTitlesWidget: (v, meta) {
//                         final key = data.keys.elementAt(v.toInt());
//                         return Padding(
//                           padding: const EdgeInsets.only(top: 6),
//                           child: Text(key, style: const TextStyle(fontSize: 12)),
//                         );
//                       }
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget buildPieChart(Map<String, double> data, String title) {
//     if (data.isEmpty) return Container(
//       padding: const EdgeInsets.all(16),
//       child: const Center(child: Text("Không có dữ liệu")),
//     );

//     final total = data.values.fold(0.0, (a,b)=>a+b);
//     return Container(
//       padding: const EdgeInsets.all(14),
//       margin: const EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,2))]
//       ),
//       child: Column(
//         children: [
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Text(title, style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold))
//           ),
//           SizedBox(
//             height: 200,
//             child: PieChart(
//               PieChartData(
//                 sections: data.entries.map((e){
//                   final percent = total==0?0:(e.value/total*100);
//                   return PieChartSectionData(
//                     value: e.value,
//                     color: categoryColor(e.key),
//                     radius: 55,
//                     title: "${percent.toStringAsFixed(1)}%",
//                     titleStyle: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:13)
//                   );
//                 }).toList()
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget buildMonthChart() {
//     if (mode==MonthMode.single) {
//       return buildBarChart(singleMonthCategories, "Chi tiêu tháng ${monthLabel(selectedMonth)}");
//     } else if (mode==MonthMode.range) {
//       return buildBarChart(rangeByMonth, selectedRange==null
//           ? "Chưa chọn khoảng thời gian"
//           : "Từ ${selectedRange!.start.day}/${selectedRange!.start.month} → ${selectedRange!.end.day}/${selectedRange!.end.month}",
//         useColor: false
//       );
//     }
//     return const SizedBox();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Báo cáo chi tiêu"),
//         centerTitle: true,
//         backgroundColor: Colors.deepOrange,
//       ),
//       bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 ElevatedButton(
//                   onPressed: _pickSingleMonth,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: mode==MonthMode.single ? Colors.deepOrange : Colors.grey.shade300,
//                     foregroundColor: mode==MonthMode.single ? Colors.white : Colors.black
//                   ),
//                   child: const Text("Chọn tháng"),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: _pickRange,
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: mode==MonthMode.range ? Colors.deepOrange : Colors.grey.shade300,
//                       foregroundColor: mode==MonthMode.range ? Colors.white : Colors.black
//                   ),
//                   child: const Text("Khoảng thời gian"),
//                 )
//               ],
//             ),
//             const SizedBox(height: 20),
//             buildMonthChart(),
//             const SizedBox(height: 24),
//             buildPieChart(weeklyData, "Chi tiêu trong tuần"),
//             const SizedBox(height: 20),
//             buildPieChart(dailyData, "Chi tiêu hôm nay"),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/report_service.dart';
import 'bottom_nav.dart';

enum MonthMode { single, range }

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final ReportService _service = ReportService();

  bool isLoading = true;
  String? errorMsg;

  MonthMode mode = MonthMode.single;
  DateTime selectedMonth = DateTime.now();
  DateTimeRange? selectedRange;

  Map<String, double> singleMonthCategories = {};
  Map<String, double> rangeByMonth = {};
  Map<String, double> weeklyData = {};
  Map<String, double> dailyData = {};

  @override
  void initState() {
    super.initState();
    _loadDefaultData();
  }

  Future<void> _loadDefaultData() async {
    try {
      final report = await _service.getDefaultReport();
      setState(() {
        dailyData = report["daily"] ?? {};
        weeklyData = report["weekly"] ?? {};
        singleMonthCategories = report["monthly"] ?? {};
        isLoading = false;
        if (dailyData.isEmpty && weeklyData.isEmpty && singleMonthCategories.isEmpty) {
          errorMsg = "Chưa có dữ liệu báo cáo";
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMsg = "Lỗi tải dữ liệu: $e";
      });
    }
  }

  Future<void> _pickSingleMonth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: "Chọn tháng",
    );

    if (picked != null) {
      setState(() {
        selectedMonth = picked;
        mode = MonthMode.single;
        isLoading = true;
      });
      try {
        singleMonthCategories = await _service.getMonthReport(selectedMonth);
      } catch (e) {
        errorMsg = "Lỗi tải dữ liệu: $e";
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: "Chọn khoảng thời gian",
    );

    if (picked != null) {
      setState(() {
        selectedRange = picked;
        mode = MonthMode.range;
        isLoading = true;
      });
      try {
        rangeByMonth = await _service.getRangeReport(selectedRange!.start, selectedRange!.end);
      } catch (e) {
        errorMsg = "Lỗi tải dữ liệu: $e";
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  String monthLabel(DateTime d) => "${d.month.toString().padLeft(2,'0')}/${d.year}";

  Color categoryColor(String key) {
    switch (key) {
      case "Ăn uống": return Colors.deepOrange;
      case "Di chuyển": return Colors.blue;
      case "Hóa đơn": return Colors.green;
      case "Mua sắm": return Colors.purple;
      case "Giải trí": return Colors.red;
      default: return Colors.orange;
    }
  }

  // Legend hiển thị chú thích màu
  Widget buildLegend(Map<String, double> data) {
    if (data.isEmpty) return const SizedBox();
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: data.keys.map((key) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 12, height: 12, color: categoryColor(key)),
            const SizedBox(width: 4),
            Text(key, style: const TextStyle(fontSize: 12)),
          ],
        );
      }).toList(),
    );
  }

  Widget buildBarChart(Map<String, double> data, String title, {bool useColor = true}) {
    if (data.isEmpty) return Container(
      padding: const EdgeInsets.all(16),
      child: const Center(child: Text("Không có dữ liệu")),
    );

    final maxY = data.values.reduce((a,b) => a>b?a:b)*1.2;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,2))]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 230,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barGroups: List.generate(data.length, (index) {
                  final key = data.keys.elementAt(index);
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: data[key]!,
                        width: 22,
                        color: useColor ? categoryColor(key) : Colors.deepOrange,
                        borderRadius: BorderRadius.circular(6),
                      )
                    ],
                  );
                }),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, meta) {
                        final key = data.keys.elementAt(v.toInt());
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(key, style: const TextStyle(fontSize: 12)),
                        );
                      }
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          buildLegend(data),
        ],
      ),
    );
  }

  Widget buildPieChart(Map<String, double> data, String title) {
    if (data.isEmpty) return Container(
      padding: const EdgeInsets.all(16),
      child: const Center(child: Text("Không có dữ liệu")),
    );

    final total = data.values.fold(0.0, (a,b)=>a+b);
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,2))]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: data.entries.map((e){
                  final percent = total==0?0:(e.value/total*100);
                  return PieChartSectionData(
                    value: e.value,
                    color: categoryColor(e.key),
                    radius: 55,
                    title: "${percent.toStringAsFixed(1)}%",
                    titleStyle: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:13)
                  );
                }).toList()
              ),
            ),
          ),
          const SizedBox(height: 12),
          buildLegend(data),
        ],
      ),
    );
  }

  Widget buildMonthChart() {
    if (mode==MonthMode.single) {
      return buildBarChart(singleMonthCategories, "Chi tiêu tháng ${monthLabel(selectedMonth)}");
    } else if (mode==MonthMode.range) {
      return buildBarChart(rangeByMonth, selectedRange==null
          ? "Chưa chọn khoảng thời gian"
          : "Từ ${selectedRange!.start.day}/${selectedRange!.start.month} → ${selectedRange!.end.day}/${selectedRange!.end.month}",
        useColor: false
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Báo cáo chi tiêu"),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickSingleMonth,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mode==MonthMode.single ? Colors.deepOrange : Colors.grey.shade300,
                    foregroundColor: mode==MonthMode.single ? Colors.white : Colors.black
                  ),
                  child: const Text("Chọn tháng"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _pickRange,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: mode==MonthMode.range ? Colors.deepOrange : Colors.grey.shade300,
                      foregroundColor: mode==MonthMode.range ? Colors.white : Colors.black
                  ),
                  child: const Text("Khoảng thời gian"),
                )
              ],
            ),
            const SizedBox(height: 20),
            buildMonthChart(),
            const SizedBox(height: 24),
            buildPieChart(weeklyData, "Chi tiêu trong tuần"),
            const SizedBox(height: 20),
            buildPieChart(dailyData, "Chi tiêu hôm nay"),
          ],
        ),
      ),
    );
  }
}
