// import 'package:flutter/material.dart';
// import '../services/category_service.dart';

// class CategoryScreen extends StatefulWidget {
//   final String title;
//   const CategoryScreen({super.key, required this.title});

//   @override
//   State<CategoryScreen> createState() => _CategoryScreenState();
// }

// class _CategoryScreenState extends State<CategoryScreen> {
//   List<Map<String, dynamic>> categories = [];

//   final List<IconData> availableIcons = [
//     Icons.fastfood,
//     Icons.shopping_bag,
//     Icons.home,
//     Icons.lightbulb,
//     Icons.directions_car,
//     Icons.pets,
//     Icons.sports_basketball,
//     Icons.school,
//     Icons.favorite,
//     Icons.savings,
//     Icons.attach_money,
//     Icons.card_giftcard,
//     Icons.local_drink,
//     Icons.devices,
//     Icons.checkroom,
//     Icons.rice_bowl,
//     Icons.shopping_cart,
//     Icons.wallet,
//     Icons.home_work,
//     Icons.monetization_on,
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadCategories();
//   }

//   Future<void> _loadCategories() async {
//     final data = await CategoryService.getCategories(
//         widget.title == "Chi tiêu" ? "Chi" : "Thu");
//     setState(() {
//       categories = data;
//     });
//   }

//   Future<IconData?> chooseIcon() async {
//     return showDialog<IconData>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Chọn icon"),
//           content: SizedBox(
//             width: 300,
//             height: 250,
//             child: GridView.builder(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10),
//               itemCount: availableIcons.length,
//               itemBuilder: (context, index) {
//                 return IconButton(
//                   icon: Icon(availableIcons[index], size: 28),
//                   onPressed: () => Navigator.pop(context, availableIcons[index]),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _addParentCategory() async {
//     TextEditingController controller = TextEditingController();
//     IconData? selectedIcon;

//     await showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//               title: Text("Thêm ${widget.title}"),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     controller: controller,
//                     decoration: const InputDecoration(hintText: "Nhập tên danh mục"),
//                   ),
//                   const SizedBox(height: 12),
//                   ElevatedButton(
//                       onPressed: () async {
//                         selectedIcon = await chooseIcon();
//                       },
//                       child: const Text("Chọn icon")),
//                 ],
//               ),
//               actions: [
//                 TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
//                 ElevatedButton(
//                     onPressed: () async {
//                       if (controller.text.isNotEmpty && selectedIcon != null) {
//                         await CategoryService.addCategory(
//                             controller.text.trim(),
//                             widget.title == "Chi tiêu" ? "Chi" : "Thu",
//                             selectedIcon!.codePoint.toString());
//                         _loadCategories();
//                         Navigator.pop(context);
//                       }
//                     },
//                     child: const Text("Thêm")),
//               ],
//             ));
//   }

//   void _addChildCategory(int parentId) async {
//     TextEditingController controller = TextEditingController();
//     IconData? selectedIcon;

//     await showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//               title: const Text("Thêm danh mục con"),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     controller: controller,
//                     decoration: const InputDecoration(hintText: "Nhập tên danh mục con"),
//                   ),
//                   const SizedBox(height: 12),
//                   ElevatedButton(
//                       onPressed: () async {
//                         selectedIcon = await chooseIcon();
//                       },
//                       child: const Text("Chọn icon")),
//                 ],
//               ),
//               actions: [
//                 TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
//                 ElevatedButton(
//                     onPressed: () async {
//                       if (controller.text.isNotEmpty && selectedIcon != null) {
//                         await CategoryService.addChildCategory(
//                             parentId, controller.text.trim(), selectedIcon!.codePoint.toString());
//                         _loadCategories();
//                         Navigator.pop(context);
//                       }
//                     },
//                     child: const Text("Thêm")),
//               ],
//             ));
//   }

//   Future<void> _editCategory(int id, String currentName, String currentIcon) async {
//     TextEditingController controller = TextEditingController(text: currentName);
//     IconData? selectedIcon = IconData(int.parse(currentIcon), fontFamily: 'MaterialIcons');

//     await showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//               title: const Text("Sửa danh mục"),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(controller: controller),
//                   const SizedBox(height: 12),
//                   ElevatedButton(
//                       onPressed: () async {
//                         selectedIcon = await chooseIcon();
//                       },
//                       child: const Text("Chọn icon")),
//                 ],
//               ),
//               actions: [
//                 TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
//                 ElevatedButton(
//                     onPressed: () async {
//                       if (controller.text.isNotEmpty && selectedIcon != null) {
//                         await CategoryService.updateCategory(
//                             id, controller.text.trim(), selectedIcon!.codePoint.toString());
//                         _loadCategories();
//                         Navigator.pop(context);
//                       }
//                     },
//                     child: const Text("Lưu")),
//               ],
//             ));
//   }

//   Future<void> _deleteCategory(int id) async {
//     await CategoryService.deleteCategory(id);
//     _loadCategories();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Danh mục ${widget.title}"),
//         backgroundColor: Colors.deepOrange,
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _addParentCategory,
//         backgroundColor: Colors.deepOrange,
//         child: const Icon(Icons.add),
//       ),
//       body: ListView.builder(
//         itemCount: categories.length,
//         itemBuilder: (context, index) {
//           final parent = categories[index];
//           final parentName = parent['name']?.toString() ?? '';
//           final parentIcon = parent['icon']?.toString() ?? '0';

