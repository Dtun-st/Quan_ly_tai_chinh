import 'dart:io';
import 'dart:typed_data';

class TransactionService {
  // ===== MOCK DATA =====
  static List<Map<String, dynamic>> _mockAccounts = [
    {"id": 1, "name": "Tiền mặt", "icon": 0xe227}, // Icon codePoint
    {"id": 2, "name": "Thẻ tín dụng", "icon": 0xe870},
    {"id": 3, "name": "Ngân hàng", "icon": 0xe870},
  ];

  static List<Map<String, dynamic>> _mockChiCategories = [
    {
      "name": "Ăn uống",
      "icon": 0xe56c,
      "children": [
        {"name": "Nhà hàng", "icon": 0xe56c},
        {"name": "Cà phê", "icon": 0xe56c},
        {"name": "Ăn vặt", "icon": 0xe56c},
      ],
    },
    {
      "name": "Dịch vụ sinh hoạt",
      "icon": 0xe56c,
      "children": [
        {"name": "Điện", "icon": 0xe56c},
        {"name": "Nước", "icon": 0xe56c},
        {"name": "Internet", "icon": 0xe56c},
      ],
    },
  ];

  static List<Map<String, dynamic>> _mockThuCategories = [
    {"name": "Lương", "icon": 0xe227},
    {"name": "Thưởng", "icon": 0xe227},
    {"name": "Được biếu", "icon": 0xe227},
    {"name": "Lãi", "icon": 0xe227},
  ];

  static List<Map<String, dynamic>> _mockTransactions = [
    {
      "id": 1,
      "loai_gd": "Chi",
      "so_tien": 500000,
      "ten_danh_muc": "Nhà hàng",
      "ngay_giao_dich": DateTime.now().toString(),
      "anh_hoa_don": null,
    },
    {
      "id": 2,
      "loai_gd": "Thu",
      "so_tien": 1000000,
      "ten_danh_muc": "Lương",
      "ngay_giao_dich": DateTime.now().toString(),
      "anh_hoa_don": null,
    },
  ];

  // ===== ACCOUNT =====
  static Future<List<Map<String, dynamic>>> getAccounts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockAccounts;
  }

  // ===== CHI CATEGORY =====
  static Future<List<Map<String, dynamic>>> getChiCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockChiCategories;
  }

  // ===== THU CATEGORY =====
  static Future<List<Map<String, dynamic>>> getThuCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockThuCategories;
  }

  // ===== TRANSACTIONS =====
  static Future<List<Map<String, dynamic>>> getTransactions(int userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockTransactions;
  }

  // ===== SAVE TRANSACTION =====
  static Future<bool> saveTransaction({
    required int userId,
    required int accountId,
    required int categoryId,
    required String type, // "Chi" hoặc "Thu"
    required double amount,
    String? description,
    DateTime? date,
    File? imageFile,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Tạo mock transaction mới
    final newTx = {
      "id": _mockTransactions.length + 1,
      "loai_gd": type,
      "so_tien": amount,
      "ten_danh_muc": type == "Chi" ? "Danh mục Chi" : "Loại Thu",
      "ngay_giao_dich": (date ?? DateTime.now()).toString(),
      "anh_hoa_don": imageFile?.path, // web sẽ là null, bytes không lưu mock
    };

    _mockTransactions.add(newTx);
    return true;
  }
}
