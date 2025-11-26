// import 'package:flutter/material.dart';
// import '../services/home_service.dart';

// const Color primaryColor = Color(0xFFFF6D00);
// const Color textColor = Color(0xFF333333);

// class AllTransactionsScreen extends StatefulWidget {
//   const AllTransactionsScreen({super.key});

//   @override
//   State<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
// }

// class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
//   List<Map<String, dynamic>> giaoDich = [];
//   List<Map<String, dynamic>> filteredGiaoDich = [];
//   String filterType = "Tất cả"; // "Thu", "Chi"

//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadTransactions();
//   }

//   Future<void> _loadTransactions() async {
//     // Giả sử userId lấy từ HomeService hoặc SharedPreferences
//     int userId = 1; // Thay bằng userId thực tế
//     final service = HomeService();
//     final transactions = await service.fetchGiaoDich(userId);

//     setState(() {
//       giaoDich = transactions;
//       filteredGiaoDich = transactions;
//       _loading = false;
//     });
//   }

//   void _filterTransactions(String type) {
//     setState(() {
//       filterType = type;
//       if (type == "Tất cả") {
//         filteredGiaoDich = giaoDich;
//       } else {
//         filteredGiaoDich = giaoDich.where((g) => g['loai'] == type).toList();
//       }
//     });
//   }

//   String _formatCurrency(double amount) {
//     String str = amount.toStringAsFixed(0);
//     RegExp reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
//     return str.replaceAllMapped(reg, (Match match) => ',');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Lịch sử giao dịch"),
//         backgroundColor: primaryColor,
//       ),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 // ---------------- Filter ----------------
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       _filterButton("Tất cả"),
//                       _filterButton("Thu"),
//                       _filterButton("Chi"),
//                     ],
//                   ),
//                 ),
//                 const Divider(),
//                 // ---------------- List ----------------
//                 Expanded(
//                   child: ListView.separated(
//                     itemCount: filteredGiaoDich.length,
//                     separatorBuilder: (context, index) => const Divider(height: 1),
//                     itemBuilder: (context, index) {
//                       final gd = filteredGiaoDich[index];
//                       final isThu = gd['loai'] == "Thu";
//                       final color = isThu ? Colors.green.shade600 : Colors.red.shade600;

//                       return ListTile(
//                         leading: CircleAvatar(
//                           backgroundColor: color.withOpacity(0.1),
//                           child: Icon(isThu ? Icons.trending_up : Icons.trending_down, color: color),
//                         ),
//                         title: Text("${gd['han_muc']}"),
//                         subtitle: Text("${gd['ngay']}"),
//                         trailing: Text(
//                           "${isThu ? '+' : '-'}${_formatCurrency(double.tryParse(gd['so_tien'].toString()) ?? 0)} VND",
//                           style: TextStyle(color: color, fontWeight: FontWeight.bold),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   Widget _filterButton(String label) {
//     final isSelected = filterType == label;
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: isSelected ? primaryColor : Colors.grey.shade300,
//         foregroundColor: isSelected ? Colors.white : textColor,
//       ),
//       onPressed: () => _filterTransactions(label),
//       child: Text(label),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/home_service.dart';

const Color primaryColor = Color(0xFFFF6D00);
const Color textColor = Color(0xFF333333);

class AllTransactionsScreen extends StatefulWidget {
  const AllTransactionsScreen({super.key});

  @override
  State<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  List<Map<String, dynamic>> giaoDich = [];
  List<Map<String, dynamic>> filteredGiaoDich = [];
  String filterType = "Tất cả"; // "Thu", "Chi"
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() => _loading = true);
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');

    if (userId != null) {
      final service = HomeService();
      final transactions = await service.fetchGiaoDich(userId);

      setState(() {
        giaoDich = transactions;
        filteredGiaoDich = transactions;
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  void _filterTransactions(String type) {
    setState(() {
      filterType = type;
      if (type == "Tất cả") {
        filteredGiaoDich = giaoDich;
      } else {
        filteredGiaoDich = giaoDich.where((g) => g['loai'] == type).toList();
      }
    });
  }

  void _deleteTransaction(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận xóa"),
        content: const Text("Bạn có chắc muốn xóa giao dịch này?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                giaoDich.removeWhere((g) => g['id'] == id);
                filteredGiaoDich.removeWhere((g) => g['id'] == id);
              });
              Navigator.pop(context);
            },
            child: const Text("Xóa"),
          ),
        ],
      ),
    );
  }

  void _editTransaction(Map<String, dynamic> transaction) {
    final controller = TextEditingController(text: transaction['so_tien'].toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sửa giao dịch"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Số tiền"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                transaction['so_tien'] = double.tryParse(controller.text) ?? transaction['so_tien'];
              });
              Navigator.pop(context);
            },
            child: const Text("Lưu"),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    String str = amount.toStringAsFixed(0);
    RegExp reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (Match match) => ',');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch sử giao dịch"),
        backgroundColor: primaryColor,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ---------------- Filter ----------------
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _filterButton("Tất cả"),
                      _filterButton("Thu"),
                      _filterButton("Chi"),
                    ],
                  ),
                ),
                const Divider(),
                // ---------------- List ----------------
                Expanded(
                  child: filteredGiaoDich.isEmpty
                      ? const Center(child: Text("Không có giao dịch"))
                      : ListView.separated(
                          itemCount: filteredGiaoDich.length,
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final gd = filteredGiaoDich[index];
                            final isThu = gd['loai'] == "Thu";
                            final color = isThu ? Colors.green.shade600 : Colors.red.shade600;

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: color.withOpacity(0.1),
                                child: Icon(isThu ? Icons.trending_up : Icons.trending_down, color: color),
                              ),
                              title: Text("${gd['han_muc']}"),
                              subtitle: Text("${gd['ngay']}"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${isThu ? '+' : '-'}${_formatCurrency(double.tryParse(gd['so_tien'].toString()) ?? 0)} VND",
                                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => _editTransaction(gd),
                                    child: Icon(Icons.edit, color: Colors.blue.shade600),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => _deleteTransaction(gd['id']),
                                    child: Icon(Icons.delete, color: Colors.red.shade600),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _filterButton(String label) {
    final isSelected = filterType == label;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? primaryColor : Colors.grey.shade300,
        foregroundColor: isSelected ? Colors.white : textColor,
      ),
      onPressed: () => _filterTransactions(label),
      child: Text(label),
    );
  }
}
