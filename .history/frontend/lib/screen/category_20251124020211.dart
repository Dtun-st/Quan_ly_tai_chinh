import 'package:flutter/material.dart';
import '../services/category_service.dart';

class CategoryScreen extends StatefulWidget {
  final String title; 
  const CategoryScreen({super.key, required this.title});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Map<String, dynamic>> categories = [];

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
                    decoration:
                        const InputDecoration(hintText: "Nhập tên danh mục"),
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
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Hủy")),
                ElevatedButton(
                    onPressed: () async {
                      if (controller.text.isNotEmpty && selectedIcon != null) {
                        await CategoryService.addCategory(
                            controller.text.trim(),
                            widget.title == "Chi tiêu" ? "Chi" : "Thu",
                            selectedIcon!.codePoint.toString());
                        _loadCategories();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Thêm")),
              ],
            ));
  }

  void _addChildCategory(int parentId) async {
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
                      child: const Text("Chọn icon")),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Hủy")),
                ElevatedButton(
                    onPressed: () async {
                      if (controller.text.isNotEmpty && selectedIcon != null) {
                        await CategoryService.addChildCategory(
                            parentId,
                            controller.text.trim(),
                            selectedIcon!.codePoint.toString());
                        _loadCategories();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Thêm")),
              ],
            ));
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
          final parentIcon = parent['icon']?.toString() ?? '0';

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ExpansionTile(
              leading: Icon(
                  IconData(int.parse(parentIcon), fontFamily: 'MaterialIcons'),
                  size: 28),
              title: Text(parentName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              children: [
                ...((parent['children'] ?? []) as List)
                    .map((child) {
                  final childName = child['name']?.toString() ?? '';
                  final childIcon = child['icon']?.toString() ?? '0';
                  return ListTile(
                    leading: Icon(IconData(int.parse(childIcon),
                        fontFamily: 'MaterialIcons')),
                    title: Text(childName),
                  );
                }).toList(),
                TextButton.icon(
                  onPressed: () => _addChildCategory(parent['id']),
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
