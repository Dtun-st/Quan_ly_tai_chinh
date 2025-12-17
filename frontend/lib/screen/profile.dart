// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../services/profile_service.dart';
// import 'bottom_nav.dart';
// import 'change_password.dart'; 

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
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (userData == null) {
//       return const Scaffold(
//         body: Center(child: Text("Không tải được dữ liệu")),
//       );
//     }

//     return Scaffold(
//       backgroundColor: neutralColor,
//       appBar: AppBar(
//         title: const Text(
//           'Trang cá nhân',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: primaryColor,
//         iconTheme: const IconThemeData(color: Colors.white),
//         elevation: 0,
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

//   // ------------------------------
//   // Header thông tin người dùng
//   // ------------------------------
//   Widget _buildProfileHeader() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 24),
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

//           // Nút chỉnh sửa thông tin
//           ElevatedButton.icon(
//             onPressed: () {
//               print("Chỉnh sửa thông tin");
//             },
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

//   // ------------------------------
//   // Thông tin cá nhân
//   // ------------------------------
//   Widget _buildInfoCard() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Card(
//         elevation: 4,
//         color: backgroundColor,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               _buildInfoRow(Icons.email_rounded, "Email", userData!['email']),
//               const Divider(height: 1),
//               _buildInfoRow(
//                 Icons.phone_android_rounded,
//                 "Số điện thoại",
//                 userData!['phone'],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String label, dynamic value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Row(
//         children: [
//           Icon(icon, color: primaryColor, size: 24),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(label,
//                     style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
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
//         ],
//       ),
//     );
//   }

//   // ------------------------------
//   // Các chức năng khác
//   // ------------------------------
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
//             icon: Icons.lock_rounded,
//             title: "Đổi mật khẩu",
//             color: Colors.purple,
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
//               );
//             },
//           ),

//           _buildActionTile(
//             icon: Icons.notifications_rounded,
//             title: "Cài đặt Thông báo",
//             color: Colors.blue,
//           ),

//           _buildActionTile(
//             icon: Icons.logout_rounded,
//             title: "Đăng xuất",
//             color: Colors.red,
//             onTap: () async {
//               final prefs = await SharedPreferences.getInstance();
//               await prefs.clear();

//               if (mounted) {
//                 Navigator.of(context)
//                     .pushNamedAndRemoveUntil('/login', (route) => false);
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionTile({
//     required IconData icon,
//     required String title,
//     required Color color,
//     VoidCallback? onTap,
//   }) {
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
//         trailing: const Icon(Icons.arrow_forward_ios_rounded,
//             size: 18, color: Colors.grey),
//         onTap: onTap ?? () => print("Chuyển đến $title"),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/profile_service.dart';
import 'bottom_nav.dart';
import 'change_password.dart';

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
  bool _isEditing = false;

  late TextEditingController _nameController;
  late TextEditingController _phoneController;

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
      if (data != null) {
        _nameController = TextEditingController(text: data['name']);
        _phoneController = TextEditingController(text: data['phone']);
      }
      setState(() {
        userData = data;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return;

    final success = await ProfileService().updateProfile(
      userId: userId,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    if (success) {
      setState(() {
        userData!['name'] = _nameController.text;
        userData!['phone'] = _phoneController.text;
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thông tin thành công')),
      );
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
        body: Center(child: Text('Không tải được dữ liệu')),
      );
    }

    return Scaffold(
      backgroundColor: neutralColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Trang cá nhân',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildInfoCard(),
            const SizedBox(height: 20),
            _buildActions(),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 4),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF7A00), Color(0xFFFF9F43)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: const CircleAvatar(
              radius: 55,
              backgroundColor: accentColor,
              child: Icon(Icons.person, size: 60, color: primaryColor),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            userData!['name'],
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: () {
              if (_isEditing) {
                _saveProfile();
              } else {
                setState(() => _isEditing = true);
              }
            },
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            label: Text(_isEditing ? 'Lưu thông tin' : 'Chỉnh sửa thông tin'),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: primaryColor,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= INFO =================
  Widget _buildInfoCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 6,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildField(
                icon: Icons.email,
                label: 'Email',
                value: userData!['email'],
                enabled: false,
              ),
              const SizedBox(height: 12),
              _buildField(
                icon: Icons.person,
                label: 'Họ tên',
                controller: _nameController,
              ),
              const SizedBox(height: 12),
              _buildField(
                icon: Icons.phone,
                label: 'Số điện thoại',
                controller: _phoneController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required IconData icon,
    required String label,
    String? value,
    TextEditingController? controller,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller ?? TextEditingController(text: value),
      enabled: _isEditing && enabled,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: primaryColor),
        labelText: label,
        filled: true,
        fillColor:
            (_isEditing && enabled) ? Colors.white : neutralColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // ================= ACTIONS =================
  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            ListTile(
              leading:
                  const Icon(Icons.lock_outline, color: primaryColor),
              title: const Text('Đổi mật khẩu'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChangePasswordScreen(),
                  ),
                );
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Đăng xuất',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                if (mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (_) => false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
