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

  // Màu phân biệt Thu/Chi
  Color categoryColor(String key, {bool isIncome = false}) {
    if (isIncome) {
      switch (key) {
        case "Ăn uống": return Colors.green.shade400;
        case "Di chuyển": return Colors.blue.shade400;
        case "Hóa đơn": return Colors.teal.shade400;
        case "Mua sắm": return Colors.purple.shade300;
        case "Giải trí": return Colors.indigo.shade400;
        default: return Colors.lightGreen;
      }
    } else {
      switch (key) {
        case "Ăn uống": return Colors.deepOrange;
        case "Di chuyển": return Colors.red;
        case "Hóa đơn": return Colors.brown;
        case "Mua sắm": return Colors.purple;
        case "Giải trí": return Colors.pink;
        default: return Colors.orange;
      }
    }
  }

  Widget buildLegend(Map<String, double> data, {bool isIncome = false}) {
    if (data.isEmpty) return const SizedBox();
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: data.keys.map((key) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 12, height: 12, color: categoryColor(key, isIncome: isIncome)),
            const SizedBox(width: 4),
            Text(key, style: const TextStyle(fontSize: 12)),
          ],
        );
      }).toList(),
    );
  }

  Widget buildBarChart(Map<String, double> data, String title, {bool useColor = true, bool isIncome = false}) {
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
                        color: useColor ? categoryColor(key, isIncome: isIncome) : Colors.deepOrange,
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
          buildLegend(data, isIncome: isIncome),
        ],
      ),
    );
  }

  Widget buildPieChart(Map<String, double> data, String title, {bool isIncome = false}) {
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
                    color: categoryColor(e.key, isIncome: isIncome),
                    radius: 55,
                    title: "${percent.toStringAsFixed(1)}%",
                    titleStyle: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:13)
                  );
                }).toList()
              ),
            ),
          ),
          const SizedBox(height: 12),
          buildLegend(data, isIncome: isIncome),
        ],
      ),
    );
  }

  Widget buildMonthChart() {
    if (mode==MonthMode.single) {
      return buildBarChart(singleMonthCategories, "Chi tiêu tháng ${monthLabel(selectedMonth)}", isIncome: false);
    } else if (mode==MonthMode.range) {
      return buildBarChart(rangeByMonth, selectedRange==null
          ? "Chưa chọn khoảng thời gian"
          : "Từ ${selectedRange!.start.day}/${selectedRange!.start.month} → ${selectedRange!.end.day}/${selectedRange!.end.month}",
        useColor: false,
        isIncome: false
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
            buildPieChart(weeklyData, "Chi tiêu trong tuần", isIncome: false),
            const SizedBox(height: 20),
            buildPieChart(dailyData, "Chi tiêu hôm nay", isIncome: false),
          ],
        ),
      ),
    );
  }
}
