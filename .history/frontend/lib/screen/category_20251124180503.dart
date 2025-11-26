// import 'package:flutter/material.dart';
// import '../services/category_service.dart';

// class CategoryScreenUI extends StatefulWidget {
//   const CategoryScreenUI({super.key});

//   @override
//   State<CategoryScreenUI> createState() => _CategoryScreenUIState();
// }

// class _CategoryScreenUIState extends State<CategoryScreenUI> {
//   final CategoryService _service = CategoryService();
//   List<Map<String, dynamic>> categories = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadCategories();
//   }

//   Future<void> _loadCategories() async {
//     final data = await _service.getCategories();
//     setState(() => categories = data);
//   }

//   void _addCategory({Map<String, dynamic>? parent}) {
//     final controller = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text(parent == null ? "Thêm danh mục cha" : "Thêm danh mục con"),
//         content: TextField(
//           controller: controller,
//           decoration: const InputDecoration(labelText: "Tên danh mục"),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Hủy"),
//           ),
//           TextButton(
//             onPressed: () async {
//               final success = await _service.addCategory({
//                 "nguoi_dung_id": 1, // dùng SharedPreferences ở đây
//                 "ten_danh_muc": controller.text,
//                 "loai": parent == null ? "Chi" : parent['loai'],
//                 "parent_id": parent?['id'],
//               });
//               if (success) {
//                 Navigator.pop(context);
//                 _loadCategories();
//               }
//             },
//             child: const Text("Thêm"),
//           ),
//         ],
//       ),
//     );
//   }

//   void _editCategory(Map<String, dynamic> category) {
//     final controller = TextEditingController(text: category['ten_danh_muc']);
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Sửa danh mục"),
//         content: TextField(
//           controller: controller,
//           decoration: const InputDecoration(labelText: "Tên danh mục"),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Hủy"),
//           ),
//           TextButton(
//             onPressed: () async {
//               final success = await _service.editCategory(category['id'], {
//                 "ten_danh_muc": controller.text,
//               });
//               if (success) {
//                 Navigator.pop(context);
//                 _loadCategories();
//               }
//             },
//             child: const Text("Lưu"),
//           ),
//         ],
//       ),
//     );
//   }

//   void _deleteCategory(Map<String, dynamic> category) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Xóa danh mục"),
//         content: Text("Bạn có chắc muốn xóa '${category['ten_danh_muc']}'?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text("Hủy"),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text("Xóa"),
//           ),
//         ],
//       ),
//     );
//     if (confirm == true) {
//       final success = await _service.deleteCategory(category['id']);
//       if (success) _loadCategories();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final parentCategories = categories
//         .where((c) => c['parent_id'] == null)
//         .toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Danh mục"),
//         backgroundColor: Colors.orange,
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _addCategory(),
//         child: const Icon(Icons.add),
//         backgroundColor: Colors.orange,
//       ),
//       body: ListView.builder(
//         itemCount: parentCategories.length,
//         itemBuilder: (context, index) {
//           final parent = parentCategories[index];
//           final children = categories
//               .where((c) => c['parent_id'] == parent['id'])
//               .toList();

//           return Card(
//             margin: const EdgeInsets.all(8),
//             child: ExpansionTile(
//               leading: const Icon(Icons.category),
//               title: Text(
//                 parent['ten_danh_muc'],
//                 style: const TextStyle(fontSize: 18),
//               ),
//               children: [
//                 ...children.map(
//                   (child) => ListTile(
//                     leading: const Icon(Icons.arrow_right),
//                     title: Text(child['ten_danh_muc']),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.edit, color: Colors.blue),
//                           onPressed: () => _editCategory(child),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.delete, color: Colors.red),
//                           onPressed: () => _deleteCategory(child),
//                         ),
//                       ],
//                     ),
//                     onTap: () => Navigator.pop(
//                       context,
//                       child,
//                     ), // trả về TransactionScreen
//                   ),
//                 ),
//                 TextButton.icon(
//                   onPressed: () => _addCategory(parent: parent),
//                   icon: const Icon(Icons.add),
//                   label: const Text("Thêm danh mục con"),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.edit, color: Colors.blue),
//                       onPressed: () => _editCategory(parent),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       onPressed: () => _deleteCategory(parent),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
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

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final data = await _service.getCategories();
    setState(() {
      // Lọc theo loại danh mục (Chi hoặc Thu)
      categories = data.where((c) => c['loai'] == widget.loai).toList();
    });
  }

  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 1; // fallback 1 nếu chưa có
  }

  void _addCategory({Map<String, dynamic>? parent}) async {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(parent == null ? "Thêm danh mục cha" : "Thêm danh mục con"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Tên danh mục"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () async {
              final userId = await _getUserId();
              final success = await _service.addCategory({
                "nguoi_dung_id": userId,
                "ten_danh_muc": controller.text,
                "loai": widget.loai,
                "parent_id": parent?['id'],
              });
              if (success) {
                Navigator.pop(context);
                _loadCategories();
              }
            },
            child: const Text("Thêm"),
          ),
        ],
      ),
    );
  }

  void _editCategory(Map<String, dynamic> category) {
    final controller = TextEditingController(text: category['ten_danh_muc']);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Sửa danh mục"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Tên danh mục"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () async {
              final success = await _service.editCategory(category['id'], controller.text);
              if (success) {
                Navigator.pop(context);
                _loadCategories();
              }
            },
            child: const Text("Lưu"),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(Map<String, dynamic> category) async {
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
        onPressed: () => _addCategory(),
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
              leading: const Icon(Icons.category),
              title: Text(parent['ten_danh_muc'], style: const TextStyle(fontSize: 18)),
              children: [
                ...children.map(
                  (child) => ListTile(
                    leading: const Icon(Icons.arrow_right),
                    title: Text(child['ten_danh_muc']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _editCategory(child)),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteCategory(child)),
                      ],
                    ),
                    onTap: () => Navigator.pop(context, child['ten_danh_muc']), // Trả về String tên danh mục
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _addCategory(parent: parent),
                  icon: const Icon(Icons.add),
                  label: const Text("Thêm danh mục con"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _editCategory(parent)),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteCategory(parent)),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
