// // import 'package:flutter/material.dart';

// // class CategoryScreen extends StatefulWidget {
// //   final String title;     // Chi tiêu hoặc Thu nhập
// //   const CategoryScreen({super.key, required this.title});

// //   @override
// //   State<CategoryScreen> createState() => _CategoryScreenState();
// // }

// // class _CategoryScreenState extends State<CategoryScreen> {
// //   List<Map<String, dynamic>> categories = [
// //     {
// //       'name': 'Ăn uống',
// //       'icon': Icons.fastfood,
// //       'children': [
// //         {'name': 'Cơm', 'icon': Icons.rice_bowl},
// //         {'name': 'Trà sữa', 'icon': Icons.local_drink},
// //       ]
// //     },
// //     {
// //       'name': 'Mua sắm',
// //       'icon': Icons.shopping_bag,
// //       'children': [
// //         {'name': 'Quần áo', 'icon': Icons.checkroom},
// //         {'name': 'Đồ điện tử', 'icon': Icons.devices},
// //       ]
// //     },
// //   ];

// //   final List<IconData> availableIcons = [
// //     Icons.fastfood,
// //     Icons.shopping_bag,
// //     Icons.home,
// //     Icons.lightbulb,
// //     Icons.directions_car,
// //     Icons.pets,
// //     Icons.sports_basketball,
// //     Icons.school,
// //     Icons.favorite,
// //     Icons.savings,
// //     Icons.attach_money,
// //     Icons.card_giftcard,
// //     Icons.local_drink,
// //     Icons.devices,
// //     Icons.checkroom,
// //     Icons.rice_bowl,
// //   ];

// //   Future<IconData?> chooseIcon() async {
// //     return showDialog<IconData>(
// //       context: context,
// //       builder: (context) {
// //         return AlertDialog(
// //           title: const Text("Chọn icon"),
// //           content: SizedBox(
// //             width: 300,
// //             height: 250,
// //             child: GridView.builder(
// //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //                 crossAxisCount: 4,
// //                 crossAxisSpacing: 10,
// //                 mainAxisSpacing: 10,
// //               ),
// //               itemCount: availableIcons.length,
// //               itemBuilder: (context, index) {
// //                 return IconButton(
// //                   icon: Icon(availableIcons[index], size: 28),
// //                   onPressed: () =>
// //                       Navigator.pop(context, availableIcons[index]),
// //                 );
// //               },
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   // ==========================
// //   //     THÊM DANH MỤC MẸ
// //   // ==========================
// //   void _addParentCategory() async {
// //     TextEditingController controller = TextEditingController();
// //     IconData? selectedIcon;

// //     await showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: Text("Thêm ${widget.title}"),
// //         content: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             TextField(
// //               controller: controller,
// //               decoration: const InputDecoration(hintText: "Nhập tên danh mục"),
// //             ),
// //             const SizedBox(height: 12),
// //             ElevatedButton(
// //               onPressed: () async {
// //                 selectedIcon = await chooseIcon();
// //               },
// //               child: const Text("Chọn icon"),
// //             )
// //           ],
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text("Hủy"),
// //           ),
// //           ElevatedButton(
// //             onPressed: () {
// //               if (controller.text.isNotEmpty && selectedIcon != null) {
// //                 setState(() {
// //                   categories.add({
// //                     'name': controller.text.trim(),
// //                     'icon': selectedIcon,
// //                     'children': []
// //                   });
// //                 });
// //               }
// //               Navigator.pop(context);
// //             },
// //             child: const Text("Thêm"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // ==========================
// //   //   THÊM DANH MỤC CON
// //   // ==========================
// //   void _addChildCategory(int parentIndex) async {
// //     TextEditingController controller = TextEditingController();
// //     IconData? selectedIcon;

