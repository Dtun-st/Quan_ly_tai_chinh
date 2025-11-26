import 'package:flutter/material.dart';

class CategoryScreenUI extends StatelessWidget {
  const CategoryScreenUI({super.key});

  // Mock dữ liệu danh mục từ DB
  final List<Map<String, dynamic>> mockCategories = const [
    {
      'id': 1,
      'ten_danh_muc': 'Ăn uống',
      'loai': 'Chi',
      'icon': Icons.fastfood,
      'children': [
        {'id': 11, 'ten_danh_muc': 'Nhà hàng', 'loai': 'Chi', 'icon': Icons.local_dining},
        {'id': 12, 'ten_danh_muc': 'Cafe', 'loai': 'Chi', 'icon': Icons.local_cafe},
      ],
    },
    {
      'id': 2,
      'ten_danh_muc': 'Thu nhập',
      'loai': 'Thu',
      'icon': Icons.attach_money,
      'children': [
        {'id': 21, 'ten_danh_muc': 'Lương', 'loai': 'Thu', 'icon': Icons.money},
        {'id': 22, 'ten_danh_muc': 'Thưởng', 'loai': 'Thu', 'icon': Icons.card_giftcard},
      ],
    },
    {
      'id': 3,
      'ten_danh_muc': 'Giải trí',
      'loai': 'Chi',
      'icon': Icons.sports_basketball,
      'children': [],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh mục"),
        backgroundColor: Colors.deepOrange,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Thêm danh mục cha
        },
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: mockCategories.length,
        itemBuilder: (context, index) {
          final parent = mockCategories[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ExpansionTile(
              leading: Icon(parent['icon'], size: 28),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(parent['ten_danh_muc'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Row(
                    children: const [
                      Icon(Icons.edit, color: Colors.blue),
                      SizedBox(width: 8),
                      Icon(Icons.delete, color: Colors.red),
                    ],
                  ),
                ],
              ),
              children: [
                ...((parent['children'] ?? []) as List).map((child) {
                  return ListTile(
                    leading: Icon(child['icon']),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(child['ten_danh_muc']),
                        Row(
                          children: const [
                            Icon(Icons.edit, color: Colors.blue),
                            SizedBox(width: 8),
                            Icon(Icons.delete, color: Colors.red),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
                TextButton.icon(
                  onPressed: () {
                    // Thêm danh mục con
                  },
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