//           return Card(
//             margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             child: ExpansionTile(
//               leading: Icon(
//                   IconData(int.parse(parentIcon), fontFamily: 'MaterialIcons'),
//                   size: 28),
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(parentName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   Row(
//                     children: [
//                       IconButton(
//                           icon: const Icon(Icons.edit, color: Colors.blue),
//                           onPressed: () => _editCategory(parent['id'], parentName, parentIcon)),
//                       IconButton(
//                           icon: const Icon(Icons.delete, color: Colors.red),
//                           onPressed: () => _deleteCategory(parent['id'])),
//                     ],
//                   ),
//                 ],
//               ),
//               children: [
//                 ...((parent['children'] ?? []) as List).map((child) {
//                   final childName = child['name']?.toString() ?? '';
//                   final childIcon = child['icon']?.toString() ?? '0';
//                   return ListTile(
//                     leading: Icon(IconData(int.parse(childIcon), fontFamily: 'MaterialIcons')),
//                     title: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(childName),
//                         Row(
//                           children: [
//                             IconButton(
//                                 icon: const Icon(Icons.edit, color: Colors.blue),
//                                 onPressed: () => _editCategory(child['id'], childName, childIcon)),
//                             IconButton(
//                                 icon: const Icon(Icons.delete, color: Colors.red),
//                                 onPressed: () => _deleteCategory(child['id'])),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//                 TextButton.icon(
//                     onPressed: () => _addChildCategory(parent['id']),
//                     icon: const Icon(Icons.add),
//                     label: const Text("Thêm danh mục con")),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/category_service.dart';

class CategoryScreen extends StatefulWidget {
  final String title;
  const CategoryScreen({super.key, required this.title});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Map<String, dynamic>> categories = [];

  // Map name -> IconData, dùng cho chọn icon
  final Map<String, IconData> availableIcons = {
    'fastfood': Icons.fastfood,
    'shopping_bag': Icons.shopping_bag,
    'home': Icons.home,
    'lightbulb': Icons.lightbulb,
    'car': Icons.directions_car,
    'pets': Icons.pets,
    'basketball': Icons.sports_basketball,
    'school': Icons.school,
    'favorite': Icons.favorite,
    'savings': Icons.savings,
    'money': Icons.attach_money,
    'gift': Icons.card_giftcard,
    'drink': Icons.local_drink,
    'devices': Icons.devices,
    'clothes': Icons.checkroom,
    'rice': Icons.rice_bowl,
    'cart': Icons.shopping_cart,
    'wallet': Icons.wallet,
    'home_work': Icons.home_work,
    'monetization': Icons.monetization_on,
    // FontAwesome examples
    'utensils': FontAwesomeIcons.utensils,
    'map': FontAwesomeIcons.map,
  };

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final data = await CategoryService.getCategories(
        widget.title == "Chi tiêu" ? "Chi" : "Thu");
    setState(() {
      categories = data;
    });
  }

  Future<IconData?> chooseIcon() async {
    return showDialog<IconData>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Chọn icon"),
          content: SizedBox(
            width: 300,
            height: 250,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemCount: availableIcons.length,
              itemBuilder: (context, index) {
                final iconName = availableIcons.keys.elementAt(index);
                final iconData = availableIcons.values.elementAt(index);
                return IconButton(
                  icon: Icon(iconData, size: 28),
                  onPressed: () => Navigator.pop(context, iconData),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _addParentCategory() async {
    TextEditingController controller = TextEditingController();
    IconData? selectedIcon;

    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Thêm ${widget.title}"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(hintText: "Nhập tên danh mục"),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                      onPressed: () async {
                        selectedIcon = await chooseIcon();
                      },
                      child: const Text("Chọn icon")),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
                ElevatedButton(
                    onPressed: () async {
                      if (controller.text.isNotEmpty && selectedIcon != null) {
                        // Lưu icon bằng codePoint + fontFamily
                        await CategoryService.addCategory(
                            controller.text.trim(),
                            widget.title == "Chi tiêu" ? "Chi" : "Thu",
                            '${selectedIcon!.codePoint}|${selectedIcon!.fontFamily}');
                        _loadCategories();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Thêm")),
              ],
            ));
  }

  IconData parseIcon(String stored) {
    // stored dạng "codePoint|fontFamily"
    try {
      final parts = stored.split('|');
      return IconData(int.parse(parts[0]), fontFamily: parts[1]);
    } catch (_) {
      return Icons.category; // fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh mục ${widget.title}"),
        backgroundColor: Colors.deepOrange,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addParentCategory,
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final parent = categories[index];
          final parentName = parent['name']?.toString() ?? '';
          final parentIcon = parent['icon']?.toString() ?? '0|MaterialIcons';

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ExpansionTile(
              leading: Icon(parseIcon(parentIcon), size: 28),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(parentName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {} // sửa category
                      ),
                      IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {} // xóa category
                      ),
                    ],
                  ),
                ],
              ),
              children: [
                ...((parent['children'] ?? []) as List).map((child) {
                  final childName = child['name']?.toString() ?? '';
                  final childIcon = child['icon']?.toString() ?? '0|MaterialIcons';
                  return ListTile(
                    leading: Icon(parseIcon(childIcon)),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(childName),
                        Row(
                          children: [
                            IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {}), // sửa child
                            IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {}), // xóa child
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
                TextButton.icon(
                    onPressed: () {}, // thêm child
                    icon: const Icon(Icons.add),
                    label: const Text("Thêm danh mục con")),
              ],
            ),
          );
        },
      ),
    );
  }
}
