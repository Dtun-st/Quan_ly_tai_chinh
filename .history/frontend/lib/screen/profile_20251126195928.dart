// import 'package:flutter/material.dart';
// import 'package:frontend/screen/bottom_nav.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../services/profile_service.dart';

// const Color primaryColor = Color(0xFFFF7A00); 
// const Color accentColor = Color(0xFFFFD1A8);
// const Color backgroundColor = Colors.white;
// const Color neutralColor = Color(0xFFF5F5F5);

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   Map<String, dynamic>? userData;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadProfile();
//   }

//   Future<void> _loadProfile() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getInt('userId');
//     if (userId != null) {
//       final data = await ProfileService().getProfile(userId);
//       setState(() {
//         userData = data;
//         _isLoading = false;
//       });
//     } else {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading)
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));

//     if (userData == null)
//       return const Scaffold(
//         body: Center(child: Text("Không tải được dữ liệu")),
//       );

//     return Scaffold(
//       backgroundColor: neutralColor,
//       appBar: AppBar(
//         title: const Text(
//           'Trang cá nhân',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: primaryColor,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings_rounded),
//             onPressed: () => print("Mở Cài đặt"),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             _buildProfileHeader(),
//             const SizedBox(height: 20),
//             _buildInfoCard(),
//             const SizedBox(height: 20),
//             _buildActionButtons(),
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//       bottomNavigationBar: const CustomBottomNav(currentIndex: 4),
//     );
//   }

//   Widget _buildProfileHeader() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.only(top: 24, bottom: 24),
//       decoration: const BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 10,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 60,
//             backgroundColor: accentColor,
//             child: Icon(Icons.person_rounded, size: 70, color: primaryColor),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             userData!['name'] ?? '',
//             style: const TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             "Tài khoản thường",
//             style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton.icon(
//             onPressed: () => print("Chỉnh sửa thông tin"),
//             icon: const Icon(Icons.edit_rounded, size: 20),
//             label: const Text('Chỉnh sửa thông tin'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: primaryColor,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               elevation: 4,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoCard() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         elevation: 4,
//         color: backgroundColor,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildInfoRow(Icons.email_rounded, "Email", userData!['email']),
//               const Divider(height: 1),
//               _buildInfoRow(
//                 Icons.phone_android_rounded,
//                 "Số điện thoại",
//                 userData!['phone'],
//               ),
//               const Divider(height: 1),
//               _buildInfoRow(
//                 Icons.calendar_today_rounded,
//                 "Ngày tạo",
//                 userData!['ngay_tao'],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String label, dynamic value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12.0),
//       child: Row(
//         children: [
//           Icon(icon, color: primaryColor, size: 24),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   value?.toString() ?? "",
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButtons() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Tùy chọn khác",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 12),
//           _buildActionTile(
//             Icons.notifications_rounded,
//             "Cài đặt Thông báo",
//             Colors.blue,
//           ),
//           _buildActionTile(
//             Icons.lock_rounded,
//             "Bảo mật & Quyền riêng tư",
//             Colors.purple,
//           ),
//           _buildActionTile(Icons.logout_rounded, "Đăng xuất", Colors.red),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionTile(IconData icon, String title, Color color) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 2,
//       child: ListTile(
//         leading: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(icon, color: color, size: 24),
//         ),
//         title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
//         trailing: const Icon(
//           Icons.arrow_forward_ios_rounded,
//           size: 18,
//           color: Colors.grey,
//         ),
//         onTap: () async {
//           if (title == "Đăng xuất") {
//             final prefs = await SharedPreferences.getInstance();
//             await prefs.clear(); 
//             if (mounted) {
//               Navigator.of(context).pushNamedAndRemoveUntil(
//                 '/login', 
//                 (route) => false,
//               );
//             }
//           } else {
//             print("Chuyển đến $title");
//           }
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:frontend/screen/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/profile_service.dart';

const Color primaryColor = Color(0xFFFF7A00);
const Color accentColor = Color(0xFFFFD1A8);
const Color backgroundColor = Colors.white;
const Color neutralColor = Color(0xFFF5F5F5);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId != null) {
      final data = await ProfileService().getProfile(userId);
      setState(() {
        userData = data;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userData == null) {
      return const Scaffold(
        body: Center(child: Text("Không tải được dữ liệu")),
      );
    }

    return Scaffold(
      backgroundColor: neutralColor,
      appBar: AppBar(
        title: const Text(
          'Trang cá nhân',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 20),
            _buildInfoCard(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 4),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(
        color: backgroundColor,
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 45,
            backgroundColor: primaryColor,
            child: Icon(Icons.person, color: Colors.white, size: 50),
          ),
          const SizedBox(height: 12),
          Text(
            userData!['name'] ?? "No Name",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            userData!['email'] ?? "",
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _infoRow(Icons.email, "Email", userData!['email']),
          const Divider(),
          _infoRow(Icons.phone, "Số điện thoại", userData!['phone'] ?? "Chưa cập nhật"),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: primaryColor, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
    );
  }
}
