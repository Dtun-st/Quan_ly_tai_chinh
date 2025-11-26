// import 'package:flutter/material.dart';
// import 'package:frontend/screen/bottom_nav.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   final Map<String, dynamic> userData = const {
//     "name": "Nguyễn Duy Tùng",
//     "email": "tungnguyen@example.com",
//     "phone": "0909123456",
//     "birthday": "01/01/2000",
//     "gender": "Nam",
//   };

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Trang cá nhân'),
//         backgroundColor: Colors.orange,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: const CircleAvatar(
//                 radius: 50,
//                 backgroundColor: Colors.orange,
//                 child: Icon(Icons.person, size: 60, color: Colors.white),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Center(
//               child: Text(
//                 userData['name'],
//                 style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Row(
//               children: [
//                 const Icon(Icons.email, color: Colors.orange),
//                 const SizedBox(width: 8),
//                 Text(userData['email']),
//               ],
//             ),
//             const SizedBox(height: 8),

//             Row(
//               children: [
//                 const Icon(Icons.phone, color: Colors.orange),
//                 const SizedBox(width: 8),
//                 Text(userData['phone']),
//               ],
//             ),
//             const SizedBox(height: 8),

//             Row(
//               children: [
//                 const Icon(Icons.cake, color: Colors.orange),
//                 const SizedBox(width: 8),
//                 Text(userData['birthday']),
//               ],
//             ),
//             const SizedBox(height: 8),

//             Row(
//               children: [
//                 const Icon(Icons.person_outline, color: Colors.orange),
//                 const SizedBox(width: 8),
//                 Text(userData['gender']),
//               ],
//             ),

//             const SizedBox(height: 24),

//             Center(
//               child: ElevatedButton.icon(
//                 onPressed: () {
//                 },
//                 icon: const Icon(Icons.edit),
//                 label: const Text('Chỉnh sửa thông tin'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orange,
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),

//       bottomNavigationBar: const CustomBottomNav(currentIndex: 4),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:frontend/screen/bottom_nav.dart';

// Màu sắc chủ đạo
const Color primaryColor = Color(0xFFFF7A00); // Cam rực rỡ
const Color accentColor = Color(0xFFFFD1A8); // Cam nhạt
const Color backgroundColor = Colors.white;
const Color neutralColor = Color(0xFFF5F5F5); // Xám nhạt

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // =============================
  // DỮ LIỆU (GIỮ NGUYÊN)
  // =============================
  final Map<String, dynamic> userData = const {
    "name": "Nguyễn Duy Tùng",
    "email": "tungnguyen@example.com",
    "phone": "0909123456",
    "birthday": "01/01/2000",
    "gender": "Nam",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: neutralColor, // Nền xám nhạt cho toàn màn hình
      appBar: AppBar(
        title: const Text(
          'Trang cá nhân',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => print("Mở Cài đặt"),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Profile Card (Chứa Avatar và Tên)
            _buildProfileHeader(context),
            const SizedBox(height: 20),

            // Thông tin chi tiết (List)
            _buildInfoCard(),
            const SizedBox(height: 20),

            // Các tùy chọn khác
            _buildActionButtons(),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 4),
    );
  }

  // =============================
  // UI COMPONENTS (ĐÃ CHỈNH SỬA GIAO DIỆN)
  // =============================

  // 👤 Phần Header chứa Avatar và Tên
  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24, bottom: 24),
      decoration: const BoxDecoration(
        color: backgroundColor, // Nền trắng
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: accentColor, // Cam nhạt
            child: Icon(Icons.person_rounded, size: 70, color: primaryColor), // Cam rực rỡ
          ),
          const SizedBox(height: 16),
          Text(
            userData['name'],
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(
            "Tài khoản thường",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => print("Chỉnh sửa thông tin"),
            icon: const Icon(Icons.edit_rounded, size: 20),
            label: const Text('Chỉnh sửa thông tin'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 4,
            ),
          ),
        ],
      ),
    );
  }

  // 📝 Card chứa thông tin chi tiết
  Widget _buildInfoCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(Icons.email_rounded, "Email", userData['email']),
              const Divider(height: 1),
              _buildInfoRow(Icons.phone_android_rounded, "Số điện thoại", userData['phone']),
              const Divider(height: 1),
              _buildInfoRow(Icons.cake_rounded, "Ngày sinh", userData['birthday']),
              const Divider(height: 1),
              _buildInfoRow(Icons.wc_rounded, "Giới tính", userData['gender']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }

  // ⚙️ Các tùy chọn khác
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tùy chọn khác",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          _buildActionTile(Icons.notifications_rounded, "Cài đặt Thông báo", Colors.blue),
          _buildActionTile(Icons.lock_rounded, "Bảo mật & Quyền riêng tư", Colors.purple),
          _buildActionTile(Icons.logout_rounded, "Đăng xuất", Colors.red),
        ],
      ),
    );
  }

  Widget _buildActionTile(IconData icon, String title, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey),
        onTap: () => print("Chuyển đến $title"),
      ),
    );
  }
} 