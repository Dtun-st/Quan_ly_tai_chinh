import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Giả lập dữ liệu từ backend
  final List<Map<String, dynamic>> taiKhoan = [
    {"ten": "Tiền mặt", "so_du": 2000000},
    {"ten": "Ngân hàng", "so_du": 5000000},
    {"ten": "Ví điện tử", "so_du": 1500000},
  ];

  final List<Map<String, dynamic>> giaoDich = [
    {"han_muc": "Ăn uống", "so_tien": 50000, "loai": "Chi", "ngay": "2025-10-24"},
    {"han_muc": "Lương", "so_tien": 10000000, "loai": "Thu", "ngay": "2025-10-23"},
    {"han_muc": "Đi lại", "so_tien": 200000, "loai": "Chi", "ngay": "2025-10-22"},
  ];

  final List<Map<String, dynamic>> thongBao = [
    {"noi_dung": "Bạn đã vượt hạn mức chi tiêu Ăn uống tháng này", "loai": "Cảnh báo"},
    {"noi_dung": "Gợi ý tiết kiệm 10% cho chi tiêu tuần này", "loai": "Gợi ý"},
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // TODO: xử lý chuyển tab nếu muốn hiển thị trang khác
    });
  }

  @override
  Widget build(BuildContext context) {
    double total = taiKhoan.fold(0, (sum, item) => sum + item['so_du']);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: false,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(""),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "HEHEHEHHEHE",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Chào bạn!",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              print("Nhấn vào thông báo");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tổng số dư
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.orange.shade100,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tổng số dư",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${total.toStringAsFixed(0)} VND",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Quick Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _actionCard(Icons.add_circle, "Thu"),
                _actionCard(Icons.remove_circle, "Chi"),
                _actionCard(Icons.handshake, "Cho vay"),
                _actionCard(Icons.account_balance_wallet, "Đi vay"),
              ],
            ),
            const SizedBox(height: 16),

            // Giao dịch gần đây
            const Text(
              "Giao dịch gần đây",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...giaoDich.map(
              (gd) => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: ListTile(
                  leading: Icon(
                    gd['loai'] == "Thu" ? Icons.arrow_downward : Icons.arrow_upward,
                    color: gd['loai'] == "Thu" ? Colors.green : Colors.red,
                  ),
                  title: Text("${gd['han_muc']}"),
                  subtitle: Text("${gd['ngay']}"),
                  trailing: Text("${gd['so_tien']} VND"),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Thông báo
            const Text(
              "Thông báo",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...thongBao.map(
              (tb) => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: tb['loai'] == "Cảnh báo" ? Colors.red.shade100 : Colors.blue.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(tb['noi_dung']),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        selectedItemColor: Colors.orange.shade700,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Tổng quan"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Tài khoản"),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Ghi chép"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Báo cáo"),
        ],
      ),
    );
  }

  Widget _actionCard(IconData icon, String label) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.orange.shade200,
      elevation: 3,
      child: SizedBox(
        width: 70,
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
