import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/screen/bottom_nav.dart';
import 'package:frontend/screen/category.dart';
import 'package:frontend/services/transaction_service.dart';

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
  final ImagePicker picker = ImagePicker();

  // ===== TÀI KHOẢN =====
  final List<Map<String, dynamic>> accounts = [
    {"id": 1, "name": "Tiền mặt", "icon": Icons.money_rounded},
    {"id": 2, "name": "Thẻ tín dụng", "icon": Icons.credit_card_rounded},
    {"id": 3, "name": "Ngân hàng", "icon": Icons.account_balance_rounded},
  ];
  int? selectedAccountId;

  // ===== DANH MỤC CHI =====
  final List<Map<String, dynamic>> chiDanhMuc = [
    {
      "name": "Ăn uống",
      "icon": Icons.restaurant,
      "children": [
        {"name": "Nhà hàng", "icon": Icons.local_dining},
        {"name": "Cà phê", "icon": Icons.local_cafe},
        {"name": "Ăn vặt", "icon": Icons.emoji_food_beverage},
      ],
    },
    {
      "name": "Dịch vụ sinh hoạt",
      "icon": Icons.home_repair_service,
      "children": [
        {"name": "Điện", "icon": Icons.lightbulb},
        {"name": "Nước", "icon": Icons.water_drop},
        {"name": "Internet", "icon": Icons.wifi},
      ],
    },
  ];
  String? selectedChiDanhMuc;
  String? selectedChiCon;

  // ===== DANH MỤC THU =====
  final List<Map<String, dynamic>> thuLoai = [
    {"name": "Lương", "icon": Icons.attach_money},
    {"name": "Thưởng", "icon": Icons.card_giftcard},
    {"name": "Được biếu", "icon": Icons.wallet_giftcard},
    {"name": "Lãi", "icon": Icons.trending_up},
  ];
  String? selectedThuLoai;

  // ===== DANH SÁCH GIAO DỊCH =====
  List<dynamic> transactions = [];

  @override
  void initState() {
    super.initState();
    selectedAccountId = accounts.first['id'];
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      final txs = await TransactionService.getTransactions(1); // userId tạm 1
      setState(() => transactions = txs);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Lỗi tải giao dịch")));
    }
  }

  // ================== PICK IMAGE ==================
  Future pickImage() async {
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);
    if (img == null) return;

    if (kIsWeb) {
      final bytes = await img.readAsBytes();
      setState(() {
        selectedImageBytes = bytes;
        selectedImageName = img.name;
      });
    } else {
      setState(() {
        selectedImageFile = File(img.path);
      });
    }
  }

  // ================== SAVE TRANSACTION ==================
  Future<void> saveTransaction() async {
    if (selectedAccountId == null) return;
    if (isChi && selectedChiCon == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Chọn danh mục Chi")));
      return;
    }
    if (!isChi && selectedThuLoai == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Chọn loại Thu")));
      return;
    }

    bool success = await TransactionService.saveTransaction(
      userId: 1,
      accountId: selectedAccountId!,
      categoryId: 1, // TODO: map categoryId từ danh mục
      type: isChi ? "Chi" : "Thu",
      amount: double.tryParse(amountCtrl.text) ?? 0,
      description: descCtrl.text,
      date: selectedDate,
      imageFile: selectedImageFile,
      imageBytes: selectedImageBytes,
      imageName: selectedImageName,
    );

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Lưu thành công")));
      setState(() {
        amountCtrl.clear();
        descCtrl.clear();
        selectedImageFile = null;
        selectedImageBytes = null;
        selectedImageName = null;
        _loadTransactions(); // tải lại danh sách sau khi thêm
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Lưu thất bại")));
    }
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

  // ================= IMAGE PICKER =================
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
          onTap: pickImage,
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

  // ================= FORM FIELDS =================
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
          value: account["id"], // LUÔN LÀ ID
          child: Row(
            children: [
              Icon(account["icon"], color: primaryColor),
              const SizedBox(width: 8),
              Text(account["name"]), // ĐÃ sửa đúng key
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

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: saveTransaction,
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

  // ================= TOGGLE =================
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
    if (transactions.isEmpty) {
      return const Center(child: Text("Chưa có giao dịch nào"));
    }

    return Column(
      children: transactions.map((tx) {
        final amountText =
            "${tx['loai_gd'] == "Chi" ? "-" : "+"}${tx['so_tien']} VND";

        Widget? imgWidget;
        if (tx['anh_hoa_don'] != null) {
          imgWidget = kIsWeb
              ? Image.network(
                  tx['anh_hoa_don'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : Image.file(
                  File(tx['anh_hoa_don']),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                );
        }

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
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  amountText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.edit, size: 20, color: Colors.grey),
                    SizedBox(width: 10),
                    Icon(Icons.delete, size: 20, color: Colors.red),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ================= BOTTOM SHEET =================
  void _showChiMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Quản lý danh mục Chi"),
              trailing: const Icon(Icons.settings),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChiCategoryScreen()),
                );
              },
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: chiDanhMuc.map((cat) {
                  return ExpansionTile(
                    leading: Icon(cat["icon"], color: primaryColor),
                    title: Text(cat["name"]),
                    children: (cat["children"] as List).map((child) {
                      return ListTile(
                        leading: Icon(child["icon"], color: Colors.grey),
                        title: Text(child["name"]),
                        onTap: () {
                          setState(() {
                            selectedChiDanhMuc = cat["name"];
                            selectedChiCon = child["name"];
                          });
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showThuMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Quản lý danh mục Thu"),
              trailing: const Icon(Icons.settings),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ThuCategoryScreen()),
                );
              },
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: thuLoai.map((e) {
                  return ListTile(
                    leading: Icon(e["icon"], color: primaryColor),
                    title: Text(e["name"]),
                    onTap: () {
                      setState(() => selectedThuLoai = e["name"]);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickDate() async {
    DateTime? d = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => selectedDate = d);
  }
}
