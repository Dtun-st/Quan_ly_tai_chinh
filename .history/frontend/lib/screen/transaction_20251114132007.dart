import 'package:flutter/material.dart';
import 'package:frontend/screen/bottom_nav.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Mock dữ liệu tài khoản với icon
  List<Map<String, dynamic>> accounts = [
    {"id": 1, "name": "Tiền mặt", "icon": Icons.money},
    {"id": 2, "name": "Vietcombank", "icon": Icons.account_balance},
    {"id": 3, "name": "Ví Momo", "icon": Icons.account_balance_wallet},
    {"id": 4, "name": "ZaloPay", "icon": Icons.phone_iphone},
    {"id": 5, "name": "Thẻ tín dụng", "icon": Icons.credit_card},
  ];

  // Mock dữ liệu danh mục với icon
  List<Map<String, dynamic>> categories = [
    {"id": 1, "name": "Ăn uống", "icon": Icons.restaurant},
    {"id": 2, "name": "Di chuyển", "icon": Icons.directions_car},
    {"id": 3, "name": "Giải trí", "icon": Icons.sports_esports},
    {"id": 4, "name": "Mua sắm", "icon": Icons.shopping_cart},
    {"id": 5, "name": "Học tập", "icon": Icons.school},
  ];

  int? selectedAccountId;
  int? selectedCategoryId;
  String type = 'Chi'; // 'Chi' || 'Thu' || 'Cho vay' || 'Đi vay'
  TextEditingController _amountCtrl = TextEditingController();
  TextEditingController _descCtrl = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (accounts.isNotEmpty) selectedAccountId = accounts.first['id'];
    if (categories.isNotEmpty) selectedCategoryId = categories.first['id'];
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
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

  void _saveTransaction() {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      "accountId": selectedAccountId,
      "categoryId": selectedCategoryId,
      "type": type,
      "amount": double.tryParse(_amountCtrl.text) ?? 0,
      "date": selectedDate.toIso8601String(),
      "desc": _descCtrl.text,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã lưu: ${data['type']} - ${data['amount']} VND'),
        backgroundColor: Colors.orange,
      ),
    );

    // Reset form
    _amountCtrl.clear();
    _descCtrl.clear();
    setState(() {
      type = 'Chi';
      if (accounts.isNotEmpty) selectedAccountId = accounts.first['id'];
      if (categories.isNotEmpty) selectedCategoryId = categories.first['id'];
      selectedDate = DateTime.now();
    });
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
          selectedColor: Colors.orange.shade100,
          backgroundColor: Colors.grey.shade100,
          labelStyle: TextStyle(color: active ? Colors.orange.shade800 : Colors.black),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ghi chép'),
        backgroundColor: Colors.orange,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Account
                const Text('Chọn tài khoản', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  value: selectedAccountId,
                  items: accounts
                      .map((a) => DropdownMenuItem<int>(
                            value: a['id'],
                            child: Row(
                              children: [
                                Icon(a['icon'], color: Colors.orange.shade700),
                                const SizedBox(width: 8),
                                Text(a['name']),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => selectedAccountId = v),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),

                // Category
                const Text('Chọn hạng mục', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  value: selectedCategoryId,
                  items: categories
                      .map((c) => DropdownMenuItem<int>(
                            value: c['id'],
                            child: Row(
                              children: [
                                Icon(c['icon'], color: Colors.orange.shade700),
                                const SizedBox(width: 8),
                                Text(c['name']),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => selectedCategoryId = v),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),

                // Type
                const Text('Loại giao dịch', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _typeToggle(),
                const SizedBox(height: 12),

                // Amount
                const Text('Số tiền', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: 'VND ',
                    hintText: 'Nhập số tiền',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Vui lòng nhập số tiền';
                    if (double.tryParse(v) == null) return 'Số tiền không hợp lệ';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Date
                const Text('Ngày', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
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

                // Description
                const Text('Mô tả (tuỳ chọn)', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descCtrl,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Ghi chú thêm',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveTransaction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Lưu giao dịch', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),

      // bottom nav (tab index 2)
      bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
    );
  }
}