// //     await showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: Text("Thêm danh mục con"),
// //         content: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             TextField(
// //               controller: controller,
// //               decoration: const InputDecoration(hintText: "Nhập tên danh mục con"),
// //             ),
// //             const SizedBox(height: 12),
// //             ElevatedButton(
// //               onPressed: () async {
// //                 selectedIcon = await chooseIcon();
// //               },
// //               child: const Text("Chọn icon"),
// //             )
// //           ],
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text("Hủy"),
// //           ),
// //           ElevatedButton(
// //             onPressed: () {
// //               if (controller.text.isNotEmpty && selectedIcon != null) {
// //                 setState(() {
// //                   categories[parentIndex]['children'].add({
// //                     'name': controller.text.trim(),
// //                     'icon': selectedIcon
// //                   });
// //                 });
// //               }
// //               Navigator.pop(context);
// //             },
// //             child: const Text("Thêm"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Danh mục ${widget.title}"),
// //         backgroundColor: Colors.deepOrange,
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: _addParentCategory,
// //         backgroundColor: Colors.deepOrange,
// //         child: const Icon(Icons.add),
// //       ),
// //       body: ListView.builder(
// //         itemCount: categories.length,
// //         itemBuilder: (context, parentIndex) {
// //           final parent = categories[parentIndex];

// //           return Card(
// //             margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //             child: ExpansionTile(
// //               leading: Icon(parent['icon'], size: 28),
// //               title: Text(
// //                 parent['name'],
// //                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //               ),
// //               children: [
// //                 ...parent['children'].map<Widget>((child) {
// //                   return ListTile(
// //                     leading: Icon(child['icon']),
// //                     title: Text(child['name']),
// //                   );
// //                 }).toList(),
// //                 TextButton.icon(
// //                   onPressed: () => _addChildCategory(parentIndex),
// //                   icon: const Icon(Icons.add),
// //                   label: const Text("Thêm danh mục con"),
// //                 ),
// //               ],
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';

// class CategoryScreen extends StatefulWidget {
//   final String title; // "Chi tiêu" hoặc "Thu nhập"
//   const CategoryScreen({super.key, required this.title});

//   @override
//   State<CategoryScreen> createState() => _CategoryScreenState();
// }

// class _CategoryScreenState extends State<CategoryScreen> {
//   // ================================
//   //   DỮ LIỆU CHI TIÊU
//   // ================================
//   final List<Map<String, dynamic>> defaultChiTieu = [
//     {
//       'name': 'Ăn uống',
//       'icon': Icons.fastfood,
//       'children': [
//         {'name': 'Cơm', 'icon': Icons.rice_bowl},
//         {'name': 'Trà sữa', 'icon': Icons.local_drink},
//       ]
//     },
//     {
//       'name': 'Mua sắm',
//       'icon': Icons.shopping_bag,
//       'children': [
//         {'name': 'Quần áo', 'icon': Icons.checkroom},
//         {'name': 'Đồ điện tử', 'icon': Icons.devices},
//       ]
//     },
//   ];

//   // ================================
//   //      DỮ LIỆU THU NHẬP
//   // ================================
//   final List<Map<String, dynamic>> defaultThuNhap = [
//     {
//       'name': 'Lương',
//       'icon': Icons.monetization_on,
//       'children': [
//         {'name': 'Lương tháng', 'icon': Icons.wallet},
//         {'name': 'Thưởng', 'icon': Icons.card_giftcard},
//       ],
//     },
//     {
//       'name': 'Thu nhập phụ',
//       'icon': Icons.attach_money,
//       'children': [
//         {'name': 'Bán hàng', 'icon': Icons.shopping_cart},
//         {'name': 'Cho thuê', 'icon': Icons.home_work},
//       ]
//     }
//   ];

//   late List<Map<String, dynamic>> categories; // DANH MỤC ĐANG HIỂN THỊ

//   // ================================
//   //      DANH SÁCH ICON CHỌN
//   // ================================
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

