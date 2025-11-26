import 'package:flutter/material.dart';
import '../services/home_service.dart';

const Color primaryColor = Color(0xFFFF6D00);
const Color textColor = Color(0xFF333333);

class AllTransactionsScreen extends StatefulWidget {
  const AllTransactionsScreen({super.key});

  @override
  State<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  List<Map<String, dynamic>> giaoDich = [];
  List<Map<String, dynamic>> filteredGiaoDich = [];
  String filterType = "Tất cả"; // "Thu", "Chi"

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    // Giả sử userId lấy từ HomeService hoặc SharedPreferences
    int userId = 1; // Thay bằng userId thực tế
    final service = HomeService();
    final transactions = await service.fetchGiaoDich(userId);

    setState(() {
      giaoDich = transactions;
      filteredGiaoDich = transactions;
      _loading = false;
    });
  }

  void _filterTransactions(String type) {
    setState(() {
      filterType = type;
      if (type == "Tất cả") {
        filteredGiaoDich = giaoDich;
      } else {
        filteredGiaoDich = giaoDich.where((g) => g['loai'] == type).toList();
      }
    });
  }

  String _formatCurrency(double amount) {
    String str = amount.toStringAsFixed(0);
    RegExp reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (Match match) => ',');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch sử giao dịch"),
        backgroundColor: primaryColor,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ---------------- Filter ----------------
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _filterButton("Tất cả"),
                      _filterButton("Thu"),
                      _filterButton("Chi"),
                    ],
                  ),
                ),
                const Divider(),
                // ---------------- List ----------------
                Expanded(
                  child: ListView.separated(
                    itemCount: filteredGiaoDich.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final gd = filteredGiaoDich[index];
                      final isThu = gd['loai'] == "Thu";
                      final color = isThu ? Colors.green.shade600 : Colors.red.shade600;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: color.withOpacity(0.1),
                          child: Icon(isThu ? Icons.trending_up : Icons.trending_down, color: color),
                        ),
                        title: Text("${gd['han_muc']}"),
                        subtitle: Text("${gd['ngay']}"),
                        trailing: Text(
                          "${isThu ? '+' : '-'}${_formatCurrency(double.tryParse(gd['so_tien'].toString()) ?? 0)} VND",
                          style: TextStyle(color: color, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _filterButton(String label) {
    final isSelected = filterType == label;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? primaryColor : Colors.grey.shade300,
        foregroundColor: isSelected ? Colors.white : textColor,
      ),
      onPressed: () => _filterTransactions(label),
      child: Text(label),
    );
  }
}
