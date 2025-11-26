import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/category_service.dart';

class CategoryScreenUI extends StatefulWidget {
  final String loai; // "Chi" hoặc "Thu"
  const CategoryScreenUI({Key? key, required this.loai}) : super(key: key);

  @override
  State<CategoryScreenUI> createState() => _CategoryScreenUIState();
}

class _CategoryScreenUIState extends State<CategoryScreenUI> {
  final CategoryService _service = CategoryService();
  List<Map<String, dynamic>> categories = [];

  // Danh sách icon có sẵn
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
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final data = await _service.getCategories(loai: widget.loai);
    setState(() => categories = data);
  }

  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 1;
  }

  void _addOrEditCategory({Map<String, dynamic>? category, Map<String, dynamic>? parent}) async {
    final nameCtrl = TextEditingController(text: category?['ten_danh_muc'] ?? '');

    // Chọn icon mặc định nếu icon hiện tại không có trong iconsList
    String selectedIconKey = category != null && iconsList.containsKey(category['icon'])
        ? category['icon']
        : iconsList.keys.first;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text(category == null
              ? (parent == null ? "Thêm danh mục cha" : "Thêm danh mục con")
              : "Sửa danh mục"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Tên danh mục"),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedIconKey,
                decoration: const InputDecoration(labelText: "Chọn icon"),
                items: iconsList.entries
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e.key,
                        child: Row(
                          children: [Icon(e.value), const SizedBox(width: 8), Text(e.key)],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setStateDialog(() => selectedIconKey = val!),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
            TextButton(
              onPressed: () async {
                final userId = await _getUserId();
                bool success = false;

                if (category == null) {
                  // Thêm danh mục mới
                  success = await _service.addCategory({
                    "nguoi_dung_id": userId,
                    "ten_danh_muc": nameCtrl.text,
                    "loai": widget.loai,
                    "parent_id": parent?['id'],
                    "icon": selectedIconKey,
                  });
                } else if (category['nguoi_dung_id'] != null) {
                  // Sửa danh mục của người dùng
                  success = await _service.editCategory(category['id'], {
                    "ten_danh_muc": nameCtrl.text,
                    "icon": selectedIconKey,
                  });
                }

                if (success) {
                  Navigator.pop(context);
                  _loadCategories();
                }
              },
              child: const Text("Lưu"),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteCategory(Map<String, dynamic> category) async {
    // Không xóa danh mục hệ thống
    if (category['nguoi_dung_id'] == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xóa danh mục"),
        content: Text("Bạn có chắc muốn xóa '${category['ten_danh_muc']}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Hủy")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Xóa")),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _service.deleteCategory(category['id']);
      if (success) _loadCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    final parentCategories = categories.where((c) => c['parent_id'] == null).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Danh mục ${widget.loai}"),
        backgroundColor: Colors.orange,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditCategory(),
        child: const Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: parentCategories.length,
        itemBuilder: (context, index) {
          final parent = parentCategories[index];
          final children = categories.where((c) => c['parent_id'] == parent['id']).toList();

          return Card(
            margin: const EdgeInsets.all(8),
            child: ExpansionTile(
              leading: Icon(iconsList[parent['icon']] ?? Icons.category),
              title: Text(parent['ten_danh_muc'], style: const TextStyle(fontSize: 18)),
              children: [
                ...children.map(
                  (child) => ListTile(
                    leading: Icon(iconsList[child['icon']] ?? Icons.arrow_right),
                    title: Text(child['ten_danh_muc']),
                    trailing: child['nguoi_dung_id'] != null
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _addOrEditCategory(category: child)),
                              IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteCategory(child)),
                            ],
                          )
                        : null,
                    onTap: () => Navigator.pop(context, child),
                  ),
                ),
                if (parent['nguoi_dung_id'] != null)
                  TextButton.icon(
                    onPressed: () => _addOrEditCategory(parent: parent),
                    icon: const Icon(Icons.add),
                    label: const Text("Thêm danh mục con"),
                  ),
                if (parent['nguoi_dung_id'] != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _addOrEditCategory(category: parent)),
                      IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCategory(parent)),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
