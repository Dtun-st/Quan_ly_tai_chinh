// import 'package:flutter/material.dart';
// import '../services/history_service.dart';

// const Color primaryColor = Color(0xFFFF6D00);
// const Color textColor = Color(0xFF333333);
// class HistoryScreen extends StatefulWidget {
//   final Function(Map<String, dynamic>)? onEdit; // callback trả transaction
//   final VoidCallback? onUpdate; // callback sau khi xóa

//   const HistoryScreen({super.key, this.onEdit, this.onUpdate});

//   @override
//   State<HistoryScreen> createState() => _HistoryScreenState();
// }

// class _HistoryScreenState extends State<HistoryScreen> {
//   final HistoryService _service = HistoryService();
//   List<Map<String, dynamic>> giaoDich = [];
//   List<Map<String, dynamic>> filteredGiaoDich = [];
//   String filterType = "Tất cả";
//   bool _loading = true;
//   double totalAmount = 0;

//   @override
//   void initState() {
//     super.initState();
//     _loadHistory();
//   }

//   Future<void> _loadHistory() async {
//     setState(() => _loading = true);
//     final transactions = await _service.fetchHistory();
//     setState(() {
//       giaoDich = transactions;
//       filteredGiaoDich = transactions;
//       totalAmount = _calculateTotal(transactions);
//       _loading = false;
//     });
//   }

//   double _calculateTotal(List<Map<String, dynamic>> list) {
//     double sum = 0;
//     for (var g in list) {
//       double amount = double.tryParse(g['so_tien'].toString()) ?? 0;
//       if (g['loai_gd'] == "Thu") {
//         sum += amount;
//       } else {
//         sum -= amount;
//       }
//     }
//     return sum;
//   }

//   void _filterHistory(String type) {
//     setState(() {
//       filterType = type;
//       filteredGiaoDich = type == "Tất cả"
//           ? giaoDich
//           : giaoDich.where((g) => g['loai_gd'] == type).toList();
//     });
//   }

//   void _deleteHistory(dynamic id) async {
//     if (id == null) return;
//     final transactionId = int.tryParse(id.toString());
//     if (transactionId == null) return;

//     final result = await _service.deleteHistory(transactionId);
//     if (result != null) {
//       final deleted = result['transaction'];

//       setState(() {
//         giaoDich.removeWhere((g) => g['id'] == transactionId);
//         filteredGiaoDich.removeWhere((g) => g['id'] == transactionId);

//         double amount = double.tryParse(deleted['so_tien'].toString()) ?? 0;
//         if (deleted['loai_gd'] == "Thu") {
//           totalAmount -= amount;
//         } else {
//           totalAmount += amount;
//         }
//       });

//       if (widget.onUpdate != null) widget.onUpdate!();

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Xóa thành công và hoàn tiền về tài khoản"),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Xóa thất bại")));
//     }
//   }

//   String _formatCurrency(double amount) {
//     String str = amount.toStringAsFixed(0);
//     RegExp reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
//     return str.replaceAllMapped(reg, (Match match) => ',');
//   }

//   void _showEditDialog(Map<String, dynamic> transaction) {
//     final controller = TextEditingController(
//       text: transaction['so_tien'].toString(),
//     );
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Sửa giao dịch"),
//         content: TextField(
//           controller: controller,
//           keyboardType: TextInputType.number,
//           decoration: const InputDecoration(labelText: "Số tiền"),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Hủy"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               // 👇 Gọi callback trả transaction về màn hình cha
//               if (widget.onEdit != null) {
//                 widget.onEdit!(transaction);
//               }
//               Navigator.pop(context);
//             },
//             child: const Text("Sửa"),
//           ),
//         ],
//       ),
//     );
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
//                 Text("Tổng tiền: ${_formatCurrency(totalAmount)} VND"),
//                 const Divider(),
//                 Expanded(
//                   child: filteredGiaoDich.isEmpty
//                       ? const Center(child: Text("Không có giao dịch"))
//                       : ListView.separated(
//                           itemCount: filteredGiaoDich.length,
//                           separatorBuilder: (context, index) =>
//                               const Divider(height: 1),
//                           itemBuilder: (context, index) {
//                             final gd = filteredGiaoDich[index];
//                             final isThu = gd['loai_gd'] == "Thu";
//                             final color = isThu
//                                 ? Colors.green.shade600
//                                 : Colors.red.shade600;

