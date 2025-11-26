import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  /// DANH MỤC MẸ + DANH MỤC CON
  List<Map<String, dynamic>> categories = [
    {
      'name': 'Chi tiêu',
      'children': ['Ăn uống', 'Mua sắm', 'Hóa đơn'],
    },
    {
      'name': 'Thu nhập',
      'children': ['Lương', 'Thưởng'],
    }
  ];

  /// =============================
  ///  THÊM DANH MỤC MẸ
  /// =============================
  void _addParentCategory() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Thêm danh mục chính"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Nhập tên..."),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    categories.add({
                      'name': controller.text.trim(),
                      'children': []
                    });
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Thêm"),
            ),
          ],
        );
      },
    );
  }

  /// =============================
  ///  THÊM DANH MỤC CON
  /// =============================
  void _addChildCategory(int parentIndex) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Thêm danh mục con cho: ${categories[parentIndex]['name']}"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Nhập tên danh mục con..."),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    categories[parentIndex]['children'].add(controller.text.trim());
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Thêm"),
            ),
          ],
        );
      },
    );
  }

  /// =============================
  ///  XÓA DANH MỤC MẸ
  /// =============================
  void _deleteParentCategory(int index) {
    setState(() {
      categories.removeAt(index);
    });
  }

  /// =============================
  ///  XÓA DANH MỤC CON
  /// =============================
  void _deleteChildCategory(int parentIndex, int childIndex) {
    setState(() {
      categories[parentIndex]['children'].removeAt(childIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý danh mục"),
        backgroundColor: Colors.deepOrange,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: _addParentCategory,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, parentIndex) {
          final parent = categories[parentIndex];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ExpansionTile(
              title: Text(
                parent['name'],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              children: [
                /// DANH MỤC CON
                ...List.generate(
                  parent['children'].length,
                  (childIndex) {
                    return ListTile(
                      leading: const Icon(Icons.circle, size: 12),
                      title: Text(parent['children'][childIndex]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _deleteChildCategory(parentIndex, childIndex),
                      ),
                    );
                  },
                ),

                /// NÚT THÊM DANH MỤC CON
                TextButton.icon(
                  onPressed: () => _addChildCategory(parentIndex),
                  icon: const Icon(Icons.add),
                  label: const Text("Thêm danh mục con"),
                ),

                /// XÓA DANH MỤC MẸ
                TextButton.icon(
                  onPressed: () => _deleteParentCategory(parentIndex),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    "Xóa danh mục chính",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
