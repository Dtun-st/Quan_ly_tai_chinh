// import 'package:flutter/material.dart';
// import 'package:frontend/screen/bottom_nav.dart'; 

// class BankScreen extends StatefulWidget {
//   const BankScreen({super.key});

//   @override
//   State<BankScreen> createState() => _BankScreenState();
// }

// class _BankScreenState extends State<BankScreen> {
//   bool isHidden = false;

//   double totalBalance = 12500000;

//   List<Map<String, dynamic>> accounts = [
//     {"name": "Tiền mặt", "balance": 1500000, "icon": Icons.account_balance_wallet},
//     {"name": "Ngân hàng", "balance": 7000000, "icon": Icons.account_balance},
//     {"name": "Thẻ tín dụng", "balance": -500000, "icon": Icons.credit_card},
//     {"name": "Ví điện tử", "balance": 4500000, "icon": Icons.phone_iphone},
//   ];

//   Future<void> refreshAccounts() async {
//     await Future.delayed(const Duration(seconds: 1));
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.orange,
//         title: const Text("Tài khoản"),
//         actions: [
//           IconButton(
//             icon: Icon(isHidden ? Icons.visibility_off : Icons.visibility, color: Colors.white),
//             onPressed: () => setState(() => isHidden = !isHidden),
//           )
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.orange,
//         onPressed: () {
//           // TODO mở form thêm tài khoản
//         },
//         child: const Icon(Icons.add),
//       ),
//       body: RefreshIndicator(
//         onRefresh: refreshAccounts,
//         child: ListView(
//           children: [
//             buildTotalBalance(),
//             const SizedBox(height: 8),
//             ...accounts.map((acc) => buildAccountCard(acc)).toList(),
//             const SizedBox(height: 18),
//             buildAddAccountButton(),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),

//       // ✅ Thêm Bottom Nav
//       bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
//     );
//   }

//   Widget buildTotalBalance() {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.orange.shade50,
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(12),
//           bottomRight: Radius.circular(12),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text("Tổng tài sản", style: TextStyle(fontSize: 16)),
//           const SizedBox(height: 6),
//           Text(
//             isHidden ? "********" : "${totalBalance.toStringAsFixed(0)} đ",
//             style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildAccountCard(Map<String, dynamic> acc) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.orange.shade200),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.orange.withOpacity(0.12),
//             blurRadius: 6,
//             offset: const Offset(1, 3),
//           )
//         ],
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundColor: Colors.orange.shade100,
//             child: Icon(acc["icon"], color: Colors.orange.shade700),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Text(acc["name"], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//           ),
//           Text(
//             isHidden ? "*****" : "${acc["balance"]} đ",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: acc["balance"] < 0 ? Colors.red : Colors.black,
//             ),
//           ),
//           const SizedBox(width: 8),
//           IconButton(
//             icon: const Icon(Icons.edit, color: Colors.blue),
//             onPressed: () => openEditDialog(acc),
//           ),
//           IconButton(
//             icon: const Icon(Icons.delete, color: Colors.red),
//             onPressed: () => confirmDelete(acc),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildAddAccountButton() {
//     return InkWell(
//       onTap: () {
//         // TODO mở trang thêm tài khoản
//       },
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         alignment: Alignment.center,
//         child: const Text(
//           "+ Thêm tài khoản",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.orange),
//         ),
//       ),
//     );
//   }

//   void confirmDelete(Map<String, dynamic> acc) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Xóa tài khoản"),
//         content: Text("Bạn có chắc muốn xóa '${acc["name"]}'?"),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
//           TextButton(
//             onPressed: () {
//               setState(() => accounts.remove(acc));
//               Navigator.pop(context);
//             },
//             child: const Text("Xóa", style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }

