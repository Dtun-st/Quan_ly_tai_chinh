
// import 'package:flutter/material.dart';

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
import 'package:frontend/screen/bottom_nav.dart'; // ✅ Thêm import bottom nav

class BankScreen extends StatefulWidget {
  const BankScreen({super.key});

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  bool isHidden = false;

  double totalBalance = 12500000;

  List<Map<String, dynamic>> accounts = [
    {"name": "Tiền mặt", "balance": 1500000, "icon": Icons.account_balance_wallet},
    {"name": "Ngân hàng", "balance": 7000000, "icon": Icons.account_balance},
    {"name": "Thẻ tín dụng", "balance": -500000, "icon": Icons.credit_card},
    {"name": "Ví điện tử", "balance": 4500000, "icon": Icons.phone_iphone},
  ];

  Future<void> refreshAccounts() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
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
        onPressed: () {
          // TODO mở form thêm tài khoản
        },
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
            buildAddAccountButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),

      // ✅ Thêm Bottom Nav
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
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
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
            child: Icon(acc["icon"], color: Colors.orange.shade700),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(acc["name"], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
          Text(
            isHidden ? "*****" : "${acc["balance"]} đ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: acc["balance"] < 0 ? Colors.red : Colors.black,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () => openEditDialog(acc),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => confirmDelete(acc),
          ),
        ],
      ),
    );
  }

  Widget buildAddAccountButton() {
    return InkWell(
      onTap: () {
        // TODO mở trang thêm tài khoản
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: const Text(
          "+ Thêm tài khoản",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.orange),
        ),
      ),
    );
  }

  void confirmDelete(Map<String, dynamic> acc) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xóa tài khoản"),
        content: Text("Bạn có chắc muốn xóa '${acc["name"]}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          TextButton(
            onPressed: () {
              setState(() => accounts.remove(acc));
              Navigator.pop(context);
            },
            child: const Text("Xóa", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void openEditDialog(Map<String, dynamic> acc) {
    TextEditingController nameController = TextEditingController(text: acc["name"]);
    TextEditingController balanceController = TextEditingController(text: acc["balance"].toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Sửa tài khoản"),
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
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          TextButton(
            onPressed: () {
              setState(() {
                acc["name"] = nameController.text;
                acc["balance"] = double.tryParse(balanceController.text) ?? acc["balance"];
              });
              Navigator.pop(context);
            },
            child: const Text("Lưu", style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }
}
