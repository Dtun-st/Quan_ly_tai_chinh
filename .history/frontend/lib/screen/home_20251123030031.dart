// import 'package:flutter/material.dart';
// import 'bottom_nav.dart';
// import 'profile.dart';
// import 'report.dart';

// const Color primaryColor = Color(0xFFFF6D00); // Cam chủ đạo
// const Color highlightColor = Color(0xFFFFA040); // Cam nhạt cho icon
// const Color textColor = Color(0xFF333333); // Màu chữ chính
// const Color accentColor = Color(0xFFF5F5F5); // Nền trang

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   // Dữ liệu cứng
//   final List<Map<String, dynamic>> taiKhoan = [
//     {"ten": "Tiền mặt", "so_du": 2000000, "icon": Icons.account_balance_wallet_rounded},
//     {"ten": "Ngân hàng", "so_du": 5000000, "icon": Icons.credit_card_rounded},
//     {"ten": "Ví điện tử", "so_du": 1500000, "icon": Icons.payment_rounded},
//   ];

//   final List<Map<String, dynamic>> giaoDich = [
//     {"han_muc": "Ăn uống", "so_tien": 50000, "loai": "Chi", "ngay": "2025-10-24"},
//     {"han_muc": "Lương", "so_tien": 10000000, "loai": "Thu", "ngay": "2025-10-23"},
//     {"han_muc": "Đi lại", "so_tien": 200000, "loai": "Chi", "ngay": "2025-10-22"},
//   ];

//   final List<Map<String, String>> thongBao = [
//     {"noi_dung": "Bạn đã vượt hạn mức Ăn uống tháng này", "loai": "Cảnh báo"},
//     {"noi_dung": "Gợi ý tiết kiệm 10% chi tiêu tuần này", "loai": "Gợi ý"},
//   ];

//   bool _showBalance = true;

//   // Tính tổng
//   double get tongSoDu => taiKhoan.fold(0, (sum, tk) => sum + tk['so_du']);
//   double get tongThu => giaoDich.where((g) => g['loai'] == 'Thu').fold(0, (sum, g) => sum + g['so_tien']);
//   double get tongChi => giaoDich.where((g) => g['loai'] == 'Chi').fold(0, (sum, g) => sum + g['so_tien']);
//   double get canDoi => tongThu - tongChi;

//   // Định dạng tiền tệ
//   String _formatCurrency(double amount) {
//     String str = amount.toStringAsFixed(0);
//     RegExp reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
//     return str.replaceAllMapped(reg, (Match match) => ',');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: accentColor,
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         elevation: 0,
//         title: _buildUserHeader(),
//         actions: [_buildSearchIcon(), _buildNotificationIcon()],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildTongSoDuCard(),
//             const SizedBox(height: 20),
//             _buildThongKeTaiChinh(),
//             const SizedBox(height: 20),
//             _buildActionButtons(),
//             const SizedBox(height: 24),
//             _buildTitle("Tài khoản & Ví"),
//             const SizedBox(height: 12),
//             _buildTaiKhoanList(),
//             const SizedBox(height: 24),
//             _buildTitle("Giao dịch gần đây"),
//             const SizedBox(height: 12),
//             _buildGiaoDichList(),
//             const SizedBox(height: 24),
//             _buildTitle("Thông báo"),
//             const SizedBox(height: 12),
//             _buildThongBaoList(),
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//       bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
//     );
//   }

//   Widget _buildUserHeader() {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const ProfileScreen()),
//         );
//       },
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 20,
//             backgroundColor: Colors.white,
//             child: Icon(Icons.person, color: primaryColor, size: 30),
//           ),
//           const SizedBox(width: 12),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: const [
//               Text("Xin chào!", style: TextStyle(fontSize: 14, color: Colors.white70)),
//               Text("Quản lý tài chính", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchIcon() => IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {});
//   Widget _buildNotificationIcon() => IconButton(icon: const Icon(Icons.notifications, color: Colors.white), onPressed: () {});

//   Widget _buildTongSoDuCard() {
//     return Card(
//       color: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 5,
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Tổng số dư hiện có", style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.6))),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   _showBalance ? "${_formatCurrency(tongSoDu)} VND" : "******** VND",
//                   style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: textColor),
//                 ),
//                 IconButton(
//                   icon: Icon(_showBalance ? Icons.visibility : Icons.visibility_off, color: highlightColor),
//                   onPressed: () {
//                     setState(() => _showBalance = !_showBalance);
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const ReportScreen()),
//                 );
//               },
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Text("Xem báo cáo chi tiết", style: TextStyle(color: textColor.withOpacity(0.6))),
//                   const SizedBox(width: 4),
//                   Icon(Icons.arrow_forward_ios, size: 14, color: textColor.withOpacity(0.6)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildThongKeTaiChinh() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _financialCard("Thu", tongThu, Colors.green),
//         _financialCard("Chi", tongChi, Colors.red),
//         _financialCard("Cân đối", canDoi, canDoi >= 0 ? highlightColor : Colors.red),
//       ],
//     );
//   }

