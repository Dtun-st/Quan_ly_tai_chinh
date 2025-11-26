// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:frontend/services/transaction_service.dart';
// import 'package:frontend/screen/bottom_nav.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';

// class TransactionScreen extends StatefulWidget {
//   const TransactionScreen({super.key});

//   @override
//   State<TransactionScreen> createState() => _TransactionScreenState();
// }

// class _TransactionScreenState extends State<TransactionScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TransactionService _service = TransactionService();

//   int? currentUserId;

//   int? selectedAccountId;
//   int? selectedCategoryId;
//   String type = 'Chi';
//   final TextEditingController _amountCtrl = TextEditingController();
//   final TextEditingController _descCtrl = TextEditingController();
//   DateTime selectedDate = DateTime.now();

//   int? editingTransactionId;

//   final List<Map<String, dynamic>> accounts = [
//     {"id": 1, "name": "Tiền mặt", "icon": Icons.money},
//     {"id": 2, "name": "Thẻ tín dụng", "icon": Icons.credit_card},
//     {"id": 3, "name": "Ngân hàng", "icon": Icons.account_balance},
//     {"id": 4, "name": "Ví điện tử", "icon": Icons.account_balance_wallet},
//   ];

//   final List<Map<String, dynamic>> categories = [
//     {"id": 1, "name": "Ăn uống", "icon": Icons.restaurant},
//     {"id": 2, "name": "Di chuyển", "icon": Icons.directions_car},
//     {"id": 3, "name": "Hóa đơn", "icon": Icons.receipt_long},
//     {"id": 4, "name": "Mua sắm", "icon": Icons.shopping_cart},
//     {"id": 5, "name": "Giải trí", "icon": Icons.movie},
//     {"id": 6, "name": "Khác", "icon": Icons.more_horiz},
//   ];

//   final Map<String, Color> categoryColors = {
//     "Ăn uống": Colors.deepOrange,
//     "Di chuyển": Colors.blue,
//     "Hóa đơn": Colors.green,
//     "Mua sắm": Colors.purple,
//     "Giải trí": Colors.red,
//     "Khác": Colors.grey,
//   };

//   List<Map<String, dynamic>> _transactions = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadUserId();
//     if (accounts.isNotEmpty) selectedAccountId = accounts.first['id'];
//     if (categories.isNotEmpty) selectedCategoryId = categories.first['id'];
//   }

//   Future<void> _loadUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     final id = prefs.getInt('userId');
//     setState(() => currentUserId = id);
//     _loadTransactions();
//   }

//   Future<void> _loadTransactions() async {
//     if (currentUserId == null) return;
//     final allTx = await _service.getTransactions(nguoiDungId: currentUserId);
//     setState(() => _transactions = allTx.reversed.toList());
//   }

//   Future<void> _pickDate() async {
//     final DateTime? d = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (d != null) setState(() => selectedDate = d);
//   }

//   void _saveOrUpdateTransaction() async {
//     if (!_formKey.currentState!.validate() || currentUserId == null) return;

//     final double amount = double.tryParse(_amountCtrl.text) ?? 0;

//     final data = {
//       "nguoiDungId": currentUserId,
//       "taiKhoanId": selectedAccountId,
//       "hanMucId": selectedCategoryId,
//       "loaiGd": type,
//       "soTien": amount,
//       "moTa": _descCtrl.text,
//       "ngayGiaoDich": selectedDate.toIso8601String(),
//     };

//     bool success = false;

