// import 'package:flutter/material.dart';
// import 'package:frontend/services/transaction_service.dart';
// import 'package:frontend/screen/bottom_nav.dart';

// class TransactionScreen extends StatefulWidget {
//   const TransactionScreen({super.key});

//   @override
//   State<TransactionScreen> createState() => _TransactionScreenState();
// }

// class _TransactionScreenState extends State<TransactionScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TransactionService _service = TransactionService();

//   int? selectedAccountId;
//   int? selectedCategoryId;
//   String type = 'Chi';
//   TextEditingController _amountCtrl = TextEditingController();
//   TextEditingController _descCtrl = TextEditingController();
//   DateTime selectedDate = DateTime.now();

//   // Mock data tạm thời, có thể thay bằng call API Bank/Category
//   List<Map<String, dynamic>> accounts = [
//     {"id": 1, "name": "Tiền mặt", "icon": Icons.money},
//     {"id": 2, "name": "Vietcombank", "icon": Icons.account_balance},
//   ];

//   List<Map<String, dynamic>> categories = [
//     {"id": 1, "name": "Ăn uống", "icon": Icons.restaurant},
//     {"id": 2, "name": "Di chuyển", "icon": Icons.directions_car},
//   ];

//   List<Map<String, dynamic>> _transactions = [];

//   @override
//   void initState() {
//     super.initState();
//     if (accounts.isNotEmpty) selectedAccountId = accounts.first['id'];
//     if (categories.isNotEmpty) selectedCategoryId = categories.first['id'];
//     _loadTransactions();
//   }

//   @override
//   void dispose() {
//     _amountCtrl.dispose();
//     _descCtrl.dispose();
//     super.dispose();
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

//   Future<void> _loadTransactions() async {
//     final allTx = await _service.getTransactions();
//     setState(() {
//       // Lấy 5 giao dịch mới nhất
//       _transactions = allTx.reversed.take(5).toList();
//     });
//   }

//   void _saveTransaction() async {
//     if (!_formKey.currentState!.validate()) return;

//     final data = {
//       "accountId": selectedAccountId,
//       "categoryId": selectedCategoryId,
//       "type": type,
//       "amount": double.tryParse(_amountCtrl.text) ?? 0,
//       "date": selectedDate.toIso8601String(),
//       "desc": _descCtrl.text,
//     };

//     final success = await _service.saveTransaction(data);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(success ? 'Đã lưu giao dịch' : 'Lưu thất bại'),
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
//       });
//       _loadTransactions();
//     }
//   }

//   Widget _typeToggle() {
//     final options = ['Chi', 'Thu', 'Cho vay', 'Đi vay'];
//     return Wrap(
//       spacing: 8,
//       children: options.map((opt) {
//         final bool active = opt == type;
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
//     return Scaffold(
//       appBar: AppBar(title: const Text('Ghi chép'), backgroundColor: Colors.orange),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Form nhập giao dịch
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
//                         .map((a) => DropdownMenuItem<int>(
//                               value: a['id'],
//                               child: Row(children: [Icon(a['icon']), const SizedBox(width: 8), Text(a['name'])]),
//                             ))
//                         .toList(),
//                     onChanged: (v) => setState(() => selectedAccountId = v),
//                   ),
//                   const SizedBox(height: 12),
//                   const Text('Chọn hạng mục', style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   DropdownButtonFormField<int>(
//                     value: selectedCategoryId,
//                     items: categories
//                         .map((c) => DropdownMenuItem<int>(
//                               value: c['id'],
//                               child: Row(children: [Icon(c['icon']), const SizedBox(width: 8), Text(c['name'])]),
//                             ))
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
//                       decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'), const Icon(Icons.calendar_month)],
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
//                       onPressed: _saveTransaction,
//                       style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.symmetric(vertical: 14)),
//                       child: const Text('Lưu giao dịch', style: TextStyle(fontSize: 16)),
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                 ],
//               ),
//             ),