//   Widget _financialCard(String label, double amount, Color color) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 4.0),
//         child: Card(
//           color: Colors.white,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           elevation: 2,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//             child: Column(
//               children: [
//                 Icon(label == "Thu"
//                     ? Icons.arrow_downward
//                     : label == "Chi"
//                         ? Icons.arrow_upward
//                         : Icons.balance, color: color, size: 20),
//                 const SizedBox(height: 4),
//                 Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor)),
//                 const SizedBox(height: 4),
//                 Text("${_formatCurrency(amount.abs())} VND", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButtons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _actionCard(Icons.add_circle_outline, "Thu", Colors.green),
//         const SizedBox(width: 20),0
//         _actionCard(Icons.remove_circle_outline, "Chi", Colors.red),
//       ],
//     );
//   }

//   Widget _actionCard(IconData icon, String label, Color color) {
//     return GestureDetector(
//       onTap: () {},
//       child: Container(
//         width: 150,
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: color.withOpacity(0.3)),
//         ),
//         child: Column(
//           children: [
//             Icon(icon, color: color, size: 30),
//             const SizedBox(height: 8),
//             Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTitle(String title) {
//     return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor));
//   }

//   Widget _buildTaiKhoanList() {
//     return Card(
//       color: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 2,
//       child: ListView.separated(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: taiKhoan.length,
//         separatorBuilder: (context, index) => const Divider(height: 1, indent: 20, endIndent: 20),
//         itemBuilder: (context, index) {
//           final tk = taiKhoan[index];
//           return ListTile(
//             leading: CircleAvatar(
//               backgroundColor: highlightColor.withOpacity(0.2),
//               child: Icon(tk['icon'] as IconData?, color: highlightColor),
//             ),
//             title: Text(tk["ten"], style: const TextStyle(fontWeight: FontWeight.w600)),
//             trailing: Text("${_formatCurrency(tk["so_du"].toDouble())} VND", style: const TextStyle(fontWeight: FontWeight.bold, color: textColor)),
//             onTap: () {},
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildGiaoDichList() {
//     return Column(
//       children: giaoDich.map((gd) {
//         final isThu = gd['loai'] == "Thu";
//         final color = isThu ? Colors.green.shade600 : Colors.red.shade600;
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 8.0),
//           child: Card(
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             child: ListTile(
//               leading: CircleAvatar(
//                 radius: 20,
//                 backgroundColor: color.withOpacity(0.1),
//                 child: Icon(isThu ? Icons.trending_up : Icons.trending_down, color: color),
//               ),
//               title: Text("${gd['han_muc']}", style: const TextStyle(fontWeight: FontWeight.w600)),
//               subtitle: Text("${gd['ngay']}", style: const TextStyle(fontSize: 12)),
//               trailing: Text("${isThu ? '+' : '-'}${_formatCurrency(gd['so_tien'].toDouble())} VND", style: TextStyle(color: color, fontWeight: FontWeight.bold)),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildThongBaoList() {
//     return Column(
//       children: thongBao.map((tb) {
//         final isCanhBao = tb['loai'] == "Cảnh báo";
//         final color = isCanhBao ? Colors.red.shade600 : highlightColor;
//         final icon = isCanhBao ? Icons.warning_amber_rounded : Icons.lightbulb_outline;
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 8.0),
//           child: Card(
//             color: color.withOpacity(0.08),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             child: ListTile(
//               leading: Icon(icon, color: color),
//               title: Text(tb['loai']!, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
//               subtitle: Text(tb['noi_dung']!),
//               trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'bottom_nav.dart';
import 'profile.dart';
import 'report.dart';

const Color primaryColor = Color(0xFFFF6D00); // Cam chủ đạo
const Color highlightColor = Color(0xFFFFA040); // Cam nhạt cho icon
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

  // Ngân sách tháng (có thể nâng cấp thành thiết lập của người dùng)
  final double budgetMonth = 5000000;

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
            const SizedBox(height: 16),
            _buildBudgetCard(), // <-- Thêm ngân sách tháng
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReportScreen()),
                );
              },
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

  Widget _buildBudgetCard() {
    final double spentMonth = tongChi;
    final double remaining = budgetMonth - spentMonth;
    final double percentUsed = (spentMonth / budgetMonth).clamp(0, 1);

    Color progressColor;
    if (percentUsed >= 1.0) {
      progressColor = Colors.red;
    } else if (percentUsed >= 0.8) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.green;
    }

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Ngân sách tháng", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentUsed,
              color: progressColor,
              backgroundColor: Colors.grey.shade200,
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Đã chi: ${_formatCurrency(spentMonth)} VND"),
                Text("Ngân sách: ${_formatCurrency(budgetMonth)} VND"),
              ],
            ),
            if (percentUsed >= 0.8)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  percentUsed >= 1.0 ? "Bạn đã vượt ngân sách!" : "Sắp hết ngân sách!",
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _actionCard(Icons.add_circle_outline, "Thu", Colors.green),
        const SizedBox(width: 20),
        _actionCard(Icons.remove_circle_outline, "Chi", Colors.red),
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
