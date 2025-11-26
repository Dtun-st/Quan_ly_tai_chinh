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
import 'package:frontend/screen/bottom_nav.dart';

const Color textColor = Color(0xFF333333);

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  bool isChi = true;
  DateTime selectedDate = DateTime.now();

  final TextEditingController amountCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();

  // ===== Tài khoản =====
  final List<Map<String, dynamic>> accounts = [
    {"id": 1, "name": "Tiền mặt", "icon": Icons.money},
    {"id": 2, "name": "Thẻ tín dụng", "icon": Icons.credit_card},
    {"id": 3, "name": "Ngân hàng", "icon": Icons.account_balance},
  ];
  int? selectedAccountId;

  // ===== Danh mục Chi =====
  final List<Map<String, dynamic>> chiDanhMuc = [
    {
      "name": "Ăn uống",
      "icon": Icons.restaurant,
      "children": [
        {"name": "Nhà hàng", "icon": Icons.restaurant_menu},
        {"name": "Cà phê", "icon": Icons.coffee},
        {"name": "Ăn vặt", "icon": Icons.fastfood},
      ]
    },
    {
      "name": "Dịch vụ sinh hoạt",
      "icon": Icons.home_repair_service,
      "children": [
        {"name": "Điện", "icon": Icons.lightbulb},
        {"name": "Nước", "icon": Icons.water},
        {"name": "Internet", "icon": Icons.wifi},
      ]
    },
    {
      "name": "Đi lại",
      "icon": Icons.directions_car,
      "children": [
        {"name": "Xe buýt", "icon": Icons.directions_bus},
        {"name": "Taxi", "icon": Icons.local_taxi},
        {"name": "Xăng xe", "icon": Icons.local_gas_station},
      ]
    },
  ];

  String? selectedChiDanhMuc;
  String? selectedChiCon;

  // ===== Loại Thu =====
  final List<Map<String, dynamic>> thuLoai = [
    {"name": "Lương", "icon": Icons.attach_money},
    {"name": "Thưởng", "icon": Icons.card_giftcard},
    {"name": "Được biếu", "icon": Icons.money_off},
    {"name": "Lãi", "icon": Icons.trending_up},
  ];
  String? selectedThuLoai;

  // ===== Mục hay dùng (Chi) =====
  final List<Map<String, dynamic>> frequentlyUsedChi = [
    {"name": "Nhà hàng", "icon": Icons.restaurant, "color": Colors.redAccent},
    {"name": "Cà phê", "icon": Icons.coffee, "color": Colors.brown},
    {"name": "Điện", "icon": Icons.lightbulb, "color": Colors.yellow},
  ];

  @override
  void initState() {
    super.initState();
    if (accounts.isNotEmpty) selectedAccountId = accounts.first['id'];
  }

  @override
  void dispose() {
    amountCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ghi chép"),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildToggle(),
            const SizedBox(height: 16),
            isChi ? _buildChiForm() : _buildThuForm(),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
    );
  }

  // ===== Toggle Chi/Thu =====
  Widget _buildToggle() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => isChi = true),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isChi ? Colors.orange : Colors.grey.shade200,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Center(
                  child: Text(
                "Chi",
                style: TextStyle(
                    color: isChi ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => isChi = false),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: !isChi ? Colors.orange : Colors.grey.shade200,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Center(
                  child: Text(
                "Thu",
                style: TextStyle(
                    color: !isChi ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
        ),
      ],
    );
  }

  // ===== Form Chi =====
  Widget _buildChiForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAmountField(),
        const SizedBox(height: 12),
        _buildCategorySelectionChi(),
        const SizedBox(height: 12),
        _buildFrequentlyUsedChi(),
        const SizedBox(height: 12),
        _buildAccountDropdown(),
        const SizedBox(height: 12),
        _buildDatePicker(),
        const SizedBox(height: 12),
        _buildDescField(),
        const SizedBox(height: 20),
        _buildSaveButton(),
      ],
    );
  }

  // ===== Form Thu =====
  Widget _buildThuForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAmountField(),
        const SizedBox(height: 12),
        _buildThuTypeSelection(),
        const SizedBox(height: 12),
        _buildAccountDropdown(),
        const SizedBox(height: 12),
        _buildDatePicker(),
        const SizedBox(height: 12),
        _buildDescField(),
        const SizedBox(height: 20),
        _buildSaveButton(),
      ],
    );
  }

  // ===== Widgets cơ bản =====
  Widget _buildAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Số tiền", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: amountCtrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              prefixText: "VND ",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
        ),
      ],
    );
  }

  Widget _buildDescField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Mô tả", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: descCtrl,
          maxLines: 2,
          decoration: InputDecoration(
              hintText: "Ghi chú thêm",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Ngày", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                const Icon(Icons.calendar_month)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(vertical: 14)),
        child: const Text("Lưu", style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildAccountDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Tài khoản", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: selectedAccountId,
          items: accounts
              .map((a) => DropdownMenuItem<int>(
                    value: a['id'],
                    child: Row(
                      children: [Icon(a['icon']), const SizedBox(width: 8), Text(a['name'])],
                    ),
                  ))
              .toList(),
          onChanged: (v) => setState(() => selectedAccountId = v),
        ),
      ],
    );
  }

  Widget _buildCategorySelectionChi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Danh mục", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...chiDanhMuc.map((cat) {
          return ExpansionTile(
            leading: Icon(cat["icon"]),
            title: Text(cat["name"]),
            initiallyExpanded: selectedChiDanhMuc == cat["name"],
            children: (cat["children"] as List)
                .map<Widget>((c) => ListTile(
                      leading: Icon(c["icon"]),
                      title: Text(c["name"]),
                      trailing: selectedChiCon == c["name"]
                          ? const Icon(Icons.check, color: Colors.orange)
                          : null,
                      onTap: () {
                        setState(() {
                          selectedChiDanhMuc = cat["name"];
                          selectedChiCon = c["name"];
                        });
                      },
                    ))
                .toList(),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildFrequentlyUsedChi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Mục hay dùng", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: frequentlyUsedChi
              .map((cat) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedChiCon = cat["name"];
                        selectedChiDanhMuc = null;
                      });
                    },
                    child: SizedBox(
                      width: 80,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: cat["color"].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16)),
                            child: Icon(cat["icon"], size: 36, color: cat["color"]),
                          ),
                          const SizedBox(height: 8),
                          Text(cat["name"], textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: textColor)),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildThuTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Loại thu", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: thuLoai
              .map((t) => GestureDetector(
                    onTap: () => setState(() => selectedThuLoai = t["name"]),
                    child: SizedBox(
                      width: 80,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16)),
                            child: Icon(t["icon"], size: 36, color: Colors.orange),
                          ),
                          const SizedBox(height: 8),
                          Text(t["name"], textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: textColor)),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
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
}
