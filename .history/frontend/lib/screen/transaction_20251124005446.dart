import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:frontend/screen/bottom_nav.dart';
import 'package:frontend/screen/category.dart';

const Color primaryColor = Color(0xFFFF7A00);
const Color secondaryColor = Color(0xFFFFD1A8);
const Color backgroundColor = Colors.white;
const Color neutralColor = Color(0xFFF5F5F5);

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

  // Hình hóa đơn
  File? selectedImageFile;
  Uint8List? selectedImageBytes;
  String? selectedImageName;

  // Tài khoản
  List<Map<String, dynamic>> accounts = [
    {"id": 1, "name": "Tiền mặt", "icon": Icons.money_rounded},
    {"id": 2, "name": "Thẻ tín dụng", "icon": Icons.credit_card_rounded},
    {"id": 3, "name": "Ngân hàng", "icon": Icons.account_balance_rounded},
  ];
  int? selectedAccountId = 1;

  // Danh mục Chi / Thu cứng để test
  List<Map<String, dynamic>> chiDanhMuc = [
    {
      'name': 'Ăn uống',
      'children': [
        {'name': 'Cơm'},
        {'name': 'Trà sữa'},
      ]
    },
    {
      'name': 'Mua sắm',
      'children': [
        {'name': 'Quần áo'},
        {'name': 'Đồ điện tử'},
      ]
    },
  ];
  String? selectedChiDanhMuc;
  String? selectedChiCon;

  List<Map<String, dynamic>> thuLoai = [
    {
      'name': 'Lương',
      'children': [
        {'name': 'Lương tháng'},
        {'name': 'Thưởng'},
      ]
    },
    {
      'name': 'Thu nhập phụ',
      'children': [
        {'name': 'Bán hàng'},
        {'name': 'Cho thuê'},
      ]
    }
  ];
  String? selectedThuLoai;

  // Danh sách giao dịch cứng để test UI
  List<Map<String, dynamic>> transactions = [
    {
      'loai_gd': 'Chi',
      'so_tien': 50000,
      'ten_danh_muc': 'Cơm',
      'ngay_giao_dich': DateTime.now(),
      'anh_hoa_don': null,
    },
    {
      'loai_gd': 'Thu',
      'so_tien': 1000000,
      'ten_danh_muc': 'Lương tháng',
      'ngay_giao_dich': DateTime.now(),
      'anh_hoa_don': null,
    },
  ];

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
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildToggle(),
            const SizedBox(height: 24),
            _buildForm(),
            const SizedBox(height: 30),
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

  // ================= FORM =================
  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: neutralColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildAmountField(),
          const SizedBox(height: 16),
          _buildAccountDropdown(),
          const SizedBox(height: 16),
          isChi ? _buildChiDanhMucField() : _buildThuLoaiField(),
          const SizedBox(height: 16),
          _buildDatePicker(),
          const SizedBox(height: 16),
          _buildDescField(),
          const SizedBox(height: 16),
          _buildImagePicker(),
          const SizedBox(height: 20),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildAmountField() {
    return TextField(
      controller: amountCtrl,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: "Số tiền",
        prefixText: "VND ",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildAccountDropdown() {
    return DropdownButtonFormField<int>(
      value: selectedAccountId,
      decoration: InputDecoration(
        labelText: "Tài khoản",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: accounts.map<DropdownMenuItem<int>>((account) {
        return DropdownMenuItem<int>(
          value: account["id"],
          child: Row(
            children: [
              Icon(account["icon"], color: primaryColor),
              const SizedBox(width: 8),
              Text(account["name"]),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedAccountId = value;
        });
      },
    );
  }

  Widget _buildChiDanhMucField() {
    return GestureDetector(
      onTap: _showChiMenu,
      child: _categoryFieldWidget(
        selectedChiCon ?? "Chọn danh mục",
        Icons.category_rounded,
      ),
    );
  }

  Widget _buildThuLoaiField() {
    return GestureDetector(
      onTap: _showThuMenu,
      child: _categoryFieldWidget(
        selectedThuLoai ?? "Chọn loại thu",
        Icons.savings_rounded,
      ),
    );
  }

  Widget _categoryFieldWidget(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryColor),
              const SizedBox(width: 10),
              Text(text),
            ],
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: _pickDate,
      child: _categoryFieldWidget(
        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
        Icons.calendar_month_rounded,
      ),
    );
  }

  Widget _buildDescField() {
    return TextField(
      controller: descCtrl,
      maxLines: 2,
      decoration: InputDecoration(
        labelText: "Mô tả (tùy chọn)",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildImagePicker() {
    Widget content;
    if (kIsWeb) {
      content = selectedImageBytes == null
          ? const Center(
              child: Icon(
                Icons.camera_alt_rounded,
                size: 40,
                color: Colors.grey,
              ),
            )
          : Image.memory(selectedImageBytes!, fit: BoxFit.cover);
    } else {
      content = selectedImageFile == null
          ? const Center(
              child: Icon(
                Icons.camera_alt_rounded,
                size: 40,
                color: Colors.grey,
              ),
            )
          : Image.file(selectedImageFile!, fit: BoxFit.cover);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Ảnh hóa đơn",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {}, // tạm thời chưa chọn ảnh
          child: Container(
            height: 130,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: content,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // Chỉ để test giao diện
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Lưu giao dịch (test UI)")),
          );
        },
        icon: const Icon(Icons.check),
        label: const Text("LƯU GIAO DỊCH"),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildToggle() {
    return Container(
      decoration: BoxDecoration(
        color: neutralColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withOpacity(0.5), width: 1.5),
      ),
      child: Row(
        children: [_toggleItem("Chi", true), _toggleItem("Thu", false)],
      ),
    );
  }

  Widget _toggleItem(String label, bool state) {
    bool active = (state == isChi);
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isChi = state),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: active ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : primaryColor,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTransactionList() {
    return Column(
      children: transactions.map((tx) {
        final amountText =
            "${tx['loai_gd'] == "Chi" ? "-" : "+"}${tx['so_tien']} VND";

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: tx['loai_gd'] == "Chi"
                  ? secondaryColor
                  : secondaryColor.withOpacity(0.5),
              child: Icon(
                tx['loai_gd'] == "Chi"
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                color: primaryColor,
              ),
            ),
            title: Text(tx['ten_danh_muc'] ?? tx['loai_gd']),
            subtitle: Text(
              "Ngày: ${tx['ngay_giao_dich'].toString().substring(0, 10)}",
            ),
            trailing: Text(
              amountText,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: primaryColor),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ==================== GỌI CATEGORY SCREEN ====================
  void _showChiMenu() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChiCategoryScreen()),
    );
    if (result != null) {
      setState(() {
        selectedChiCon = result;
      });
    }
  }

  void _showThuMenu() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ThuCategoryScreen()),
    );
    if (result != null) {
      setState(() {
        selectedThuLoai = result;
      });
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
