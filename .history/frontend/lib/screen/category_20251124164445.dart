// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import '../services/category_service.dart';

// class CategoryScreen extends StatefulWidget {
//   final String title;
//   const CategoryScreen({super.key, required this.title});

//   @override
//   State<CategoryScreen> createState() => _CategoryScreenState();
// }

// class _CategoryScreenState extends State<CategoryScreen> {
//   List<Map<String, dynamic>> categories = [];

//   // Map key string -> IconData, hỗ trợ Material + FontAwesome
//   final Map<String, IconData> iconMap = {
//     // Material Icons
//     'fastfood': Icons.fastfood,
//     'shopping_bag': Icons.shopping_bag,
//     'home': Icons.home,
//     'lightbulb': Icons.lightbulb,
//     'car': Icons.directions_car,
//     'pets': Icons.pets,
//     'basketball': Icons.sports_basketball,
//     'school': Icons.school,
//     'favorite': Icons.favorite,
//     'savings': Icons.savings,
//     'money': Icons.attach_money,
//     'gift': Icons.card_giftcard,
//     'drink': Icons.local_drink,
//     'devices': Icons.devices,
//     'clothes': Icons.checkroom,
//     'rice': Icons.rice_bowl,
//     'cart': Icons.shopping_cart,
//     'wallet': Icons.wallet,
//     'home_work': Icons.home_work,
//     'monetization': Icons.monetization_on,
//     // FontAwesome Icons
//     'fa-utensils': FontAwesomeIcons.utensils,
//     'fa-shopping-bag': FontAwesomeIcons.shoppingBag,
//     'fa-home': FontAwesomeIcons.home,
//     'fa-car': FontAwesomeIcons.car,
//     'fa-film': FontAwesomeIcons.film,
//     'fa-book': FontAwesomeIcons.book,
//     'fa-money-bill-wave': FontAwesomeIcons.moneyBillWave,
//     'fa-coffee': FontAwesomeIcons.coffee,
//     'fa-bread-slice': FontAwesomeIcons.breadSlice,
//     'fa-hamburger': FontAwesomeIcons.hamburger,
//     'fa-pizza-slice': FontAwesomeIcons.pizzaSlice,
//     'fa-wine-glass': FontAwesomeIcons.wineGlass,
//     'fa-tshirt': FontAwesomeIcons.tshirt,
//     'fa-shoe-prints': FontAwesomeIcons.shoePrints,
//     'fa-mobile-alt': FontAwesomeIcons.mobileAlt,
//     'fa-bolt': FontAwesomeIcons.bolt,
//     'fa-wifi': FontAwesomeIcons.wifi,
//     'fa-gas-pump': FontAwesomeIcons.gasPump,
//     'fa-tools': FontAwesomeIcons.tools,
//     'fa-plane': FontAwesomeIcons.plane,
//     'fa-user-doctor': FontAwesomeIcons.userDoctor,
//     'fa-pills': FontAwesomeIcons.pills,
//     'fa-pencil-alt': FontAwesomeIcons.pen,
//     'fa-gift': FontAwesomeIcons.gift,
//   };

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

//   IconData getIcon(String key) {
//     return iconMap[key] ?? Icons.category;
//   }

//   Future<String?> chooseIcon() async {
//     return showDialog<String>(
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
//               itemCount: iconMap.length,
//               itemBuilder: (context, index) {
//                 final key = iconMap.keys.elementAt(index);
//                 final iconData = iconMap.values.elementAt(index);
//                 return IconButton(
//                   icon: Icon(iconData, size: 28),
//                   onPressed: () => Navigator.pop(context, key),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _addCategory({int? parentId}) async {
//     TextEditingController controller = TextEditingController();
//     String? selectedIcon;

//     await showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//               title: Text(parentId == null
//                   ? "Thêm ${widget.title}"
//                   : "Thêm danh mục con"),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     controller: controller,
//                     decoration:
//                         const InputDecoration(hintText: "Nhập tên danh mục"),
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
//                 TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text("Hủy")),
//                 ElevatedButton(
//                     onPressed: () async {
//                       if (controller.text.isNotEmpty && selectedIcon != null) {
//                         if (parentId == null) {
//                           await CategoryService.addCategory(
//                               controller.text.trim(),
//                               widget.title == "Chi tiêu" ? "Chi" : "Thu",
//                               selectedIcon!);
//                         } else {
//                           await CategoryService.addChildCategory(
//                               parentId, controller.text.trim(), selectedIcon!);
//                         }
//                         _loadCategories();
//                         Navigator.pop(context);
//                       }
//                     },
//                     child: const Text("Thêm")),
//               ],
//             ));
//   }

