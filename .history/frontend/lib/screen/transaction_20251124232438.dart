// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import '../services/bank_service.dart';
// import 'category.dart';
// import 'bottom_nav.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';

// const Color primaryColor = Color(0xFFFF7A00);
// const Color secondaryColor = Color(0xFFFFD1A8);
// const Color backgroundColor = Colors.white;
// const Color neutralColor = Color(0xFFF5F5F5);

// class TransactionScreen extends StatefulWidget {
//   const TransactionScreen({super.key});

//   @override
//   State<TransactionScreen> createState() => _TransactionScreenState();
// }

// class _TransactionScreenState extends State<TransactionScreen> {
//   bool isChi = true;
//   DateTime selectedDate = DateTime.now();

//   final TextEditingController amountCtrl = TextEditingController();
//   final TextEditingController descCtrl = TextEditingController();

//   // Hình hóa đơn
//   File? selectedImageFile;
//   Uint8List? selectedImageBytes;

//   // Tài khoản
//   List<Map<String, dynamic>> accounts = [];
//   int? selectedAccountId;

//   // Danh mục
//   Map<String, dynamic>? selectedChiCon;
//   Map<String, dynamic>? selectedThuLoai;

//   // Icons danh mục
//   final Map<String, IconData> iconsList = {
//     "money": Icons.money_rounded,
//     "credit_card": Icons.credit_card_rounded,
//     "bank": Icons.account_balance_rounded,
//     "wallet": Icons.account_balance_wallet_rounded,
//     "shopping": Icons.shopping_cart_rounded,
//     "food": Icons.fastfood_rounded,
//     "category": Icons.category_rounded,
//   };

//   @override
//   void initState() {
//     super.initState();
//     _loadAccounts();
//   }

//   Future<void> _loadAccounts() async {
//     final data = await BankService().getAccounts();
//     setState(() {
//       accounts = data.map((e) => {
//             "id": e['id'],
//             "name": e['ten_tai_khoan'],
//             "icon": _mapIcon(e['loai_tai_khoan']),
//           }).toList();
//       selectedAccountId = accounts.isNotEmpty ? accounts[0]['id'] : null;
//     });
//   }

//   IconData _mapIcon(String type) {
//     switch (type) {
//       case 'Tiền mặt':
//         return Icons.money_rounded;
//       case 'Thẻ tín dụng':
//         return Icons.credit_card_rounded;
//       case 'Ngân hàng':
//         return Icons.account_balance_rounded;
//       case 'Ví điện tử':
//         return Icons.account_balance_wallet_rounded;
//       default:
//         return Icons.account_balance_wallet_rounded;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         title: const Text("Ghi chép giao dịch", style: TextStyle(color: Colors.white)),
//         backgroundColor: primaryColor,
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _saveTransaction,
//         backgroundColor: primaryColor,
//         child: const Icon(Icons.check),
//       ),
//       bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildToggle(),
//             const SizedBox(height: 24),
//             _buildForm(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildToggle() {
//     return Container(
//       decoration: BoxDecoration(
//         color: neutralColor,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: primaryColor.withOpacity(0.5), width: 1.5),
//       ),
//       child: Row(
//         children: [_toggleItem("Chi", true), _toggleItem("Thu", false)],
//       ),
//     );
//   }

//   Widget _toggleItem(String label, bool state) {
//     bool active = (state == isChi);
//     return Expanded(
//       child: GestureDetector(
//         onTap: () => setState(() => isChi = state),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           padding: const EdgeInsets.symmetric(vertical: 14),
//           decoration: BoxDecoration(
//             color: active ? primaryColor : Colors.transparent,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Center(
//             child: Text(
//               label,
//               style: TextStyle(
//                 color: active ? Colors.white : primaryColor,
//                 fontWeight: active ? FontWeight.bold : FontWeight.normal,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildForm() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: neutralColor,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         children: [
//           _buildAmountField(),
//           const SizedBox(height: 16),
//           _buildAccountDropdown(),
//           const SizedBox(height: 16),
//           isChi ? _buildChiDanhMucField() : _buildThuLoaiField(),
//           const SizedBox(height: 16),
//           _buildDatePicker(),
//           const SizedBox(height: 16),
//           _buildDescField(),
//           const SizedBox(height: 16),
//           _buildImagePicker(),
//         ],
//       ),
//     );
//   }

