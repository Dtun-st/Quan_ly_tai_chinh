import 'package:flutter/material.dart';
import '../services/home_service.dart';
import 'api_config.dart';

class AllTransactionsScreen extends StatefulWidget {
  const AllTransactionsScreen({super.key});

  @override
  State<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  List<Map<String, dynamic>> giaoDich = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAllTransactions();
  }

  Future<void> _loadAllTransactions() async {
    final userId = 1; // Thay bằng SharedPreferences lấy userId
    final service = HomeService();
    final data = await service.fetchGiaoDich(userId);
    setState(() {
      giaoDich = data;
      _loading = false;
    });
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tất cả giao dịch"),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: giaoDich.length,
        itemBuilder: (context, index) {
          final gd = giaoDich[index];
          final isThu = gd['loai'] == 'Thu';
          final color = isThu ? Colors.green : Colors.red;

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(isThu ? Icons.trending_up : Icons.trending_down, color: color),
            ),
            title: Text(gd['han_muc']),
            subtitle: Text(gd['ngay']),
            trailing: Text("${isThu ? '+' : '-'}${_formatCurrency(double.tryParse(gd['so_tien'].toString()) ?? 0)} VND",
                style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          );
        },
      ),
    );
  }
}
