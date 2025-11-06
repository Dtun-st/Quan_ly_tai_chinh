import 'package:flutter/material.dart';

class BankScreen extends StatefulWidget {
  const BankScreen({super.key});

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  bool isHidden = false; // Ẩn số tiền
  double totalBalance = 12500000; // Tổng số dư (sẽ lấy từ API sau)

  // Dữ liệu demo, tý sẽ thay bằng API
  List<Map<String, dynamic>> accounts = [
    {"name": "Tiền mặt", "balance": 1500000, "icon": Icons.account_balance_wallet},
    {"name": "Ngân hàng", "balance": 7000000, "icon": Icons.account_balance},
    {"name": "Thẻ tín dụng", "balance": -500000, "icon": Icons.credit_card},
    {"name": "Ví điện tử", "balance": 4500000, "icon": Icons.phone_iphone},
  ];

  Future<void> refreshAccounts() async {
    await Future.delayed(const Duration(seconds: 1)); // mô phỏng API load
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tài khoản"),
        actions: [
          IconButton(
            icon: Icon(isHidden ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => isHidden = !isHidden),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: mở form thêm tài khoản
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: refreshAccounts,
        child: ListView(
          children: [
            buildTotalBalance(),
            const SizedBox(height: 10),
            ...accounts.map((acc) => buildAccountItem(acc)).toList(),
            const SizedBox(height: 20),
            buildAddAccountButton(),
          ],
        ),
      ),
    );
  }

  Widget buildTotalBalance() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Tổng tài sản", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 5),
          Text(
            isHidden ? "********" : "${totalBalance.toStringAsFixed(0)} đ",
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildAccountItem(Map<String, dynamic> acc) {
    return ListTile(
      leading: CircleAvatar(
        radius: 22,
        child: Icon(acc["icon"], size: 22),
      ),
      title: Text(acc["name"], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: Text(
        isHidden ? "*****" : "${acc["balance"]} đ",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: acc["balance"] < 0 ? Colors.red : Colors.black,
        ),
      ),
    );
  }

  Widget buildAddAccountButton() {
    return InkWell(
      onTap: () {
        // TODO: mở trang thêm tài khoản
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        alignment: Alignment.center,
        child: const Text(
          "+ Thêm tài khoản",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blue),
        ),
      ),
    );
  }
}
