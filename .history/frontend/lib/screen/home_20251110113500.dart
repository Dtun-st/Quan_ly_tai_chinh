// // import 'package:flutter/material.dart';
// // import 'bottom_nav.dart';
// // import 'profile.dart';

// // class HomePage extends StatefulWidget {
// //   const HomePage({super.key});

// //   @override
// //   State<HomePage> createState() => _HomePageState();
// // }

// // class _HomePageState extends State<HomePage> {
// //   final List<Map<String, dynamic>> taiKhoan = [
// //     {"ten": "Tiền mặt", "so_du": 2000000},
// //     {"ten": "Ngân hàng", "so_du": 5000000},
// //     {"ten": "Ví điện tử", "so_du": 1500000},
// //   ];

// //   final List<Map<String, dynamic>> giaoDich = [
// //     {"han_muc": "Ăn uống", "so_tien": 50000, "loai": "Chi", "ngay": "2025-10-24"},
// //     {"han_muc": "Lương", "so_tien": 10000000, "loai": "Thu", "ngay": "2025-10-23"},
// //     {"han_muc": "Đi lại", "so_tien": 200000, "loai": "Chi", "ngay": "2025-10-22"},
// //   ];

// //   final List<Map<String, dynamic>> thongBao = [
// //     {"noi_dung": "Bạn đã vượt hạn mức chi tiêu Ăn uống tháng này", "loai": "Cảnh báo"},
// //     {"noi_dung": "Gợi ý tiết kiệm 10% cho chi tiêu tuần này", "loai": "Gợi ý"},
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     double total = taiKhoan.fold(0, (sum, item) => sum + item['so_du']);

// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Colors.orange,
// //         centerTitle: false,
// //         title: GestureDetector(
// //           onTap: () {
// //             Navigator.push(
// //               context,
// //               MaterialPageRoute(builder: (context) => const ProfileScreen()),
// //             );
// //           },
// //           child: Row(
// //             children: [
// //               const CircleAvatar(
// //                 radius: 20,
// //                 backgroundImage: NetworkImage("https://i.pravatar.cc/150"),
// //               ),
// //               const SizedBox(width: 12),
// //               Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: const [
// //                   Text("HEHEHEHHEHE", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //                   Text("Chào bạn!", style: TextStyle(fontSize: 12)),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.notifications),
// //             onPressed: () {
// //               print("Nhấn vào thông báo");
// //             },
// //           ),
// //         ],
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Card(
// //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //               color: Colors.orange.shade100,
// //               elevation: 4,
// //               child: Padding(
// //                 padding: const EdgeInsets.all(16.0),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     const Text("Tổng số dư", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //                     const SizedBox(height: 8),
// //                     Text("${total.toStringAsFixed(0)} VND",
// //                         style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 16),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 _actionCard(Icons.add_circle, "Thu"),
// //                 _actionCard(Icons.remove_circle, "Chi"),
// //                 _actionCard(Icons.handshake, "Cho vay"),
// //                 _actionCard(Icons.account_balance_wallet, "Đi vay"),
// //               ],
// //             ),
// //             const SizedBox(height: 16),
// //             const Text("Giao dịch gần đây", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //             const SizedBox(height: 8),
// //             ...giaoDich.map(
// //               (gd) => Card(
// //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //                 elevation: 2,
// //                 child: ListTile(
// //                   leading: Icon(
// //                     gd['loai'] == "Thu" ? Icons.arrow_downward : Icons.arrow_upward,
// //                     color: gd['loai'] == "Thu" ? Colors.green : Colors.red,
// //                   ),
// //                   title: Text("${gd['han_muc']}"),
// //                   subtitle: Text("${gd['ngay']}"),
// //                   trailing: Text("${gd['so_tien']} VND"),
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 16),
// //             const Text("Thông báo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //             const SizedBox(height: 8),
// //             ...thongBao.map(
// //               (tb) => Card(
// //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //                 color: tb['loai'] == "Cảnh báo" ? Colors.red.shade100 : Colors.blue.shade100,
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(12.0),
// //                   child: Text(tb['noi_dung']),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //       bottomNavigationBar: CustomBottomNav(currentIndex: 0),
// //     );
// //   }

// //   Widget _actionCard(IconData icon, String label) {
// //     return Card(
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       color: Colors.orange.shade200,
// //       elevation: 3,
// //       child: SizedBox(
// //         width: 70,
// //         height: 70,
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(icon, color: Colors.white, size: 30),
// //             const SizedBox(height: 4),
// //             Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
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
//                       backgroundImage: NetworkImage("https://i.pravatar.cc/150"),
//                     ),
//                     const SizedBox(width: 12),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [
//                         Text("HEHEHEHHEHE", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                         Text("Chào bạn!", style: TextStyle(fontSize: 12)),
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
//                     const Text("Tổng số dư", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 8),
//                     Text("${total.toStringAsFixed(0)} VND",
//                         style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
//             const Text("Giao dịch gần đây", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
//             const Text("Thông báo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             ...thongBao.map(
//               (tb) => Card(
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 color: tb['loai'] == "Cảnh báo" ? Colors.red.shade100 : Colors.blue.shade100,
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
//             Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'bottom_nav.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Biến giới tính để chọn avatar
  String gender = "male"; // male hoặc female

  final List<Map<String, dynamic>> taiKhoan = [
    {"ten": "Tiền mặt", "so_du": 2000000},
    {"ten": "Ngân hàng", "so_du": 5000000},
    {"ten": "Ví điện tử", "so_du": 1500000},
  ];

  final List<Map<String, dynamic>> giaoDichGoc = [
    {"han_muc": "Ăn uống", "so_tien": 50000, "loai": "Chi", "ngay": "2025-10-24"},
    {"han_muc": "Lương", "so_tien": 10000000, "loai": "Thu", "ngay": "2025-10-23"},
    {"han_muc": "Đi lại", "so_tien": 200000, "loai": "Chi", "ngay": "2025-10-22"},
  ];

  final List<Map<String, dynamic>> thongBao = [
    {"noi_dung": "Bạn đã vượt hạn mức chi tiêu Ăn uống tháng này", "loai": "Cảnh báo"},
    {"noi_dung": "Gợi ý tiết kiệm 10% cho chi tiêu tuần này", "loai": "Gợi ý"},
  ];

  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> giaoDich = [];

  @override
  void initState() {
    super.initState();
    giaoDich = List.from(giaoDichGoc);
  }

  void _searchGiaoDich(String query) {
    final ketQua = giaoDichGoc.where((gd) {
      final hanMuc = gd['han_muc'].toString().toLowerCase();
      return hanMuc.contains(query.toLowerCase());
    }).toList();
    setState(() {
      giaoDich = ketQua;
    });
  }

  @override
  Widget build(BuildContext context) {
    double total = taiKhoan.fold(0, (sum, item) => sum + item['so_du']);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: false,
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
                onChanged: _searchGiaoDich,
              )
            : GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.orange,
                      child: Icon(
                        gender == "male" ? Icons.man : Icons.woman,
                        color: Colors.white,
                        size: 28,
                      ),
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
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  giaoDich = List.from(giaoDichGoc);
                }
              });
            },
          ),
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
            // Hành động
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
      bottomNavigationBar: CustomBottomNav(currentIndex: 0),
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
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
