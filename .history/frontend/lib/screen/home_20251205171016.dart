import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_nav.dart';
import 'profile.dart';
import 'report.dart';
import '../services/home_service.dart';
import 'history.dart';
import 'notification.dart';

const Color primaryColor = Color(0xFFFF6D00);
const Color highlightColor = Color(0xFFFFA040);
const Color textColor = Color(0xFF333333);
const Color accentColor = Color(0xFFF5F5F5);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> taiKhoan = [];
  List<Map<String, dynamic>> giaoDich = [];
  List<Map<String, dynamic>> thongBao = [];

  bool _loading = true;
  bool _showBalance = true;
  double? budgetMonth;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Future<void> _loadData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   int? userId = prefs.getInt('userId'); // Lấy userId từ login

  //   if (userId != null) {
  //     final service = HomeService();
  //     final accounts = await service.fetchTaiKhoan(userId);
  //     final transactions = await service.fetchGiaoDich(userId);
  //     final notifications = await service.fetchThongBao(userId);

  //     setState(() {
  //       taiKhoan = accounts;
  //       giaoDich = transactions;
  //       thongBao = notifications;
  //       _loading = false;
  //     });
  //   }
  // }
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');

    if (userId != null) {
      final service = HomeService();
      final accounts = await service.fetchTaiKhoan(userId);
      final transactions = await service.fetchGiaoDich(userId);
      final notifications = await service.fetchThongBao(userId);
      final budget = await service.fetchBudget(userId); // 🔥 thêm

      setState(() {
        taiKhoan = accounts;
        giaoDich = transactions;
        thongBao = notifications;
        budgetMonth = budget; // 🔥 load vào UI
        _loading = false;
      });
    }
  }

  double get tongSoDu => taiKhoan.fold(
    0,
    (sum, tk) => sum + (double.tryParse(tk['so_du'].toString()) ?? 0),
  );
  double get tongThu => giaoDich
      .where((g) => g['loai'] == 'Thu')
      .fold(
        0,
        (sum, g) => sum + (double.tryParse(g['so_tien'].toString()) ?? 0),
      );
  double get tongChi => giaoDich
      .where((g) => g['loai'] == 'Chi')
      .fold(
        0,
        (sum, g) => sum + (double.tryParse(g['so_tien'].toString()) ?? 0),
      );
  double get canDoi => tongThu - tongChi;

  String _formatCurrency(double amount) {
    String str = amount.toStringAsFixed(0);
    RegExp reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (Match match) => ',');
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
            _buildBudgetCard(),
            const SizedBox(height: 20),
            _buildActionButtons(),
            const SizedBox(height: 24),
            _buildTitle("Tài khoản & Ví"),
            const SizedBox(height: 12),
            _buildTaiKhoanList(),
            const SizedBox(height: 24),
            _buildTitleWithIcon(
              "Giao dịch gần đây",
              Icons.history,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryScreen(
                      onUpdate: () async {
                        await _loadData();
                      },
                    ),
                  ),
                );
              },
            ),
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

  // ----------------- Header -----------------
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
              Text(
                "Xin chào!",
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              Text(
                "Quản lý tài chính",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchIcon() => IconButton(
    icon: const Icon(Icons.search, color: Colors.white),
    onPressed: () {},
  );
  Widget _buildNotificationIcon() {
    // Số lượng thông báo chưa đọc
    int unreadCount = thongBao.where((tb) => tb['da_doc'] == 0).length;

    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {
            // Chuyển sang trang thông báo
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationScreen(),
              ),
            );
          },
        ),
        if (unreadCount > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                '$unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  // ----------------- Tổng số dư -----------------
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
            Text(
              "Tổng số dư hiện có",
              style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.6)),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _showBalance
                      ? "${_formatCurrency(tongSoDu)} VND"
                      : "******** VND",
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _showBalance ? Icons.visibility : Icons.visibility_off,
                    color: highlightColor,
                  ),
                  onPressed: () => setState(() => _showBalance = !_showBalance),
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
                  Text(
                    "Xem báo cáo chi tiết",
                    style: TextStyle(color: textColor.withOpacity(0.6)),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: textColor.withOpacity(0.6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------- Thống kê tài chính -----------------
  Widget _buildThongKeTaiChinh() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _financialCard("Thu", tongThu, Colors.green),
        _financialCard("Chi", tongChi, Colors.red),
        _financialCard(
          "Cân đối",
          canDoi,
          canDoi >= 0 ? highlightColor : Colors.red,
        ),
      ],
    );
  }

  Widget _financialCard(String label, double amount, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              children: [
                Icon(
                  label == "Thu"
                      ? Icons.arrow_downward
                      : label == "Chi"
                      ? Icons.arrow_upward
                      : Icons.balance,
                  color: color,
                  size: 20,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${_formatCurrency(amount.abs())} VND",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ----------------- Ngân sách -----------------
  Widget _buildBudgetCard() {
    double spentMonth = tongChi;
    if (budgetMonth == null) {
      return Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ngân sách tháng",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Chưa đặt ngân sách",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _showBudgetDialog,
                child: const Text("Đặt ngân sách"),
              ),
            ],
          ),
        ),
      );
    } else {
      double percentUsed = (spentMonth / budgetMonth!).clamp(0, 1);
      Color progressColor = percentUsed >= 1.0
          ? Colors.red
          : percentUsed >= 0.8
          ? Colors.orange
          : Colors.green;
      return Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ngân sách tháng",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
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
                  Text("Ngân sách: ${_formatCurrency(budgetMonth!)} VND"),
                ],
              ),
              if (percentUsed >= 0.8)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    percentUsed >= 1.0
                        ? "Bạn đã vượt ngân sách!"
                        : "Sắp hết ngân sách!",
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _showBudgetDialog,
                child: const Text("Chỉnh sửa ngân sách"),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _showBudgetDialog() async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');

    final controller = TextEditingController(
      text: budgetMonth?.toStringAsFixed(0) ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Đặt ngân sách tháng"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Số tiền VND"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () async {
                double? value = double.tryParse(controller.text);
                if (value != null && value > 0) {
                  bool success = await HomeService().saveBudget(userId!, value);

                  if (success) {
                    setState(() => budgetMonth = value);
                  }
                }
                Navigator.pop(context);
              },
              child: const Text("Lưu"),
            ),
          ],
        );
      },
    );
  }

  // ----------------- Hành động -----------------
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
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------- Title -----------------
  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  Widget _buildTitleWithIcon(
    String title,
    IconData icon, {
    required VoidCallback onPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        IconButton(
          icon: Icon(icon, color: primaryColor),
          onPressed: onPressed,
        ),
      ],
    );
  }

  // ----------------- Danh sách -----------------
  Widget _buildTaiKhoanList() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: taiKhoan.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, indent: 20, endIndent: 20),
        itemBuilder: (context, index) {
          final tk = taiKhoan[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: highlightColor.withOpacity(0.2),
              child: Icon(Icons.account_balance_wallet, color: highlightColor),
            ),
            title: Text(
              tk["ten"],
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: Text(
              "${_formatCurrency(double.tryParse(tk["so_du"].toString()) ?? 0)} VND",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            onTap: () {},
          );
        },
      ),
    );
  }

  Widget _buildGiaoDichList() {
    final recent = giaoDich.take(5).toList();
    return Column(
      children: recent.map((gd) {
        final isThu = gd['loai'] == "Thu";
        final color = isThu ? Colors.green.shade600 : Colors.red.shade600;
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(
                isThu ? Icons.trending_up : Icons.trending_down,
                color: color,
              ),
            ),
            title: Text("${gd['han_muc']}"),
            subtitle: Text("${gd['ngay']}"),
            trailing: Text(
              "${isThu ? '+' : '-'}${_formatCurrency(double.tryParse(gd['so_tien'].toString()) ?? 0)} VND",
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildThongBaoList() {
    // Sắp xếp theo ngày tạo giảm dần và lấy 5 cái gần nhất
    final recentNotifications = List.from(thongBao)
      ..sort((a, b) {
        final dateA = DateTime.tryParse(a['ngay_tao'] ?? '') ?? DateTime(2000);
        final dateB = DateTime.tryParse(b['ngay_tao'] ?? '') ?? DateTime(2000);
        return dateB.compareTo(dateA); // giảm dần
      });

    final top5 = recentNotifications.take(5).toList();

    return Column(
      children: top5.map((tb) {
        return Card(
          child: ListTile(
            leading: Icon(Icons.notifications, color: primaryColor),
            title: Text("${tb['noi_dung']}"),
            subtitle: Text("${tb['loai']}"),
          ),
        );
      }).toList(),
    );
  }
}
