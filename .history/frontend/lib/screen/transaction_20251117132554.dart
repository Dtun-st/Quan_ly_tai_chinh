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

const Color primaryColor = Color(0xFFFF7A00); // Cam rực rỡ
const Color secondaryColor = Color(0xFFFFD1A8); // Cam nhạt
const Color backgroundColor = Colors.white;
const Color neutralColor = Color(0xFFF5F5F5); // Xám nhạt

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

  final List<Map<String, dynamic>> accounts = [
    {"id": 1, "name": "Tiền mặt", "icon": Icons.money_rounded},
    {"id": 2, "name": "Thẻ tín dụng", "icon": Icons.credit_card_rounded},
    {"id": 3, "name": "Ngân hàng", "icon": Icons.account_balance_rounded},
  ];
  int? selectedAccountId;

  final List<Map<String, dynamic>> chiDanhMuc = [
    {
      "name": "Ăn uống",
      "icon": Icons.restaurant,
      "children": [
        {"name": "Nhà hàng", "icon": Icons.local_dining},
        {"name": "Cà phê", "icon": Icons.local_cafe},
        {"name": "Ăn vặt", "icon": Icons.emoji_food_beverage},
      ]
    },
    {
      "name": "Dịch vụ sinh hoạt",
      "icon": Icons.home_repair_service,
      "children": [
        {"name": "Điện", "icon": Icons.lightbulb},
        {"name": "Nước", "icon": Icons.water_drop},
        {"name": "Internet", "icon": Icons.wifi},
      ]
    },
    {
      "name": "Đi lại",
      "icon": Icons.directions_car,
      "children": [
        {"name": "Xe buýt", "icon": Icons.directions_bus},
        {"name": "Xăng xe", "icon": Icons.local_gas_station},
        {"name": "Taxi", "icon": Icons.local_taxi},
      ]
    },
  ];
  String? selectedChiDanhMuc;
  String? selectedChiCon;

  final List<Map<String, dynamic>> thuLoai = [
    {"name": "Lương", "icon": Icons.attach_money},
    {"name": "Thưởng", "icon": Icons.card_giftcard},
    {"name": "Được biếu", "icon": Icons.money_off},
    {"name": "Lãi", "icon": Icons.trending_up},
  ];
  String? selectedThuLoai;

  // Danh sách giao dịch gần đây (mẫu)
  final List<Map<String, String>> transactions = [];

  @override
  void initState() {
    super.initState();
    selectedAccountId = accounts.first['id'];
    // Thêm vài giao dịch mẫu
    transactions.addAll([
      {"type": "Chi", "name": "Cà phê", "amount": "50,000 VND", "date": "23/10"},
      {"type": "Thu", "name": "Lương", "amount": "5,000,000 VND", "date": "22/10"},
      {"type": "Chi", "name": "Taxi", "amount": "120,000 VND", "date": "21/10"},
    ]);
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Ghi chép giao dịch",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildToggle(),
            const SizedBox(height: 24),

            // Form Chi / Thu
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: neutralColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: isChi ? _buildChiFormBody() : _buildThuFormBody(),
            ),

            const SizedBox(height: 16),

            // Nút Lưu chung
            _buildSaveButton(isChi ? Colors.red.shade600 : Colors.green.shade600),

            const SizedBox(height: 30),

            // Giao dịch gần đây
            _buildTitle("Giao dịch gần đây"),
            const SizedBox(height: 12),
            _buildTransactionList(),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
    );
  }

  // ===================== Toggle Chi / Thu =====================
  Widget _buildToggle() {
    return Container(
      decoration: BoxDecoration(
        color: neutralColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withOpacity(0.5), width: 1.5),
      ),
      child: Row(
        children: [
          _toggleItem("Chi", true),
          _toggleItem("Thu", false),
        ],
      ),
    );
  }

  Widget _toggleItem(String label, bool isCurrent) {
    bool isActive = (isCurrent == isChi);
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isChi = isCurrent),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: isActive ? Colors.white : primaryColor,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===================== Form Body =====================
  Widget _buildChiFormBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAmountField(Colors.red.shade600),
        const SizedBox(height: 16),
        _buildAccountDropdown(),
        const SizedBox(height: 16),
        _buildChiDanhMucField(),
        const SizedBox(height: 16),
        _buildDatePicker(),
        const SizedBox(height: 16),
        _buildDescField(),
      ],
    );
  }

  Widget _buildThuFormBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAmountField(Colors.green.shade600),
        const SizedBox(height: 16),
        _buildAccountDropdown(),
        const SizedBox(height: 16),
        _buildThuLoaiField(),
        const SizedBox(height: 16),
        _buildDatePicker(),
        const SizedBox(height: 16),
        _buildDescField(),
      ],
    );
  }

  // ===================== Fields =====================
  Widget _buildAmountField(Color color) {
    return TextField(
      controller: amountCtrl,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
      decoration: InputDecoration(
        labelText: "Số tiền",
        labelStyle: const TextStyle(color: Colors.black54),
        prefixText: "VND ",
        prefixStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color.withOpacity(0.5)),
        ),
      ),
    );
  }

  Widget _buildAccountDropdown() {
    return DropdownButtonFormField<int>(
      value: selectedAccountId,
      items: accounts
          .map((a) => DropdownMenuItem<int>(
                value: a['id'],
                child: Row(children: [Icon(a['icon'], color: primaryColor), const SizedBox(width: 10), Text(a['name'])]),
              ))
          .toList(),
      onChanged: (v) => setState(() => selectedAccountId = v),
      decoration: InputDecoration(
        labelText: "Tài khoản",
        prefixIcon: const Icon(Icons.wallet_rounded, color: primaryColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildChiDanhMucField() {
    return GestureDetector(
      onTap: _showChiMenu,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.category_rounded, color: primaryColor),
                const SizedBox(width: 10),
                Text(
                  selectedChiCon ?? selectedChiDanhMuc ?? "Chọn danh mục",
                  style: TextStyle(
                      fontSize: 16,
                      color: selectedChiCon == null ? Colors.grey.shade600 : Colors.black,
                      fontWeight: selectedChiCon == null ? FontWeight.normal : FontWeight.w600),
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildThuLoaiField() {
    return DropdownButtonFormField<String>(
      value: selectedThuLoai,
      items: thuLoai
          .map((e) => DropdownMenuItem<String>(
                value: e['name'],
                child: Row(children: [Icon(e['icon'], color: primaryColor), const SizedBox(width: 8), Text(e['name'])]),
              ))
          .toList(),
      onChanged: (v) => setState(() => selectedThuLoai = v),
      decoration: InputDecoration(
        labelText: "Loại thu",
        prefixIcon: const Icon(Icons.trending_up_rounded, color: primaryColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_month_rounded, color: primaryColor),
                const SizedBox(width: 10),
                Text(
                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const Icon(Icons.edit_calendar_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDescField() {
    return TextField(
      controller: descCtrl,
      maxLines: 2,
      decoration: InputDecoration(
        labelText: "Mô tả (tùy chọn)",
        prefixIcon: const Icon(Icons.notes_rounded, color: primaryColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSaveButton(Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _saveTransaction,
        icon: const Icon(Icons.check, color: Colors.white),
        label: const Text(
          "LƯU GIAO DỊCH",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 5,
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
    );
  }

  Widget _buildTransactionList() {
    return Column(
      children: transactions
          .map((tx) => Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: tx['type'] == "Chi" ? Colors.red.shade50 : Colors.green.shade50,
                    child: Icon(tx['type'] == "Chi" ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                        color: tx['type'] == "Chi" ? Colors.red.shade600 : Colors.green.shade600),
                  ),
                  title: Text(tx['name']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text("Ngày: ${tx['date']!}"),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${tx['type'] == "Chi" ? '-' : '+'}${tx['amount']}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: tx['type'] == "Chi" ? Colors.red.shade600 : Colors.green.shade600),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.edit, color: Colors.grey, size: 18),
                          SizedBox(width: 8),
                          Icon(Icons.delete, color: Colors.red, size: 18),
                        ],
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }

  // ===================== Bottom Sheet & Functions =====================
  void _showChiMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 16),
          height: 400,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("Chọn Danh Mục Chi Tiêu",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
              ),
              const Divider(thickness: 1, height: 20),
              ...chiDanhMuc.map((cat) {
                return Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    leading: Icon(cat['icon'], color: primaryColor),
                    title: Text(cat['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                    children: (cat['children'] as List)
                        .map<Widget>((child) => ListTile(
                              leading: Icon(child['icon'], color: Colors.grey),
                              title: Text(child['name']),
                              contentPadding: const EdgeInsets.only(left: 40),
                              onTap: () {
                                setState(() {
                                  selectedChiDanhMuc = cat['name'];
                                  selectedChiCon = child['name'];
                                });
                                Navigator.pop(context);
                              },
                            ))
                        .toList(),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickDate() async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (d != null) setState(() => selectedDate = d);
  }

  // ===================== Save Transaction =====================
  void _saveTransaction() {
    if (amountCtrl.text.isEmpty) return;

    setState(() {
      transactions.insert(0, {
        "type": isChi ? "Chi" : "Thu",
        "name": isChi
            ? (selectedChiCon ?? selectedChiDanhMuc ?? "Chi tiêu")
            : (selectedThuLoai ?? "Thu nhập"),
        "amount": "${amountCtrl.text} VND",
        "date": "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
      });
      // Reset form
      amountCtrl.clear();
      descCtrl.clear();
      selectedChiCon = null;
      selectedChiDanhMuc = null;
      selectedThuLoai = null;
    });
  }
}
