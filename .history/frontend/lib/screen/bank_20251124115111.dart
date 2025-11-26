import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/bank_service.dart';
import 'bottom_nav.dart';

class BankScreen extends StatefulWidget {
  const BankScreen({super.key});

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  bool isHidden = false;
  double totalBalance = 0;
  List<Map<String, dynamic>> accounts = [];
  int? userId;
  final BankService _service = BankService();

  @override
  void initState() {
    super.initState();
    _initUser();
  }

  Future<void> _initUser() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId');
    if (userId != null) await _loadAccounts();
  }

  double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  Future<void> _loadAccounts() async {
    final list = await _service.getAccounts();
    setState(() {
      accounts = list;
      totalBalance = accounts.fold(0,
          (sum, acc) => sum + _parseDouble(acc['so_du']));
    });
  }

  Future<void> _refreshAccounts() async => await _loadAccounts();

  void _openAccountForm({Map<String, dynamic>? account}) {
    final nameController =
        TextEditingController(text: account?['ten_tai_khoan'] ?? '');
    final balanceController = TextEditingController(
        text: account != null ? _parseDouble(account['so_du']).toString() : '');
    String selectedType = account?['loai_tai_khoan'] ?? 'Tiền mặt';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(account == null ? 'Thêm tài khoản' : 'Sửa tài khoản'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Tên tài khoản"),
            ),
            TextField(
              controller: balanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Số dư"),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedType,
              items: ['Tiền mặt', 'Ngân hàng', 'Thẻ tín dụng', 'Ví điện tử']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => selectedType = val ?? 'Tiền mặt',
              decoration: const InputDecoration(labelText: "Loại tài khoản"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          TextButton(
            onPressed: () async {
              final data = {
                "nguoi_dung_id": userId,
                "ten_tai_khoan": nameController.text,
                "loai_tai_khoan": selectedType,
                "so_du": double.tryParse(balanceController.text) ?? 0,
              };

              bool success = account == null
                  ? await _service.addAccount(data)
                  : await _service.editAccount(account['id'], data);

              if (success) {
                Navigator.pop(context);
                await _loadAccounts();
              }
            },
            child: Text(account == null ? "Thêm" : "Lưu",
                style: const TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Map<String, dynamic> acc) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xóa tài khoản"),
        content: Text("Bạn có chắc muốn xóa '${acc["ten_tai_khoan"]}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          TextButton(
            onPressed: () async {
              bool success = await _service.deleteAccount(acc['id']);
              if (success) {
                Navigator.pop(context);
                await _loadAccounts();
              }
            },
            child: const Text("Xóa", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Tài khoản"),
        actions: [
          IconButton(
            icon: Icon(isHidden ? Icons.visibility_off : Icons.visibility, color: Colors.white),
            onPressed: () => setState(() => isHidden = !isHidden),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () => _openAccountForm(),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAccounts,
        child: ListView(
          children: [
            _buildTotalBalance(),
            const SizedBox(height: 8),
            ...accounts.map((acc) => _buildAccountCard(acc)).toList(),
            const SizedBox(height: 18),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }

  Widget _buildTotalBalance() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Tổng tài sản", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 6),
          Text(
            isHidden ? "********" : "${totalBalance.toStringAsFixed(0)} đ",
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(Map<String, dynamic> acc) {
    double balance = _parseDouble(acc['so_du']);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
        boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.12), blurRadius: 6, offset: const Offset(1, 3))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.orange.shade100,
            child: Icon(acc["icon"] ?? Icons.account_balance_wallet, color: Colors.orange.shade700),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(acc["ten_tai_khoan"], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
          Text(isHidden ? "*****" : "${balance.toStringAsFixed(0)} đ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: balance < 0 ? Colors.red : Colors.black)),
          const SizedBox(width: 8),
          IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _openAccountForm(account: acc)),
          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _confirmDelete(acc)),
        ],
      ),
    );
  }
}
