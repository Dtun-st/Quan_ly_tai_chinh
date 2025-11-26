// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:frontend/screen/bottom_nav.dart';
// import 'package:frontend/screen/category.dart'; // Import screen category nếu cần

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

//   File? selectedImage; // 📌 Lưu ảnh hóa đơn

//   final ImagePicker picker = ImagePicker();

//   Future pickImage() async {
//     final XFile? img = await picker.pickImage(source: ImageSource.gallery);
//     if (img != null) {
//       setState(() {
//         selectedImage = File(img.path);
//       });
//     }
//   }

//   final List<Map<String, dynamic>> accounts = [
//     {"id": 1, "name": "Tiền mặt", "icon": Icons.money_rounded},
//     {"id": 2, "name": "Thẻ tín dụng", "icon": Icons.credit_card_rounded},
//     {"id": 3, "name": "Ngân hàng", "icon": Icons.account_balance_rounded},
//   ];
//   int? selectedAccountId;

//   final List<Map<String, dynamic>> chiDanhMuc = [
//     {
//       "name": "Ăn uống",
//       "icon": Icons.restaurant,
//       "children": [
//         {"name": "Nhà hàng", "icon": Icons.local_dining},
//         {"name": "Cà phê", "icon": Icons.local_cafe},
//         {"name": "Ăn vặt", "icon": Icons.emoji_food_beverage},
//       ],
//     },
//     {
//       "name": "Dịch vụ sinh hoạt",
//       "icon": Icons.home_repair_service,
//       "children": [
//         {"name": "Điện", "icon": Icons.lightbulb},
//         {"name": "Nước", "icon": Icons.water_drop},
//         {"name": "Internet", "icon": Icons.wifi},
//       ],
//     },
//   ];

//   String? selectedChiDanhMuc;
//   String? selectedChiCon;

//   final List<Map<String, dynamic>> thuLoai = [
//     {"name": "Lương", "icon": Icons.attach_money},
//     {"name": "Thưởng", "icon": Icons.card_giftcard},
//     {"name": "Được biếu", "icon": Icons.wallet_giftcard},
//     {"name": "Lãi", "icon": Icons.trending_up},
//   ];
//   String? selectedThuLoai;

//   @override
//   void initState() {
//     super.initState();
//     selectedAccountId = accounts.first['id'];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         title: const Text(
//           "Ghi chép giao dịch",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: primaryColor,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildToggle(),
//             const SizedBox(height: 24),
//             _buildForm(),
//             const SizedBox(height: 30),
//             _buildTitle("Giao dịch gần đây"),
//             const SizedBox(height: 12),
//             _buildTransactionList(),
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//       bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
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
//           const SizedBox(height: 20),
//           _buildSaveButton(),
//         ],
//       ),
//     );
//   }

//   // ------------------------- UI PICK ẢNH -----------------------------
//   Widget _buildImagePicker() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Ảnh hóa đơn",
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         const SizedBox(height: 8),
//         GestureDetector(
//           onTap: pickImage,
//           child: Container(
//             height: 130,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(color: Colors.grey.shade300),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: selectedImage == null
//                 ? const Center(
//                     child: Icon(
//                       Icons.camera_alt_rounded,
//                       size: 40,
//                       color: Colors.grey,
//                     ),
//                   )
//                 : ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.file(selectedImage!, fit: BoxFit.cover),
//                   ),
//           ),
//         ),
//       ],
//     );
//   }