//   void _editCategory(int id, String currentName, String currentIcon) async {
//     TextEditingController controller = TextEditingController(text: currentName);
//     String selectedIcon = currentIcon;

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
//                         final icon = await chooseIcon();
//                         if (icon != null) selectedIcon = icon;
//                       },
//                       child: const Text("Chọn icon")),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text("Hủy")),
//                 ElevatedButton(
//                     onPressed: () async {
//                       if (controller.text.isNotEmpty && selectedIcon.isNotEmpty) {
//                         await CategoryService.updateCategory(
//                             id, controller.text.trim(), selectedIcon);
//                         _loadCategories();
//                         Navigator.pop(context);
//                       }
//                     },
//                     child: const Text("Lưu")),
//               ],
//             ));
//   }

//   void _deleteCategory(int id) async {
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
//         onPressed: () => _addCategory(),
//         backgroundColor: Colors.deepOrange,
//         child: const Icon(Icons.add),
//       ),
//       body: ListView.builder(
//         itemCount: categories.length,
//         itemBuilder: (context, index) {
//           final parent = categories[index];
//           final parentName = parent['name'] ?? '';
//           final parentIcon = parent['icon'] ?? '';

//           return Card(
//             margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             child: ExpansionTile(
//               leading: Icon(getIcon(parentIcon), size: 28),
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(parentName,
//                       style: const TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.bold)),
//                   Row(
//                     children: [
//                       IconButton(
//                           icon: const Icon(Icons.edit, color: Colors.blue),
//                           onPressed: () =>
//                               _editCategory(parent['id'], parentName, parentIcon)),
//                       IconButton(
//                           icon: const Icon(Icons.delete, color: Colors.red),
//                           onPressed: () => _deleteCategory(parent['id'])),
//                     ],
//                   ),
//                 ],
//               ),
//               children: [
//                 ...((parent['children'] ?? []) as List).map((child) {
//                   final childName = child['name'] ?? '';
//                   final childIcon = child['icon'] ?? '';
//                   return ListTile(
//                     leading: Icon(getIcon(childIcon)),
//                     title: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(childName),
//                         Row(
//                           children: [
//                             IconButton(
//                                 icon: const Icon(Icons.edit, color: Colors.blue),
//                                 onPressed: () => _editCategory(
//                                     child['id'], childName, childIcon)),
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
//                     onPressed: () => _addCategory(parentId: parent['id']),
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

class CategoryScreenUI extends StatelessWidget {
  CategoryScreenUI({super.key});

  // Dữ liệu mẫu để hiển thị giao diện
  final List<Map<String, dynamic>> chiCategories = const [
    {
      'name': 'Ăn uống',
      'icon': 'fa-utensils',
      'children': [
        {'name': 'Nhà hàng', 'icon': 'fa-hamburger'},
        {'name': 'Cà phê', 'icon': 'fa-coffee'},
      ],
    },
    {
      'name': 'Đi lại',
      'icon': 'fa-car',
      'children': [
        {'name': 'Xăng xe', 'icon': 'fa-gas-pump'},
        {'name': 'Taxi', 'icon': 'fa-car'},
      ],
    },
  ];

  final List<Map<String, dynamic>> thuCategories = const [
    {
      'name': 'Lương',
      'icon': 'fa-money-bill-wave',
      'children': [],
    },
    {
      'name': 'Quà tặng',
      'icon': 'fa-gift',
      'children': [],
    },
  ];

  final Map<String, IconData> iconMap = {
    'fa-utensils': FontAwesomeIcons.utensils,
    'fa-hamburger': FontAwesomeIcons.hamburger,
    'fa-coffee': FontAwesomeIcons.coffee,
    'fa-car': FontAwesomeIcons.car,
    'fa-gas-pump': FontAwesomeIcons.gasPump,
    'fa-money-bill-wave': FontAwesomeIcons.moneyBillWave,
    'fa-gift': FontAwesomeIcons.gift,
  };

  IconData getIcon(String key) => iconMap[key] ?? Icons.category;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Danh mục'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Chi tiêu', icon: Icon(Icons.arrow_upward)),
              Tab(text: 'Thu nhập', icon: Icon(Icons.arrow_downward)),
            ],
          ),
          backgroundColor: Colors.deepOrange,
        ),
        body: TabBarView(
          children: [
            _buildCategoryList(chiCategories, Colors.redAccent),
            _buildCategoryList(thuCategories, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList(List<Map<String, dynamic>> categories, Color color) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final parent = categories[index];
        final parentName = parent['name'];
        final parentIcon = parent['icon'];
        final children = parent['children'] as List;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          elevation: 2,
          child: ExpansionTile(
            leading: Icon(getIcon(parentIcon), size: 28, color: color),
            title: Text(
              parentName,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
            children: children.map<Widget>((child) {
              final childName = child['name'];
              final childIcon = child['icon'];
              return ListTile(
                leading: Icon(getIcon(childIcon), color: color),
                title: Text(childName),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
