import 'package:flutter/material.dart';
import 'bottom_nav.dart';

// ============================
// Màn hình lịch sử Thu/Chi
// ============================
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 2 tab: Thu và Chi
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Lịch sử giao dịch"),
          backgroundColor: Colors.deepOrange,
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Thu"),
              Tab(text: "Chi"),
            ],
            indicatorColor: Colors.white,
          ),
        ),

        // ===========================
        //        BODY TAB
        // ===========================
        body: const TabBarView(
          children: [
            TransactionList(type: "Thu"),
            TransactionList(type: "Chi"),
          ],
        ),

        // ===========================
        //      BOTTOM NAVIGATION
        // ===========================
        bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
      ),
    );
  }
}

// ============================
// Widget danh sách giao dịch
// ============================
class TransactionList extends StatelessWidget {
  final String type; // Thu hoặc Chi
  const TransactionList({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    // Dữ liệu mẫu (thay thế bằng API trong thực tế)
    final List<Map<String, dynamic>> transactions = List.generate(
      10,
      (index) => {
        "title": "$type giao dịch #$index",
        "amount": (index + 1) * 50000,
        "date": DateTime.now().subtract(Duration(days: index)),
      },
    );

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final item = transactions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Icon(
              type == "Thu" ? Icons.arrow_downward : Icons.arrow_upward,
              color: type == "Thu" ? Colors.green : Colors.red,
            ),
            title: Text(item["title"] as String),
            subtitle: Text((item["date"] as DateTime).toString().substring(0, 10)),
            trailing: Text(
              "${item["amount"]} đ",
              style: TextStyle(
                color: type == "Thu" ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
 