//     if (editingTransactionId == null) {
//       success = await _service.saveTransaction(data);
//     } else {
//       success = await _service.updateTransaction(editingTransactionId!, data);
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(success
//             ? (editingTransactionId == null ? 'Đã lưu giao dịch' : 'Đã cập nhật giao dịch')
//             : 'Thao tác thất bại'),
//         backgroundColor: Colors.orange,
//       ),
//     );

//     if (success) {
//       _amountCtrl.clear();
//       _descCtrl.clear();
//       setState(() {
//         type = 'Chi';
//         selectedDate = DateTime.now();
//         if (accounts.isNotEmpty) selectedAccountId = accounts.first['id'];
//         if (categories.isNotEmpty) selectedCategoryId = categories.first['id'];
//         editingTransactionId = null;
//       });
//       _loadTransactions();
//     }
//   }

//   void _editTransaction(Map<String, dynamic> tx) {
//     setState(() {
//       editingTransactionId = tx['id'];
//       selectedAccountId = tx['taiKhoanId'] ?? accounts.first['id'];
//       selectedCategoryId = tx['hanMucId'] ?? categories.first['id'];
//       type = tx['loaiGd'] ?? 'Chi';
//       _amountCtrl.text = (tx['soTien'] ?? 0).toString();
//       _descCtrl.text = tx['moTa'] ?? '';
//       selectedDate = DateTime.tryParse(tx['ngayGiaoDich'] ?? '') ?? DateTime.now();
//     });
//   }

//   void _deleteTransaction(int id) async {
//     final success = await _service.deleteTransaction(id);
//     if (success) {
//       _loadTransactions();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Đã xóa giao dịch'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   Widget _typeToggle() {
//     final options = ['Chi', 'Thu', 'Cho vay', 'Đi vay'];
//     return Wrap(
//       spacing: 8,
//       children: options.map((opt) {
//         final active = opt == type;
//         return ChoiceChip(
//           label: Text(opt),
//           selected: active,
//           onSelected: (_) => setState(() => type = opt),
//         );
//       }).toList(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (currentUserId == null) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Ghi chép'),
//         backgroundColor: Colors.orange,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Chọn tài khoản', style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   DropdownButtonFormField<int>(
//                     value: selectedAccountId,
//                     items: accounts
//                         .map(
//                           (a) => DropdownMenuItem<int>(
//                             value: a['id'],
//                             child: Row(
//                               children: [
//                                 Icon(a['icon']),
//                                 const SizedBox(width: 8),
//                                 Text(a['name']),
//                               ],
//                             ),
//                           ),
//                         )
//                         .toList(),
//                     onChanged: (v) => setState(() => selectedAccountId = v),
//                   ),
//                   const SizedBox(height: 12),
//                   const Text('Chọn hạng mục', style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   DropdownButtonFormField<int>(
//                     value: selectedCategoryId,
//                     items: categories
//                         .map(
//                           (c) => DropdownMenuItem<int>(
//                             value: c['id'],
//                             child: Row(
//                               children: [
//                                 Icon(c['icon']),
//                                 const SizedBox(width: 8),
//                                 Text(c['name']),
//                               ],
//                             ),
//                           ),
//                         )
//                         .toList(),
//                     onChanged: (v) => setState(() => selectedCategoryId = v),
//                   ),
//                   const SizedBox(height: 12),
//                   const Text('Loại giao dịch', style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   _typeToggle(),
//                   const SizedBox(height: 12),
//                   const Text('Số tiền', style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   TextFormField(
//                     controller: _amountCtrl,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(prefixText: 'VND ', hintText: 'Nhập số tiền'),
//                     validator: (v) {
//                       if (v == null || v.isEmpty) return 'Nhập số tiền';
//                       if (double.tryParse(v) == null) return 'Số tiền không hợp lệ';
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 12),
//                   const Text('Ngày', style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   InkWell(
//                     onTap: _pickDate,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey.shade300),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
//                           const Icon(Icons.calendar_month),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   const Text('Mô tả (tuỳ chọn)', style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   TextFormField(controller: _descCtrl, maxLines: 2, decoration: const InputDecoration(hintText: 'Ghi chú thêm')),
//                   const SizedBox(height: 20),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _saveOrUpdateTransaction,
//                       style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.symmetric(vertical: 14)),
//                       child: Text(editingTransactionId == null ? 'Lưu giao dịch' : 'Cập nhật giao dịch', style: const TextStyle(fontSize: 16)),
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                 ],
//               ),
//             ),

//             // Danh sách giao dịch
//             const Text('Giao dịch gần nhất', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//             const SizedBox(height: 8),
//             if (_transactions.isEmpty)
//               const Text('Chưa có giao dịch nào')
//             else
//               Column(
//                 children: _transactions.map((tx) {
//                   final rawDate = tx['ngayGiaoDich'] ?? DateTime.now().toIso8601String();
//                   final date = DateTime.tryParse(rawDate) ?? DateTime.now();
//                   final categoryId = tx['hanMucId'] ?? -1;
//                   final categoryName = categories.firstWhere(
//                     (c) => c['id'] == categoryId,
//                     orElse: () => {"name": "Khác"},
//                   )['name']?.toString() ?? "Khác";
//                   final color = categoryColors[categoryName] ?? Colors.grey;

//                   double amountDouble = 0;
//                   try {
//                     amountDouble = tx['soTien'] is int
//                         ? (tx['soTien'] as int).toDouble()
//                         : tx['soTien'] is double
//                             ? tx['soTien'] as double
//                             : double.parse(tx['soTien'].toString());
//                   } catch (_) {}

//                   final amount = NumberFormat('#,###').format(amountDouble);
//                   final desc = tx['moTa']?.toString() ?? '';
//                   final iconType = (tx['loaiGd'] ?? 'Chi') == 'Chi' ? Icons.remove : Icons.add;

//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     child: ListTile(
//                       leading: Icon(iconType, color: color),
//                       title: Text('$amount VND - $desc'),
//                       subtitle: Text('Ngày: ${date.day}/${date.month}/${date.year}'),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _editTransaction(tx)),
//                           IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteTransaction(tx['id'] ?? 0)),
//                         ],
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
//     );
//   }