//   Widget _buildAmountField() {
//     return TextField(
//       controller: amountCtrl,
//       keyboardType: TextInputType.number,
//       style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//       decoration: InputDecoration(
//         labelText: "Số tiền",
//         prefixText: "VND ",
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   Widget _buildAccountDropdown() {
//     return DropdownButtonFormField<int>(
//       value: selectedAccountId,
//       decoration: InputDecoration(
//         labelText: "Tài khoản",
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//       items: accounts.map((acc) {
//         return DropdownMenuItem<int>(
//           value: acc['id'],
//           child: Row(
//             children: [
//               Icon(acc['icon'], color: primaryColor),
//               const SizedBox(width: 8),
//               Text(acc['name']),
//             ],
//           ),
//         );
//       }).toList(),
//       onChanged: (val) => setState(() => selectedAccountId = val),
//     );
//   }

//   Widget _buildChiDanhMucField() {
//     return GestureDetector(
//       onTap: _showChiMenu,
//       child: _categoryFieldWidget(
//         selectedChiCon != null ? selectedChiCon!['ten_danh_muc'] : "Chọn danh mục",
//         selectedChiCon != null ? iconsList[selectedChiCon!['icon']] ?? Icons.category : Icons.category,
//       ),
//     );
//   }

//   Widget _buildThuLoaiField() {
//     return GestureDetector(
//       onTap: _showThuMenu,
//       child: _categoryFieldWidget(
//         selectedThuLoai != null ? selectedThuLoai!['ten_danh_muc'] : "Chọn loại thu",
//         selectedThuLoai != null ? iconsList[selectedThuLoai!['icon']] ?? Icons.savings_rounded : Icons.savings_rounded,
//       ),
//     );
//   }

//   Widget _categoryFieldWidget(String text, IconData icon) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(children: [Icon(icon, color: primaryColor), const SizedBox(width: 10), Text(text)]),
//           const Icon(Icons.arrow_forward_ios_rounded, size: 16),
//         ],
//       ),
//     );
//   }

//   Widget _buildDatePicker() {
//     return GestureDetector(
//       onTap: _pickDate,
//       child: _categoryFieldWidget(
//           "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}", Icons.calendar_month_rounded),
//     );
//   }

//   Widget _buildDescField() {
//     return TextField(
//       controller: descCtrl,
//       maxLines: 2,
//       decoration: InputDecoration(
//         labelText: "Mô tả (tùy chọn)",
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   Widget _buildImagePicker() {
//     Widget content;
//     if (kIsWeb) {
//       content = selectedImageBytes == null
//           ? const Center(child: Icon(Icons.camera_alt_rounded, size: 40, color: Colors.grey))
//           : Image.memory(selectedImageBytes!, fit: BoxFit.cover);
//     } else {
//       content = selectedImageFile == null
//           ? const Center(child: Icon(Icons.camera_alt_rounded, size: 40, color: Colors.grey))
//           : Image.file(selectedImageFile!, fit: BoxFit.cover);
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text("Ảnh hóa đơn", style: TextStyle(fontWeight: FontWeight.w600)),
//         const SizedBox(height: 8),
//         GestureDetector(
//           onTap: () {},
//           child: Container(
//             height: 130,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(color: Colors.grey.shade300),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: ClipRRect(borderRadius: BorderRadius.circular(12), child: content),
//           ),
//         ),
//       ],
//     );
//   }

//   void _showChiMenu() async {
//     final result = await Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (_) => CategoryScreenUI(loai: "Chi")));
//     if (result != null && result is Map<String, dynamic>) {
//       setState(() => selectedChiCon = result);
//     }
//   }

//   void _showThuMenu() async {
//     final result = await Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (_) => CategoryScreenUI(loai: "Thu")));
//     if (result != null && result is Map<String, dynamic>) {
//       setState(() => selectedThuLoai = result);
//     }
//   }

//   Future<void> _pickDate() async {
//     final picked =
//         await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2020), lastDate: DateTime(2100));
//     if (picked != null && picked != selectedDate) setState(() => selectedDate = picked);
//   }

//   void _saveTransaction() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Lưu giao dịch (chỉ test UI)")),
//     );
//   }
// }
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../services/bank_service.dart';
import '../services/transaction_service.dart';
import 'category.dart';
import 'bottom_nav.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  File? selectedImageFile; // Mobile
  Uint8List? selectedImageBytes; // Web

  List<Map<String, dynamic>> accounts = [];
  int? selectedAccountId;

  Map<String, dynamic>? selectedChiCon;
  Map<String, dynamic>? selectedThuLoai;

  final Map<String, IconData> iconsList = {
    "money": Icons.money_rounded,
    "credit_card": Icons.credit_card_rounded,
    "bank": Icons.account_balance_rounded,
    "wallet": Icons.account_balance_wallet_rounded,
    "shopping": Icons.shopping_cart_rounded,
    "food": Icons.fastfood_rounded,
    "category": Icons.category_rounded,
  };

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    final data = await BankService().getAccounts();
    setState(() {
      accounts = data
          .map(
            (e) => {
              "id": e['id'],
              "name": e['ten_tai_khoan'],
              "icon": _mapIcon(e['loai_tai_khoan']),
            },
          )
          .toList();
      selectedAccountId = accounts.isNotEmpty ? accounts[0]['id'] : null;
    });
  }

  IconData _mapIcon(String type) {
    switch (type) {
      case 'Tiền mặt':
        return Icons.money_rounded;
      case 'Thẻ tín dụng':
        return Icons.credit_card_rounded;
      case 'Ngân hàng':
        return Icons.account_balance_rounded;
      case 'Ví điện tử':
        return Icons.account_balance_wallet_rounded;
      default:
        return Icons.account_balance_wallet_rounded;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    if (kIsWeb) {
      final bytes = await image.readAsBytes();
      setState(() {
        selectedImageBytes = bytes;
        selectedImageFile = null;
      });
    } else {
      setState(() {
        selectedImageFile = File(image.path);
        selectedImageBytes = null;
      });
    }
  }

  void _saveTransaction() async {
    if (amountCtrl.text.isEmpty || selectedAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng nhập số tiền và chọn tài khoản"),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Bạn chưa đăng nhập")));
      return;
    }

    final success = await TransactionService().addTransaction(
      userId: userId,
      accountId: selectedAccountId!,
      danhMucId: selectedChiCon?['id'] ?? 53, // Dùng ID danh mục
      type: isChi ? "Chi" : "Thu",
      amount: amountCtrl.text,
      description: descCtrl.text,
      date: selectedDate.toIso8601String(),
      imageFile: selectedImageFile,
      imageBytes: selectedImageBytes,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? "Lưu giao dịch thành công" : "Lỗi khi lưu giao dịch",
        ),
      ),
    );

    if (success) {
      // Reset form
      setState(() {
        amountCtrl.clear();
        descCtrl.clear();
        selectedChiCon = null;
        selectedThuLoai = null;
        selectedImageFile = null;
        selectedImageBytes = null;
        selectedDate = DateTime.now();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Ghi chép giao dịch",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveTransaction,
        backgroundColor: primaryColor,
        child: const Icon(Icons.check),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildToggle(), const SizedBox(height: 24), _buildForm()],
        ),
      ),
    );
  }

  Widget _buildToggle() {
    /* giữ nguyên code */
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
    /* giữ nguyên */
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

  Widget _buildForm() {
    /* giữ nguyên */
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
    /* giữ nguyên */
    return DropdownButtonFormField<int>(
      value: selectedAccountId,
      decoration: InputDecoration(
        labelText: "Tài khoản",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: accounts
          .map(
            (acc) => DropdownMenuItem<int>(
              value: acc['id'],
              child: Row(
                children: [
                  Icon(acc['icon'], color: primaryColor),
                  const SizedBox(width: 8),
                  Text(acc['name']),
                ],
              ),
            ),
          )
          .toList(),
      onChanged: (val) => setState(() => selectedAccountId = val),
    );
  }

  Widget _buildChiDanhMucField() {
    return GestureDetector(
      onTap: _showChiMenu,
      child: _categoryFieldWidget(
        selectedChiCon?['ten_danh_muc'] ?? "Chọn danh mục",
        selectedChiCon != null
            ? iconsList[selectedChiCon!['icon']] ?? Icons.category
            : Icons.category,
      ),
    );
  }

  Widget _buildThuLoaiField() {
    return GestureDetector(
      onTap: _showThuMenu,
      child: _categoryFieldWidget(
        selectedThuLoai?['ten_danh_muc'] ?? "Chọn loại thu",
        selectedThuLoai != null
            ? iconsList[selectedThuLoai!['icon']] ?? Icons.savings_rounded
            : Icons.savings_rounded,
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
    Widget content = kIsWeb
        ? (selectedImageBytes == null
              ? const Center(
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 40,
                    color: Colors.grey,
                  ),
                )
              : Image.memory(selectedImageBytes!, fit: BoxFit.cover))
        : (selectedImageFile == null
              ? const Center(
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 40,
                    color: Colors.grey,
                  ),
                )
              : Image.file(selectedImageFile!, fit: BoxFit.cover));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Ảnh hóa đơn",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
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

  void _showChiMenu() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CategoryScreenUI(loai: "Chi")),
    );
    if (result != null && result is Map<String, dynamic>)
      setState(() => selectedChiCon = result);
  }

  void _showThuMenu() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CategoryScreenUI(loai: "Thu")),
    );
    if (result != null && result is Map<String, dynamic>)
      setState(() => selectedThuLoai = result);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate)
      setState(() => selectedDate = picked);
  }
}