//             // Hiển thị 5 giao dịch mới nhất
//             const Text('Giao dịch gần nhất', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//             const SizedBox(height: 8),
//             if (_transactions.isEmpty)
//               const Text('Chưa có giao dịch nào')
//             else
//               Column(
//                 children: _transactions.map((tx) {
//                   final date = DateTime.parse(tx['date']);
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     child: ListTile(
//                       leading: Icon(
//                         tx['type'] == 'Chi'
//                             ? Icons.remove
//                             : Icons.add,
//                         color: Colors.orange,
//                       ),
//                       title: Text('${tx['amount']} VND - ${tx['desc'] ?? ''}'),
//                       subtitle: Text('Ngày: ${date.day}/${date.month}/${date.year}'),
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
// }
import 'package:flutter/material.dart';
import 'package:frontend/services/transaction_service.dart';
import 'package:frontend/services/bank_service.dart';
import 'package:frontend/services/category_service.dart';
import 'package:frontend/screen/bottom_nav.dart';

/// 🔹 Hàm chuyển chuỗi tên icon sang IconData
IconData getIconFromString(String? iconName) {
  switch (iconName) {
    case 'money':
      return Icons.money;
    case 'account_balance':
      return Icons.account_balance;
    case 'restaurant':
      return Icons.restaurant;
    case 'directions_car':
      return Icons.directions_car;
    case 'home':
      return Icons.home;
    default:
      return Icons.category; // fallback
  }
}

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TransactionService _transactionService = TransactionService();
  final BankService _bankService = BankService();
  final CategoryService _categoryService = CategoryService();

  int? selectedAccountId;
  int? selectedCategoryId;
  String type = 'Chi';
  TextEditingController _amountCtrl = TextEditingController();
  TextEditingController _descCtrl = TextEditingController();
  DateTime selectedDate = DateTime.now();

  List<Map<String, dynamic>> accounts = [];
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadAccounts();
    _loadCategories();
    _loadTransactions();
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadAccounts() async {
    final accs = await _bankService.getAccounts();
    setState(() {
      accounts = accs;
      if (accounts.isNotEmpty) selectedAccountId = accounts.first['id'];
    });
  }

  Future<void> _loadCategories() async {
    final cats = await _categoryService.getCategories();
    setState(() {
      categories = cats;
      if (categories.isNotEmpty) selectedCategoryId = categories.first['id'];
    });
  }

  Future<void> _loadTransactions() async {
    final txs = await _transactionService.getTransactions();
    setState(() {
      _transactions = txs.reversed.take(5).toList();
    });
  }

  Future<void> _pickDate() async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => selectedDate = d);
  }

  void _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      "accountId": selectedAccountId,
      "categoryId": selectedCategoryId,
      "type": type,
      "amount": double.tryParse(_amountCtrl.text) ?? 0,
      "date": selectedDate.toIso8601String(),
      "desc": _descCtrl.text,
    };

    final success = await _transactionService.saveTransaction(data);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Đã lưu giao dịch' : 'Lưu thất bại'),
        backgroundColor: Colors.orange,
      ),
    );

    if (success) {
      _amountCtrl.clear();
      _descCtrl.clear();
      setState(() {
        type = 'Chi';
        selectedDate = DateTime.now();
        if (accounts.isNotEmpty) selectedAccountId = accounts.first['id'];
        if (categories.isNotEmpty) selectedCategoryId = categories.first['id'];
      });
      _loadTransactions();
    }
  }

  Widget _typeToggle() {
    final options = ['Chi', 'Thu', 'Cho vay', 'Đi vay'];
    return Wrap(
      spacing: 8,
      children: options.map((opt) {
        final bool active = opt == type;
        return ChoiceChip(
          label: Text(opt),
          selected: active,
          onSelected: (_) => setState(() => type = opt),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ghi chép'), backgroundColor: Colors.orange),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Chọn tài khoản', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: selectedAccountId,
                    items: accounts
                        .map((a) => DropdownMenuItem<int>(
                              value: a['id'],
                              child: Row(
                                children: [
                                  Icon(getIconFromString(a['icon']?.toString())),
                                  const SizedBox(width: 8),
                                  Text(a['name'] ?? '')
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => selectedAccountId = v),
                  ),
                  const SizedBox(height: 12),
                  const Text('Chọn hạng mục', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: selectedCategoryId,
                    items: categories
                        .map((c) => DropdownMenuItem<int>(
                              value: c['id'],
                              child: Row(
                                children: [
                                  Icon(getIconFromString(c['icon']?.toString())),
                                  const SizedBox(width: 8),
                                  Text(c['name'] ?? '')
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => selectedCategoryId = v),
                  ),
                  const SizedBox(height: 12),
                  const Text('Loại giao dịch', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _typeToggle(),
                  const SizedBox(height: 12),
                  const Text('Số tiền', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _amountCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(prefixText: 'VND ', hintText: 'Nhập số tiền'),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Nhập số tiền';
                      if (double.tryParse(v) == null) return 'Số tiền không hợp lệ';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text('Ngày', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'), const Icon(Icons.calendar_month)],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Mô tả (tuỳ chọn)', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(controller: _descCtrl, maxLines: 2, decoration: const InputDecoration(hintText: 'Ghi chú thêm')),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveTransaction,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: const Text('Lưu giao dịch', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            const Text('Giao dịch gần nhất', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            if (_transactions.isEmpty)
              const Text('Chưa có giao dịch nào')
            else
              Column(
                children: _transactions.map((tx) {
                  final date = DateTime.tryParse(tx['date'] ?? '') ?? DateTime.now();
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Icon(
                        tx['type'] == 'Chi' ? Icons.remove : Icons.add,
                        color: Colors.orange,
                      ),
                      title: Text('${tx['amount'] ?? 0} VND - ${tx['desc'] ?? ''}'),
                      subtitle: Text('Ngày: ${date.day}/${date.month}/${date.year}'),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
    );
  }
}
