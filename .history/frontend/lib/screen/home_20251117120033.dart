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
import 'bottom_nav.dart';
import 'profile.dart';
import 'report.dart';

const Color primaryColor = Color(0xFFFF6D00); // Cam chủ đạo
const Color highlightColor = Color(0xFFFFA726); // Cam nhạt cho icon
const Color textColor = Color(0xFF333333); // Màu chữ chính
const Color accentColor = Color(0xFFF5F5F5); // Nền trang

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Dữ liệu cứng
  final List<Map<String, dynamic>> taiKhoan = [
    {"ten": "Tiền mặt", "so_du": 2000000, "icon": Icons.account_balance_wallet_rounded},
    {"ten": "Ngân hàng", "so_du": 5000000, "icon": Icons.credit_card_rounded},
    {"ten": "Ví điện tử", "so_du": 1500000, "icon": Icons.payment_rounded},
  ];

  final List<Map<String, dynamic>> giaoDich = [
    {"han_muc": "Ăn uống", "so_tien": 50000, "loai": "Chi", "ngay": "2025-10-24"},
    {"han_muc": "Lương", "so_tien": 10000000, "loai": "Thu", "ngay": "2025-10-23"},
    {"han_muc": "Đi lại", "so_tien": 200000, "loai": "Chi", "ngay": "2025-10-22"},
  ];

  final List<Map<String, String>> thongBao = [
    {"noi_dung": "Bạn đã vượt hạn mức Ăn uống tháng này", "loai": "Cảnh báo"},
    {"noi_dung": "Gợi ý tiết kiệm 10% chi tiêu tuần này", "loai": "Gợi ý"},
  ];

  bool _showBalance = true;

  // Tính tổng
  double get tongSoDu => taiKhoan.fold(0, (sum, tk) => sum + tk['so_du']);
  double get tongThu => giaoDich.where((g) => g['loai'] == 'Thu').fold(0, (sum, g) => sum + g['so_tien']);
  double get tongChi => giaoDich.where((g) => g['loai'] == 'Chi').fold(0, (sum, g) => sum + g['so_tien']);
  double get canDoi => tongThu - tongChi;

  // Định dạng tiền tệ
  String _formatCurrency(double amount) {
    String str = amount.toStringAsFixed(0);
    RegExp reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (Match match) => ',');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: _buildUserHeader(),
        actions: [_buildSearchIcon(), _buildNotificationIcon()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTongSoDuCard(),
            const SizedBox(height: 20),
            _buildThongKeTaiChinh(),
            const SizedBox(height: 20),
            _buildActionButtons(),
            const SizedBox(height: 24),
            _buildTitle("Tài khoản & Ví"),
            const SizedBox(height: 12),
            _buildTaiKhoanList(),
            const SizedBox(height: 24),
            _buildTitle("Giao dịch gần đây"),
            const SizedBox(height: 12),
            _buildGiaoDichList(),
            const SizedBox(height: 24),
            _buildTitle("Thông báo"),
            const SizedBox(height: 12),
            _buildThongBaoList(),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
    );
  }

  Widget _buildUserHeader() {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: primaryColor, size: 30),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Xin chào!", style: TextStyle(fontSize: 14, color: Colors.white70)),
              Text("Quản lý tài chính", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchIcon() => IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {});
  Widget _buildNotificationIcon() => IconButton(icon: const Icon(Icons.notifications, color: Colors.white), onPressed: () {});

  Widget _buildTongSoDuCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tổng số dư hiện có", style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.6))),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _showBalance ? "${_formatCurrency(tongSoDu)} VND" : "******** VND",
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: textColor),
                ),
                IconButton(
                  icon: Icon(_showBalance ? Icons.visibility : Icons.visibility_off, color: highlightColor),
                  onPressed: () {
                    setState(() => _showBalance = !_showBalance);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Xem báo cáo chi tiết", style: TextStyle(color: textColor.withOpacity(0.6))),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 14, color: textColor.withOpacity(0.6)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThongKeTaiChinh() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _financialCard("Thu", tongThu, Colors.green),
        _financialCard("Chi", tongChi, Colors.red),
        _financialCard("Cân đối", canDoi, canDoi >= 0 ? highlightColor : Colors.red),
      ],
    );
  }

  Widget _financialCard(String label, double amount, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              children: [
                Icon(label == "Thu"
                    ? Icons.arrow_downward
                    : label == "Chi"
                        ? Icons.arrow_upward
                        : Icons.balance, color: color, size: 20),
                const SizedBox(height: 4),
                Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor)),
                const SizedBox(height: 4),
                Text("${_formatCurrency(amount.abs())} VND", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _actionCard(Icons.add_circle_outline, "Thêm Thu", Colors.green),
        const SizedBox(width: 20),
        _actionCard(Icons.remove_circle_outline, "Thêm Chi", Colors.red),
      ],
    );
  }

  Widget _actionCard(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor));
  }

  Widget _buildTaiKhoanList() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: taiKhoan.length,
        separatorBuilder: (context, index) => const Divider(height: 1, indent: 20, endIndent: 20),
        itemBuilder: (context, index) {
          final tk = taiKhoan[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: highlightColor.withOpacity(0.2),
              child: Icon(tk['icon'] as IconData?, color: highlightColor),
            ),
            title: Text(tk["ten"], style: const TextStyle(fontWeight: FontWeight.w600)),
            trailing: Text("${_formatCurrency(tk["so_du"].toDouble())} VND", style: const TextStyle(fontWeight: FontWeight.bold, color: textColor)),
            onTap: () {},
          );
        },
      ),
    );
  }

  Widget _buildGiaoDichList() {
    return Column(
      children: giaoDich.map((gd) {
        final isThu = gd['loai'] == "Thu";
        final color = isThu ? Colors.green.shade600 : Colors.red.shade600;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: color.withOpacity(0.1),
                child: Icon(isThu ? Icons.trending_up : Icons.trending_down, color: color),
              ),
              title: Text("${gd['han_muc']}", style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text("${gd['ngay']}", style: const TextStyle(fontSize: 12)),
              trailing: Text("${isThu ? '+' : '-'}${_formatCurrency(gd['so_tien'].toDouble())} VND", style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildThongBaoList() {
    return Column(
      children: thongBao.map((tb) {
        final isCanhBao = tb['loai'] == "Cảnh báo";
        final color = isCanhBao ? Colors.red.shade600 : highlightColor;
        final icon = isCanhBao ? Icons.warning_amber_rounded : Icons.lightbulb_outline;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Card(
            color: color.withOpacity(0.08),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(icon, color: color),
              title: Text(tb['loai']!, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
              subtitle: Text(tb['noi_dung']!),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ),
          ),
        );
      }).toList(),
    );
  }
}
