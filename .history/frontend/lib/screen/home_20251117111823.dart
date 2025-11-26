// import 'package:flutter/material.dart';
// import 'bottom_nav.dart';
// import 'profile.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final List<Map<String, dynamic>> taiKhoan = [
//     {"ten": "Tiền mặt", "so_du": 2000000},
//     {"ten": "Ngân hàng", "so_du": 5000000},
//     {"ten": "Ví điện tử", "so_du": 1500000},
//   ];

//   final List<Map<String, dynamic>> giaoDichGoc = [
//     {"han_muc": "Ăn uống", "so_tien": 50000, "loai": "Chi", "ngay": "2025-10-24"},
//     {"han_muc": "Lương", "so_tien": 10000000, "loai": "Thu", "ngay": "2025-10-23"},
//     {"han_muc": "Đi lại", "so_tien": 200000, "loai": "Chi", "ngay": "2025-10-22"},
//   ];

//   final List<Map<String, dynamic>> thongBao = [
//     {"noi_dung": "Bạn đã vượt hạn mức chi tiêu Ăn uống tháng này", "loai": "Cảnh báo"},
//     {"noi_dung": "Gợi ý tiết kiệm 10% cho chi tiêu tuần này", "loai": "Gợi ý"},
//   ];

//   bool _isSearching = false;
//   TextEditingController _searchController = TextEditingController();
//   List<Map<String, dynamic>> giaoDich = [];

//   @override
//   void initState() {
//     super.initState();
//     giaoDich = List.from(giaoDichGoc);
//   }

//   void _searchGiaoDich(String query) {
//     final ketQua = giaoDichGoc.where((gd) {
//       final hanMuc = gd['han_muc'].toString().toLowerCase();
//       return hanMuc.contains(query.toLowerCase());
//     }).toList();
//     setState(() {
//       giaoDich = ketQua;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     double total = taiKhoan.fold(0, (sum, item) => sum + item['so_du']);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.orange,
//         centerTitle: false,
//         title: _isSearching
//             ? TextField(
//                 controller: _searchController,
//                 autofocus: true,
//                 decoration: const InputDecoration(
//                   hintText: "Tìm kiếm giao dịch...",
//                   border: InputBorder.none,
//                   hintStyle: TextStyle(color: Colors.white70),
//                 ),
//                 style: const TextStyle(color: Colors.white),
//                 onChanged: _searchGiaoDich,
//               )
//             : GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const ProfileScreen()),
//                   );
//                 },
//                 child: Row(
//                   children: [
//                     const CircleAvatar(
//                       radius: 20,
//                       backgroundColor: Colors.white,
//                       child: Icon(
//                         Icons.account_circle, // icon mặt người mặc định
//                         color: Colors.orange,
//                         size: 30,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [
//                         Text(
//                           "HEHEHEHHEHE",
//                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           "Chào bạn!",
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//         actions: [
//           IconButton(
//             icon: Icon(_isSearching ? Icons.close : Icons.search),
//             onPressed: () {
//               setState(() {
//                 _isSearching = !_isSearching;
//                 if (!_isSearching) {
//                   _searchController.clear();
//                   giaoDich = List.from(giaoDichGoc);
//                 }
//               });
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             onPressed: () {
//               print("Nhấn vào thông báo");
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//               color: Colors.orange.shade100,
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Tổng số dư",
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "${total.toStringAsFixed(0)} VND",
//                       style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _actionCard(Icons.add_circle, "Thu"),
//                 _actionCard(Icons.remove_circle, "Chi"),
//                 _actionCard(Icons.handshake, "Cho vay"),
//                 _actionCard(Icons.account_balance_wallet, "Đi vay"),
//               ],
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               "Giao dịch gần đây",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             ...giaoDich.map(
//               (gd) => Card(
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 elevation: 2,
//                 child: ListTile(
//                   leading: Icon(
//                     gd['loai'] == "Thu" ? Icons.arrow_downward : Icons.arrow_upward,
//                     color: gd['loai'] == "Thu" ? Colors.green : Colors.red,
//                   ),
//                   title: Text("${gd['han_muc']}"),
//                   subtitle: Text("${gd['ngay']}"),
//                   trailing: Text("${gd['so_tien']} VND"),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               "Thông báo",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             ...thongBao.map(
//               (tb) => Card(
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 color: tb['loai'] == "Cảnh báo"
//                     ? Colors.red.shade100
//                     : Colors.blue.shade100,
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Text(tb['noi_dung']),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: CustomBottomNav(currentIndex: 0),
//     );
//   }

//   Widget _actionCard(IconData icon, String label) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       color: Colors.orange.shade200,
//       elevation: 3,
//       child: SizedBox(
//         width: 70,
//         height: 70,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, color: Colors.white, size: 30),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: const TextStyle(color: Colors.white, fontSize: 12),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> transactions = [
    {"category": "Ăn uống", "amount": 50000, "type": "Chi", "date": "2025-10-24"},
    {"category": "Lương", "amount": 10000000, "type": "Thu", "date": "2025-10-23"},
    {"category": "Đi lại", "amount": 200000, "type": "Chi", "date": "2025-10-22"},
  ];

  @override
  Widget build(BuildContext context) {
    double totalBalance = 2000000 + 5000000 + 1500000;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Tìm kiếm giao dịch...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
              )
            : const Text("Xin chào!", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // ================================
            // 1. Ô tổng số dư
            // ================================
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BalanceDetailPage()),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.shade300,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Tổng số dư",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${totalBalance.toStringAsFixed(0)} VND",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  ],
                ),
              ),
            ),

            // ================================
            // 2. Ô các hành động (Thu - Chi - Cho vay - Đi vay)
            // ================================
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  actionButton(Icons.add_circle, "Thu"),
                  actionButton(Icons.remove_circle, "Chi"),
                  actionButton(Icons.handshake, "Cho vay"),
                  actionButton(Icons.account_balance_wallet, "Đi vay"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================================
            // 3. Danh sách giao dịch gần đây
            // ================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Giao dịch gần đây",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 10),

            ...transactions.map((t) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: ListTile(
                leading: Icon(
                  t["type"] == "Thu" ? Icons.south : Icons.north,
                  color: t["type"] == "Thu" ? Colors.green : Colors.red,
                ),
                title: Text(t["category"]),
                subtitle: Text("Ngày: ${t["date"]}"),
                trailing: Text("${t["amount"]} VND"),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget actionButton(IconData icon, String title) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.orange.shade300,
          radius: 22,
          child: Icon(icon, size: 26, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}


// ===================================================
// Trang chi tiết khi bấm vào "Tổng số dư"
// ===================================================
class BalanceDetailPage extends StatelessWidget {
  const BalanceDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết số dư"),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text("Tiền mặt: 2,000,000 VND", style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text("Ngân hàng: 5,000,000 VND", style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text("Ví điện tử: 1,500,000 VND", style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