//     // CHỌN DỮ LIỆU TƯƠNG ỨNG
//     if (widget.title == "Chi tiêu") {
//       categories = List.from(defaultChiTieu); // copy để không ảnh hưởng dữ liệu gốc
//     } else {
//       categories = List.from(defaultThuNhap);
//     }
//   }

//   // ================================
//   //      MÀN HÌNH CHỌN ICON
//   // ================================
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
//                 crossAxisCount: 4,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//               ),
//               itemCount: availableIcons.length,
//               itemBuilder: (context, index) {
//                 return IconButton(
//                   icon: Icon(availableIcons[index], size: 28),
//                   onPressed: () =>
//                       Navigator.pop(context, availableIcons[index]),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // ==========================
//   //     THÊM DANH MỤC MẸ
//   // ==========================
//   void _addParentCategory() async {
//     TextEditingController controller = TextEditingController();
//     IconData? selectedIcon;

//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Thêm ${widget.title}"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: controller,
//               decoration: const InputDecoration(hintText: "Nhập tên danh mục"),
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: () async {
//                 selectedIcon = await chooseIcon();
//               },
//               child: const Text("Chọn icon"),
//             )
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Hủy"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (controller.text.isNotEmpty && selectedIcon != null) {
//                 setState(() {
//                   categories.add({
//                     'name': controller.text.trim(),
//                     'icon': selectedIcon,
//                     'children': []
//                   });
//                 });
//               }
//               Navigator.pop(context);
//             },
//             child: const Text("Thêm"),
//           ),
//         ],
//       ),
//     );
//   }

//   // ==========================
//   //   THÊM DANH MỤC CON
//   // ==========================
//   void _addChildCategory(int parentIndex) async {
//     TextEditingController controller = TextEditingController();
//     IconData? selectedIcon;

//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Thêm danh mục con"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: controller,
//               decoration:
//                   const InputDecoration(hintText: "Nhập tên danh mục con"),
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: () async {
//                 selectedIcon = await chooseIcon();
//               },
//               child: const Text("Chọn icon"),
//             )
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Hủy"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (controller.text.isNotEmpty && selectedIcon != null) {
//                 setState(() {
//                   categories[parentIndex]['children'].add({
//                     'name': controller.text.trim(),
//                     'icon': selectedIcon
//                   });
//                 });
//               }
//               Navigator.pop(context);
//             },
//             child: const Text("Thêm"),
//           ),
//         ],
//       ),
//     );
//   }

//   // ==========================
//   //           UI
//   // ==========================
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
//         itemBuilder: (context, parentIndex) {
//           final parent = categories[parentIndex];

//           return Card(
//             margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             child: ExpansionTile(
//               leading: Icon(parent['icon'], size: 28),
//               title: Text(
//                 parent['name'],
//                 style: const TextStyle(
//                     fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               children: [
//                 ...parent['children'].map<Widget>((child) {
//                   return ListTile(
//                     leading: Icon(child['icon']),
//                     title: Text(child['name']),
//                   );
//                 }).toList(),
//                 TextButton.icon(
//                   onPressed: () => _addChildCategory(parentIndex),
//                   icon: const Icon(Icons.add),
//                   label: const Text("Thêm danh mục con"),
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

class CategoryScreen extends StatefulWidget {
  final String title; // "Chi tiêu" hoặc "Thu nhập"
  const CategoryScreen({super.key, required this.title});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // ================================
  //   DỮ LIỆU CHI TIÊU
  // ================================
  final List<Map<String, dynamic>> defaultChiTieu = [
    {
      'name': 'Ăn uống',
      'icon': Icons.fastfood,
      'children': [
        {'name': 'Cơm', 'icon': Icons.rice_bowl},
        {'name': 'Trà sữa', 'icon': Icons.local_drink},
      ]
    },
    {
      'name': 'Mua sắm',
      'icon': Icons.shopping_bag,
      'children': [
        {'name': 'Quần áo', 'icon': Icons.checkroom},
        {'name': 'Đồ điện tử', 'icon': Icons.devices},
      ]
    },
  ];

  // ================================
  //      DỮ LIỆU THU NHẬP
  // ================================
  final List<Map<String, dynamic>> defaultThuNhap = [
    {
      'name': 'Lương',
      'icon': Icons.monetization_on,
      'children': [
        {'name': 'Lương tháng', 'icon': Icons.wallet},
        {'name': 'Thưởng', 'icon': Icons.card_giftcard},
      ],
    },
    {
      'name': 'Thu nhập phụ',
      'icon': Icons.attach_money,
      'children': [
        {'name': 'Bán hàng', 'icon': Icons.shopping_cart},
        {'name': 'Cho thuê', 'icon': Icons.home_work},
      ]
    }
  ];

  late List<Map<String, dynamic>> categories; // DANH MỤC ĐANG HIỂN THỊ

  // ================================
  //      DANH SÁCH ICON CHỌN
  // ================================
  final List<IconData> availableIcons = [
    Icons.fastfood,
    Icons.shopping_bag,
    Icons.home,
    Icons.lightbulb,
    Icons.directions_car,
    Icons.pets,
    Icons.sports_basketball,
    Icons.school,
    Icons.favorite,
    Icons.savings,
    Icons.attach_money,
    Icons.card_giftcard,
    Icons.local_drink,
    Icons.devices,
    Icons.checkroom,
    Icons.rice_bowl,
    Icons.shopping_cart,
    Icons.wallet,
    Icons.home_work,
    Icons.monetization_on,
  ];

  @override
  void initState() {
    super.initState();

    // CHỌN DỮ LIỆU TƯƠNG ỨNG
    if (widget.title == "Chi tiêu") {
      categories = List.from(defaultChiTieu); // copy để không ảnh hưởng dữ liệu gốc
    } else {
      categories = List.from(defaultThuNhap);
    }
  }

  // ================================
  //      MÀN HÌNH CHỌN ICON
  // ================================
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
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: availableIcons.length,
              itemBuilder: (context, index) {
                return IconButton(
                  icon: Icon(availableIcons[index], size: 28),
                  onPressed: () => Navigator.pop(context, availableIcons[index]),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // ==========================
  //     THÊM DANH MỤC MẸ
  // ==========================
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
              child: const Text("Chọn icon"),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty && selectedIcon != null) {
                setState(() {
                  categories.add({
                    'name': controller.text.trim(),
                    'icon': selectedIcon,
                    'children': []
                  });
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Thêm"),
          ),
        ],
      ),
    );
  }

  // ==========================
  //   THÊM DANH MỤC CON
  // ==========================
  void _addChildCategory(int parentIndex) async {
    TextEditingController controller = TextEditingController();
    IconData? selectedIcon;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Thêm danh mục con"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration:
                  const InputDecoration(hintText: "Nhập tên danh mục con"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                selectedIcon = await chooseIcon();
              },
              child: const Text("Chọn icon"),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty && selectedIcon != null) {
                setState(() {
                  categories[parentIndex]['children'].add({
                    'name': controller.text.trim(),
                    'icon': selectedIcon
                  });
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Thêm"),
          ),
        ],
      ),
    );
  }

  // ==========================
  //           UI
  // ==========================
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
        itemBuilder: (context, parentIndex) {
          final parent = categories[parentIndex];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ExpansionTile(
              leading: Icon(parent['icon'], size: 28),
              title: Text(
                parent['name'],
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              children: [
                ...parent['children'].map<Widget>((child) {
                  return ListTile(
                    leading: Icon(child['icon']),
                    title: Text(child['name']),
                    onTap: () {
                      // Trả về tên danh mục con về TransactionScreen
                      Navigator.pop(context, child['name']);
                    },
                  );
                }).toList(),
                TextButton.icon(
                  onPressed: () => _addChildCategory(parentIndex),
                  icon: const Icon(Icons.add),
                  label: const Text("Thêm danh mục con"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
