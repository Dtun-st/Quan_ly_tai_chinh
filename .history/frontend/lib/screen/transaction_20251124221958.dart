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
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../services/bank_service.dart';
import '../api_config.dart';
import 'category.dart';
import 'bottom_nav.dart';

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

  File? selectedImageFile;        // Mobile
  Uint8List? selectedImageBytes;  // Web

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

  List<Map<String, dynamic>> recentTransactions = [];

  @override
  void initState() {
    super.initState();
    _loadAccounts();
    _loadRecentTransactions();
  }

  Future<void> _loadAccounts() async {
    final data = await BankService().getAccounts();
    setState(() {
      accounts = data.map((e) => {
        "id": e['id'],
        "name": e['ten_tai_khoan'],
        "icon": _mapIcon(e['loai_tai_khoan']),
      }).toList();
      selectedAccountId = accounts.isNotEmpty ? accounts[0]['id'] : null;
    });
  }

  IconData _mapIcon(String type) {
    switch (type) {
      case 'Tiền mặt': return Icons.money_rounded;
      case 'Thẻ tín dụng': return Icons.credit_card_rounded;
      case 'Ngân hàng': return Icons.account_balance_rounded;
      case 'Ví điện tử': return Icons.account_balance_wallet_rounded;
      default: return Icons.account_balance_wallet_rounded;
    }
  }

  // ===================== PICK IMAGE =====================
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

  // ===================== UPLOAD IMAGE =====================
  Future<String?> _uploadImage() async {
    if (selectedImageFile == null && selectedImageBytes == null) return null;

    var uri = Uri.parse('${ApiConfig.baseUrl}/upload');
    var request = http.MultipartRequest("POST", uri);

    if (kIsWeb && selectedImageBytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          "billImage",
          selectedImageBytes!,
          filename: "bill.jpg",
          contentType: MediaType("image", "jpeg"),
        ),
      );
    } else if (selectedImageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "billImage",
          selectedImageFile!.path,
          contentType: MediaType("image", "jpeg"),
        ),
      );
    }

    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final data = jsonDecode(respStr);
      return data['billImage']; // URL trả về từ server
    } else {
      return null;
    }
  }

  // ===================== SAVE TRANSACTION =====================
  Future<void> _saveTransaction() async {
    final amount = amountCtrl.text;
    final desc = descCtrl.text;

    if (amount.isEmpty || selectedAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập số tiền và chọn tài khoản")),
      );
      return;
    }

    final imageUrl = await _uploadImage();

    final uri = Uri.parse('${ApiConfig.baseUrl}/transactions');
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "amount": amount,
        "note": desc,
        "type": isChi ? "Chi" : "Thu",
        "accountId": selectedAccountId,
        "category": isChi ? selectedChiCon?['ten_danh_muc'] : selectedThuLoai?['ten_danh_muc'],
        "date": selectedDate.toIso8601String(),
        "billImage": imageUrl
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã lưu giao dịch!")),
      );

      // Xóa dữ liệu form
      amountCtrl.clear();
      descCtrl.clear();
      setState(() {
        selectedImageFile = null;
        selectedImageBytes = null;
        selectedChiCon = null;
        selectedThuLoai = null;
        selectedDate = DateTime.now();
      });

      _loadRecentTransactions();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lưu thất bại: ${response.statusCode}")),
      );
    }
  }

  // ===================== LOAD RECENT TRANSACTIONS =====================
  Future<void> _loadRecentTransactions() async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/transactions');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      setState(() {
        recentTransactions = data.reversed.take(5).map((e) => e as Map<String, dynamic>).toList();
      });
    }
  }

  // ===================== UI =====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(title: const Text("Ghi chép giao dịch"), backgroundColor: primaryColor),
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
          children: [
            _buildToggle(),
            const SizedBox(height: 24),
            _buildForm(),
            const SizedBox(height: 24),
            _buildRecentTransactions(),
          ],
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
          _buildImagePickerWidget(),
        ],
      ),
    );
  }

  Widget _buildAmountField() => TextField(
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

  Widget _buildAccountDropdown() => DropdownButtonFormField<int>(
    value: selectedAccountId,
    decoration: InputDecoration(
      labelText: "Tài khoản",
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    items: accounts.map((acc) {
      return DropdownMenuItem<int>(
        value: acc['id'],
        child: Row(children: [
          Icon(acc['icon'], color: primaryColor),
          const SizedBox(width: 8),
          Text(acc['name']),
        ]),
      );
    }).toList(),
    onChanged: (val) => setState(() => selectedAccountId = val),
  );

  Widget _buildChiDanhMucField() => GestureDetector(
    onTap: _showChiMenu,
    child: _categoryFieldWidget(
      selectedChiCon != null ? selectedChiCon!['ten_danh_muc'] : "Chọn danh mục",
      selectedChiCon != null ? iconsList[selectedChiCon!['icon']] ?? Icons.category : Icons.category,
    ),
  );

  Widget _buildThuLoaiField() => GestureDetector(
    onTap: _showThuMenu,
    child: _categoryFieldWidget(
      selectedThuLoai != null ? selectedThuLoai!['ten_danh_muc'] : "Chọn loại thu",
      selectedThuLoai != null ? iconsList[selectedThuLoai!['icon']] ?? Icons.savings_rounded : Icons.savings_rounded,
    ),
  );

  Widget _categoryFieldWidget(String text, IconData icon) => Container(
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [Icon(icon, color: primaryColor), const SizedBox(width: 10), Text(text)]),
      const Icon(Icons.arrow_forward_ios_rounded, size: 16),
    ]),
  );

  Widget _buildDescField() => TextField(
    controller: descCtrl,
    maxLines: 2,
    decoration: InputDecoration(
      labelText: "Mô tả (tùy chọn)",
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  Widget _buildDatePicker() => GestureDetector(
    onTap: _pickDate,
    child: _categoryFieldWidget(
      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
      Icons.calendar_month_rounded,
    ),
  );

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  void _showChiMenu() async {
    final r = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CategoryScreenUI(loai: "Chi")),
    );
    if (r != null) setState(() => selectedChiCon = r);
  }

  void _showThuMenu() async {
    final r = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CategoryScreenUI(loai: "Thu")),
    );
    if (r != null) setState(() => selectedThuLoai = r);
  }

  Widget _buildImagePickerWidget() {
    Widget content;

    if (kIsWeb) {
      content = selectedImageBytes == null
          ? const Center(child: Icon(Icons.camera_alt_rounded, size: 40, color: Colors.grey))
          : Image.memory(selectedImageBytes!, fit: BoxFit.cover);
    } else {
      content = selectedImageFile == null
          ? const Center(child: Icon(Icons.camera_alt_rounded, size: 40, color: Colors.grey))
          : Image.file(selectedImageFile!, fit: BoxFit.cover);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Ảnh hóa đơn", style: TextStyle(fontWeight: FontWeight.w600)),
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
            child: ClipRRect(borderRadius: BorderRadius.circular(12), child: content),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    if (recentTransactions.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Giao dịch gần nhất", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        ...recentTransactions.map((tx) => Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: tx['billImage'] != null
                ? Image.network('${ApiConfig.baseUrl}${tx['billImage']}', width: 50, height: 50, fit: BoxFit.cover)
                : const Icon(Icons.receipt),
            title: Text("${tx['type']}: ${tx['amount']} VND"),
            subtitle: Text(tx['note'] ?? ""),
            trailing: Text(tx['date']?.substring(0,10) ?? ""),
          ),
        ))
      ],
    );
  }
}