//   void openEditDialog(Map<String, dynamic> acc) {
//     TextEditingController nameController = TextEditingController(text: acc["name"]);
//     TextEditingController balanceController = TextEditingController(text: acc["balance"].toString());

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Sửa tài khoản"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: "Tên tài khoản"),
//             ),
//             TextField(
//               controller: balanceController,
//               decoration: const InputDecoration(labelText: "Số dư"),
//               keyboardType: TextInputType.number,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 acc["name"] = nameController.text;
//                 acc["balance"] = double.tryParse(balanceController.text) ?? acc["balance"];
//               });
//               Navigator.pop(context);
//             },
//             child: const Text("Lưu", style: TextStyle(color: Colors.orange)),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:frontend/screen/bottom_nav.dart';
import '../services/bank_service.dart';

class BankScreen extends StatefulWidget {
  const BankScreen({super.key});

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  bool isHidden = false;
  double totalBalance = 0;
  List<Map<String, dynamic>> accounts = [];
  final int userId = 1; // TODO: thay bằng userId đăng nhập

  @override
  void initState() {
    super.initState();
    loadAccounts();
  }

  double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  Future<void> loadAccounts() async {
    final service = BankService();
    final list = await service.getAccounts(userId);
    setState(() {
      accounts = list;
      totalBalance = accounts.fold(
          0, (sum, acc) => sum + _parseDouble(acc['so_du']));
    });
  }

  Future<void> refreshAccounts() async {
    await loadAccounts();
  }

  void openAccountForm({Map<String, dynamic>? account}) {
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
              decoration: const InputDecoration(labelText: "Số dư"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedType,
              items: [
                'Tiền mặt',
                'Ngân hàng',
                'Thẻ tín dụng',
                'Ví điện tử'
              ]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => selectedType = val ?? 'Tiền mặt',
              decoration: const InputDecoration(labelText: "Loại tài khoản"),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          TextButton(
            onPressed: () async {
              final service = BankService();
              final newAccount = {
                "nguoi_dung_id": userId,
                "ten_tai_khoan": nameController.text,
                "loai_tai_khoan": selectedType,
                "so_du": double.tryParse(balanceController.text) ?? 0,
              };

              bool success = false;
              if (account == null) {
                success = await service.addAccount(newAccount);
              } else {
                success = await service.editAccount(account['id'], {
                  "ten_tai_khoan": nameController.text,
                  "loai_tai_khoan": selectedType,
                  "so_du": double.tryParse(balanceController.text) ?? 0,
                });
              }

              if (success) {
                Navigator.pop(context);
                await loadAccounts();
              }
            },
            child: Text(account == null ? "Thêm" : "Lưu",
                style: const TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void confirmDelete(Map<String, dynamic> acc) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xóa tài khoản"),
        content: Text("Bạn có chắc muốn xóa '${acc["ten_tai_khoan"]}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          TextButton(
            onPressed: () async {
              final service = BankService();
              bool success = await service.deleteAccount(acc['id']);
              if (success) {
                Navigator.pop(context);
                await loadAccounts();
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
            icon: Icon(
                isHidden ? Icons.visibility_off : Icons.visibility,
                color: Colors.white),
            onPressed: () => setState(() => isHidden = !isHidden),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () => openAccountForm(),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: refreshAccounts,
        child: ListView(
          children: [
            buildTotalBalance(),
            const SizedBox(height: 8),
            ...accounts.map((acc) => buildAccountCard(acc)).toList(),
            const SizedBox(height: 18),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }

  Widget buildTotalBalance() {
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
            style: const TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget buildAccountCard(Map<String, dynamic> acc) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.12),
            blurRadius: 6,
            offset: const Offset(1, 3),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.orange.shade100,
            child: Icon(acc["icon"] ?? Icons.account_balance_wallet,
                color: Colors.orange.shade700),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(acc["ten_tai_khoan"],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
          Text(
            isHidden ? "*****" : "${_parseDouble(acc["so_du"]).toStringAsFixed(0)} đ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _parseDouble(acc["so_du"]) < 0 ? Colors.red : Colors.black,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () => openAccountForm(account: acc),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => confirmDelete(acc),
          ),
        ],
      ),
    );
  }
}