//   // -------------------- CÁC FIELD ---------------------
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
//       items: accounts.map((a) {
//         return DropdownMenuItem<int>(
//           value: a['id'],
//           child: Row(
//             children: [
//               Icon(a['icon'], color: primaryColor),
//               const SizedBox(width: 8),
//               Text(a['name']),
//             ],
//           ),
//         );
//       }).toList(),
//       onChanged: (v) => setState(() => selectedAccountId = v),
//       decoration: InputDecoration(
//         labelText: "Tài khoản",
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   Widget _buildChiDanhMucField() {
//     return GestureDetector(
//       onTap: _showChiMenu,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.grey.shade300),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 const Icon(Icons.category_rounded, color: primaryColor),
//                 const SizedBox(width: 10),
//                 Text(
//                   selectedChiCon ?? "Chọn danh mục",
//                   style: TextStyle(
//                     color: selectedChiCon == null ? Colors.grey : Colors.black,
//                     fontWeight: selectedChiCon == null
//                         ? FontWeight.normal
//                         : FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             const Icon(Icons.arrow_forward_ios_rounded, size: 16),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildThuLoaiField() {
//     return DropdownButtonFormField<String>(
//       value: selectedThuLoai,
//       items: thuLoai.map((e) {
//         return DropdownMenuItem<String>(
//           value: e['name'],
//           child: Row(
//             children: [
//               Icon(e['icon'], color: primaryColor),
//               const SizedBox(width: 8),
//               Text(e['name']),
//             ],
//           ),
//         );
//       }).toList(),
//       onChanged: (v) => setState(() => selectedThuLoai = v),
//       decoration: InputDecoration(
//         labelText: "Loại thu",
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   Widget _buildDatePicker() {
//     return GestureDetector(
//       onTap: _pickDate,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(color: Colors.grey.shade300),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           children: [
//             const Icon(Icons.calendar_month_rounded, color: primaryColor),
//             const SizedBox(width: 10),
//             Text(
//               "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const Spacer(),
//             const Icon(Icons.edit_calendar_rounded),
//           ],
//         ),
//       ),
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

//   Widget _buildSaveButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton.icon(
//         onPressed: () {},
//         icon: const Icon(Icons.check),
//         label: const Text("LƯU GIAO DỊCH"),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: primaryColor,
//           padding: const EdgeInsets.symmetric(vertical: 14),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//       ),
//     );
//   }

//   // ---------------- DANH SÁCH ----------------------
//   Widget _buildTitle(String text) {
//     return Text(
//       text,
//       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//     );
//   }

//   Widget _buildTransactionList() {
//     List<Map<String, dynamic>> fakeTx = [
//       {
//         "type": "Chi",
//         "name": "Cà phê",
//         "amount": "50,000",
//         "date": "23/10",
//         "image": null,
//       },
//       {
//         "type": "Thu",
//         "name": "Lương",
//         "amount": "5,000,000",
//         "date": "22/10",
//         "image": null,
//       },
//       {
//         "type": "Chi",
//         "name": "Taxi",
//         "amount": "120,000",
//         "date": "21/10",
//         "image": null,
//       },
//     ];

//     return Column(
//       children: fakeTx.map((tx) {
//         return Card(
//           margin: const EdgeInsets.symmetric(vertical: 6),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: ListTile(
//             leading: CircleAvatar(
//               backgroundColor: tx['type'] == "Chi"
//                   ? secondaryColor
//                   : secondaryColor.withOpacity(0.5),
//               child: Icon(
//                 tx['type'] == "Chi" ? Icons.arrow_upward : Icons.arrow_downward,
//                 color: primaryColor,
//               ),
//             ),
//             title: Text(tx['name']),
//             subtitle: Text("Ngày: ${tx['date']}"),
//             trailing: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "${tx['type'] == "Chi" ? "-" : "+"}${tx['amount']} VND",
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: primaryColor,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: const [
//                     Icon(Icons.edit, size: 20, color: Colors.grey),
//                     SizedBox(width: 10),
//                     Icon(Icons.delete, size: 20, color: Colors.red),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   // ------------------- Bottom Sheet chọn danh mục ----------------------
//   void _showChiMenu() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   const Expanded(
//                     child: Text(
//                       "Chọn Danh Mục",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const CategoryScreen(title: 'Quản lý'),
//                         ),
//                       );
//                     },
//                     icon: const Icon(Icons.settings, size: 20),
//                     label: const Text("Quản lý"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: primaryColor,
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 8,
//                         horizontal: 12,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Divider(),
//             Flexible(
//               child: ListView(
//                 padding: const EdgeInsets.all(16),
//                 shrinkWrap: true,
//                 children: chiDanhMuc.map((cat) {
//                   return ExpansionTile(
//                     leading: Icon(cat["icon"], color: primaryColor),
//                     title: Text(cat["name"]),
//                     children: (cat["children"] as List).map((child) {
//                       return ListTile(
//                         leading: Icon(child["icon"], color: Colors.grey),
//                         title: Text(child["name"]),
//                         onTap: () {
//                           setState(() {
//                             selectedChiDanhMuc = cat["name"];
//                             selectedChiCon = child["name"];
//                           });
//                           Navigator.pop(context);
//                         },
//                       );
//                     }).toList(),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _pickDate() async {
//     DateTime? d = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (d != null) {
//       setState(() => selectedDate = d);
//     }
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/screen/bottom_nav.dart';
import 'package:frontend/screen/category.dart'; // chứa ChiCategoryScreen & ThuCategoryScreen

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

  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  Future pickImage() async {
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() {
        selectedImage = File(img.path);
      });
    }
  }

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

  @override
  void initState() {
    super.initState();
    selectedAccountId = accounts.first['id'];
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

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Ảnh hóa đơn", style: TextStyle(fontWeight: FontWeight.w600)),
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
            child: selectedImage == null
                ? const Center(
                    child: Icon(Icons.camera_alt_rounded, size: 40, color: Colors.grey),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(selectedImage!, fit: BoxFit.cover),
                  ),
          ),
        ),
      ],
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
      items: accounts.map((a) {
        return DropdownMenuItem<int>(
          value: a['id'],
          child: Row(
            children: [
              Icon(a['icon'], color: primaryColor),
              const SizedBox(width: 8),
              Text(a['name']),
            ],
          ),
        );
      }).toList(),
      onChanged: (v) => setState(() => selectedAccountId = v),
      decoration: InputDecoration(
        labelText: "Tài khoản",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildChiDanhMucField() {
    return GestureDetector(
      onTap: _showChiMenu,
      child: _categoryFieldWidget(selectedChiCon ?? "Chọn danh mục", Icons.category_rounded),
    );
  }

  Widget _buildThuLoaiField() {
    return GestureDetector(
      onTap: _showThuMenu,
      child: _categoryFieldWidget(selectedThuLoai ?? "Chọn loại thu", Icons.savings_rounded),
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
          Row(children: [Icon(icon, color: primaryColor), const SizedBox(width: 10), Text(text)]),
          const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: _pickDate,
      child: _categoryFieldWidget(
          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}", Icons.calendar_month_rounded),
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
        onPressed: () {
          // TODO: Lưu giao dịch
        },
        icon: const Icon(Icons.check),
        label: const Text("LƯU GIAO DỊCH"),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget _buildTransactionList() {
    List<Map<String, dynamic>> fakeTx = [
      {"type": "Chi", "name": "Cà phê", "amount": "50,000", "date": "23/10", "image": null},
      {"type": "Thu", "name": "Lương", "amount": "5,000,000", "date": "22/10", "image": null},
      {"type": "Chi", "name": "Taxi", "amount": "120,000", "date": "21/10", "image": null},
    ];

    return Column(
      children: fakeTx.map((tx) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: tx['type'] == "Chi" ? secondaryColor : secondaryColor.withOpacity(0.5),
              child: Icon(tx['type'] == "Chi" ? Icons.arrow_upward : Icons.arrow_downward, color: primaryColor),
            ),
            title: Text(tx['name']),
            subtitle: Text("Ngày: ${tx['date']}"),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${tx['type'] == "Chi" ? "-" : "+"}${tx['amount']} VND",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
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

  // ===== BOTTOM SHEET =====
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
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ChiCategoryScreen()));
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
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ThuCategoryScreen()));
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