//                             return ListTile(
//                               leading: CircleAvatar(
//                                 backgroundColor: color.withOpacity(0.1),
//                                 child: Icon(
//                                   isThu
//                                       ? Icons.trending_up
//                                       : Icons.trending_down,
//                                   color: color,
//                                 ),
//                               ),
//                               title: Text("${gd['mo_ta'] ?? 'Chưa có mô tả'}"),
//                               subtitle: Text("${gd['ngay_giao_dich']}"),
//                               trailing: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Text(
//                                     "${isThu ? '+' : '-'}${_formatCurrency(double.tryParse(gd['so_tien'].toString()) ?? 0)} VND",
//                                     style: TextStyle(
//                                       color: color,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   GestureDetector(
//                                     onTap: () => _showEditDialog(gd),
//                                     child: Icon(
//                                       Icons.edit,
//                                       color: Colors.blue.shade600,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   GestureDetector(
//                                     onTap: () => _deleteHistory(gd['id']),
//                                     child: Icon(
//                                       Icons.delete,
//                                       color: Colors.red.shade600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
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
//       onPressed: () => _filterHistory(label),
//       child: Text(label),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../services/history_service.dart';
import 'transaction.dart';

const Color primaryColor = Color(0xFFFF6D00);
const Color textColor = Color(0xFF333333);

class HistoryScreen extends StatefulWidget {
  final VoidCallback? onUpdate;

  const HistoryScreen({super.key, this.onUpdate});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryService _service = HistoryService();
  List<Map<String, dynamic>> giaoDich = [];
  List<Map<String, dynamic>> filteredGiaoDich = [];
  String filterType = "Tất cả";
  bool _loading = true;
  double totalAmount = 0;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _loading = true);
    final transactions = await _service.fetchHistory();
    setState(() {
      giaoDich = transactions;
      filteredGiaoDich = transactions;
      totalAmount = _calculateTotal(transactions);
      _loading = false;
    });
  }

  double _calculateTotal(List<Map<String, dynamic>> list) {
    double sum = 0;
    for (var g in list) {
      double amount = double.tryParse(g['so_tien'].toString()) ?? 0;
      if (g['loai_gd'] == "Thu") {
        sum += amount;
      } else {
        sum -= amount;
      }
    }
    return sum;
  }

  void _filterHistory(String type) {
    setState(() {
      filterType = type;
      filteredGiaoDich = type == "Tất cả"
          ? giaoDich
          : giaoDich.where((g) => g['loai_gd'] == type).toList();
    });
  }

  void _deleteHistory(dynamic id) async {
    if (id == null) return;
    final transactionId = int.tryParse(id.toString());
    if (transactionId == null) return;

    final result = await _service.deleteHistory(transactionId);
    if (result != null) {
      final deleted = result['transaction'];

      setState(() {
        giaoDich.removeWhere((g) => g['id'] == transactionId);
        filteredGiaoDich.removeWhere((g) => g['id'] == transactionId);

        double amount = double.tryParse(deleted['so_tien'].toString()) ?? 0;
        if (deleted['loai_gd'] == "Thu") {
          totalAmount -= amount;
        } else {
          totalAmount += amount;
        }
      });

      if (widget.onUpdate != null) widget.onUpdate!();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Xóa thành công và hoàn tiền về tài khoản"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Xóa thất bại")));
    }
  }

  void _editTransaction(Map<String, dynamic> transaction) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TransactionScreen(transaction: transaction),
      ),
    );

    if (updated == true) {
      _loadHistory();
    }
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
                Text("Tổng tiền: ${_formatCurrency(totalAmount)} VND"),
                const Divider(),
                Expanded(
                  child: filteredGiaoDich.isEmpty
                      ? const Center(child: Text("Không có giao dịch"))
                      : ListView.separated(
                          itemCount: filteredGiaoDich.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final gd = filteredGiaoDich[index];
                            final isThu = gd['loai_gd'] == "Thu";
                            final color = isThu
                                ? Colors.green.shade600
                                : Colors.red.shade600;

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: color.withOpacity(0.1),
                                child: Icon(
                                  isThu
                                      ? Icons.trending_up
                                      : Icons.trending_down,
                                  color: color,
                                ),
                              ),
                              title: Text("${gd['mo_ta'] ?? 'Chưa có mô tả'}"),
                              subtitle: Text("${gd['ngay_giao_dich']}"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${isThu ? '+' : '-'}${_formatCurrency(double.tryParse(gd['so_tien'].toString()) ?? 0)} VND",
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => _editTransaction(gd),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.blue.shade600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => _deleteHistory(gd['id']),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red.shade600,
                                    ),
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
      onPressed: () => _filterHistory(label),
      child: Text(label),
    );
  }
}
