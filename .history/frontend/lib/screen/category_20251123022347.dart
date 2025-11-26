import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFFFF7A00);
const Color secondaryColor = Color(0xFFFFD1A8);
const Color backgroundColor = Colors.white;
const Color neutralColor = Color(0xFFF5F5F5);

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // Chọn loại: Chi hay Thu
  bool isChi = true;

  // Danh sách chi
  List<Map<String, dynamic>> chiCategories = [
    {
      "name": "Ăn uống",
      "icon": Icons.restaurant,
      "children": [
        {"name": "Nhà hàng", "icon": Icons.local_dining},
        {"name": "Cà phê", "icon": Icons.local_cafe},
      ],
    },
    {
      "name": "Đi lại",
      "icon": Icons.directions_car,
      "children": [
        {"name": "Taxi", "icon": Icons.local_taxi},
        {"name": "Xăng xe", "icon": Icons.local_gas_station},
      ],
    },
  ];

  // Danh sách thu
  List<Map<String, dynamic>> thuCategories = [
    {"name": "Lương", "icon": Icons.attach_money},
    {"name": "Thưởng", "icon": Icons.card_giftcard},
    {"name": "Được biếu", "icon": Icons.wallet_giftcard},
    {"name": "Lãi", "icon": Icons.trending_up},
  ];

  // Trường để thêm/sửa
  final TextEditingController nameCtrl = TextEditingController();
  IconData? selectedIcon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Quản lý danh mục"),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildToggle(),
            const SizedBox(height: 16),
            Expanded(child: _buildCategoryList()),
            const SizedBox(height: 16),
            _buildAddCategoryButton(),
          ],
        ),
      ),
    );
  }

  // ---------------- Toggle Chi / Thu ----------------
  Widget _buildToggle() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => isChi = true),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isChi ? primaryColor : neutralColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "Chi",
                  style: TextStyle(
                      color: isChi ? Colors.white : primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => isChi = false),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: !isChi ? primaryColor : neutralColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "Thu",
                  style: TextStyle(
                      color: !isChi ? Colors.white : primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- Danh sách danh mục ----------------
  Widget _buildCategoryList() {
    final categories = isChi ? chiCategories : thuCategories;

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Icon(cat['icon'], color: primaryColor),
            title: Text(cat['name']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.grey),
                  onPressed: () => _showAddEditDialog(isEdit: true, index: index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      categories.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------- Thêm danh mục ----------------
  Widget _buildAddCategoryButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showAddEditDialog(),
        icon: const Icon(Icons.add),
        label: const Text("Thêm danh mục"),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // ---------------- Dialog thêm / sửa ----------------
  void _showAddEditDialog({bool isEdit = false, int? index}) {
    final categories = isChi ? chiCategories : thuCategories;
    if (isEdit && index != null) {
      nameCtrl.text = categories[index]['name'];
      selectedIcon = categories[index]['icon'];
    } else {
      nameCtrl.clear();
      selectedIcon = null;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? "Sửa danh mục" : "Thêm danh mục"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Tên danh mục"),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<IconData>(
                value: selectedIcon,
                items: <IconData>[
                  Icons.restaurant,
                  Icons.local_cafe,
                  Icons.directions_car,
                  Icons.local_taxi,
                  Icons.attach_money,
                  Icons.card_giftcard,
                  Icons.wallet_giftcard,
                  Icons.trending_up,
                  Icons.home_repair_service,
                  Icons.lightbulb,
                ].map<DropdownMenuItem<IconData>>((IconData value) {
                  return DropdownMenuItem<IconData>(
                    value: value,
                    child: Row(
                      children: [
                        Icon(value, color: primaryColor),
                        const SizedBox(width: 10),
                        Text(value.codePoint.toString()),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (IconData? val) => setState(() => selectedIcon = val),
                decoration: const InputDecoration(labelText: "Chọn icon"),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Hủy")),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.isEmpty || selectedIcon == null) return;
                setState(() {
                  if (isEdit && index != null) {
                    categories[index]['name'] = nameCtrl.text;
                    categories[index]['icon'] = selectedIcon;
                  } else {
                    categories.add({"name": nameCtrl.text, "icon": selectedIcon});
                  }
                });
                Navigator.pop(context);
              },
              child: const Text("Lưu"),
            )
          ],
        );
      },
    );
  }
}
