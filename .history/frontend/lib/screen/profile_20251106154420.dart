import 'package:flutter/material.dart';
import 'package:frontend/screen/bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Mock dữ liệu người dùng
  final Map<String, dynamic> userData = const {
    "avatar": "https://i.pravatar.cc/150?img=3", // ảnh mẫu
    "name": "Nguyễn Duy Tùng",
    "email": "tungnguyen@example.com",
    "phone": "0909123456",
    "birthday": "01/01/2000",
    "gender": "Nam",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang cá nhân'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(userData['avatar']),
            ),
            const SizedBox(height: 16),

            // Tên
            Text(
              userData['name'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Email
            Row(
              children: [
                const Icon(Icons.email, color: Colors.orange),
                const SizedBox(width: 8),
                Text(userData['email']),
              ],
            ),
            const SizedBox(height: 8),

            // Phone
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.orange),
                const SizedBox(width: 8),
                Text(userData['phone']),
              ],
            ),
            const SizedBox(height: 8),

            // Birthday
            Row(
              children: [
                const Icon(Icons.cake, color: Colors.orange),
                const SizedBox(width: 8),
                Text(userData['birthday']),
              ],
            ),
            const SizedBox(height: 8),

            // Gender
            Row(
              children: [
                const Icon(Icons.person, color: Colors.orange),
                const SizedBox(width: 8),
                Text(userData['gender']),
              ],
            ),

            const SizedBox(height: 24),

            // Nút sửa thông tin
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Chuyển sang trang edit profile
              },
              icon: const Icon(Icons.edit),
              label: const Text('Chỉnh sửa thông tin'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),

      // bottom nav (tab index 4)
      bottomNavigationBar: const CustomBottomNav(currentIndex: 4),
    );
  }
}