//   @override
//   void dispose() {
//     _amountCtrl.dispose();
//     _descCtrl.dispose();
//     super.dispose();
//   }
// }
import 'package:flutter/material.dart';
import 'bottom_nav.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  String type = 'Chi';
  DateTime selectedDate = DateTime.now();

  // ================= Chi =================
  final chiCategories = [
    'Ăn uống',
    'Dịch vụ sinh hoạt',
    'Đi lại',
    'Con cái',
    'Trang phục',
    'Hiếu hỉ',
    'Sức khỏe',
    'Nhà cửa',
    'Hưởng thụ',
    'Phát triển bản thân',
  ];

  final chiSubCategories = {
    'Ăn uống': ['Ăn sáng', 'Ăn trưa', 'Ăn tối', 'Cà phê', 'Ăn vặt'],
    'Dịch vụ sinh hoạt': ['Điện', 'Nước', 'Internet', 'Gas', 'Rác'],
    'Đi lại': ['Xe máy', 'Xe buýt', 'Taxi', 'Xăng dầu'],
    'Con cái': ['Học phí', 'Đồ dùng', 'Giải trí'],
    'Trang phục': ['Quần áo', 'Giày dép', 'Phụ kiện'],
    'Hiếu hỉ': ['Quà cưới', 'Tang lễ'],
    'Sức khỏe': ['Khám', 'Thuốc', 'Gym'],
    'Nhà cửa': ['Sửa chữa', 'Trang trí'],
    'Hưởng thụ': ['Du lịch', 'Spa', 'Giải trí'],
    'Phát triển bản thân': ['Khóa học', 'Sách', 'Học tập'],
  };

  String selectedChiCategory = 'Ăn uống';
  String selectedChiSubCategory = 'Ăn sáng';
  String selectedChiWallet = 'Tiền mặt';

  final _chiAmountCtrl = TextEditingController(text: "0");
  final _chiDescCtrl = TextEditingController(text: "");

  // ================= Thu =================
  final thuCategories = ['Lương', 'Thưởng', 'Được biếu', 'Lãi'];
  String selectedThuCategory = 'Lương';
  String selectedThuWallet = 'Tiền mặt';

  final _thuAmountCtrl = TextEditingController(text: "0");
  final _thuDescCtrl = TextEditingController(text: "");

  final wallets = ['Tiền mặt', 'Ngân hàng', 'Ví điện tử'];

  Future<void> _pickDate() async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => selectedDate = d);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ghi chép thu chi'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle Chi/Thu
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('Chi'),
                  selected: type == 'Chi',
                  onSelected: (_) => setState(() => type = 'Chi'),
                ),
                const SizedBox(width: 16),
                ChoiceChip(
                  label: const Text('Thu'),
                  selected: type == 'Thu',
                  onSelected: (_) => setState(() => type = 'Thu'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (type == 'Chi') ...[
              // ================= Chi =================
              TextFormField(
                controller: _chiAmountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Số tiền (VND)'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedChiCategory,
                items: chiCategories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    selectedChiCategory = v!;
                    selectedChiSubCategory = chiSubCategories[v]!.first;
                  });
                },
                decoration: const InputDecoration(labelText: 'Chọn danh mục chính'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedChiSubCategory,
                items: chiSubCategories[selectedChiCategory]!
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => selectedChiSubCategory = v!),
                decoration: const InputDecoration(labelText: 'Chọn danh mục chi tiết'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedChiWallet,
                items: wallets.map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
                onChanged: (v) => setState(() => selectedChiWallet = v!),
                decoration: const InputDecoration(labelText: 'Chọn ví'),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                      const Icon(Icons.calendar_month),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _chiDescCtrl,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Mô tả (tuỳ chọn)'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: const Text('Lưu giao dịch', style: TextStyle(fontSize: 16)),
                ),
              ),
            ] else ...[
              // ================= Thu =================
              DropdownButtonFormField<String>(
                value: selectedThuCategory,
                items: thuCategories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => selectedThuCategory = v!),
                decoration: const InputDecoration(labelText: 'Chọn loại Thu'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _thuAmountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Số tiền (VND)'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedThuWallet,
                items: wallets.map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
                onChanged: (v) => setState(() => selectedThuWallet = v!),
                decoration: const InputDecoration(labelText: 'Chọn ví'),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                      const Icon(Icons.calendar_month),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _thuDescCtrl,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Mô tả (tuỳ chọn)'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: const Text('Lưu giao dịch', style: TextStyle(fontSize: 16)),
                ),
              ),
            ]
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
    );
  }

  @override
  void dispose() {
    _chiAmountCtrl.dispose();
    _chiDescCtrl.dispose();
    _thuAmountCtrl.dispose();
    _thuDescCtrl.dispose();
    super.dispose();
  }
}
