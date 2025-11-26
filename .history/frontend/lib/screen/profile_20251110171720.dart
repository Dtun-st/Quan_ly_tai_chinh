import 'package:flutter/material.dart';
import 'package:frontend/screen/bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final Map<String, dynamic> userData = const {
    "name": "Nguyễn Duy Tùng",
    "email": "tungnguyen@example.com",
    "phone": "0909123456",
    "birthday": "01/01/2000",
    "gender": "Nam",
  };

  @override
  Widget build(BuildContext context) {
    final bool isMale = userData['gender'] == "Nam";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang cá nhân'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.orange.shade100,
              child: Icon(
                isMale ? Icons.account_circle : Icons.female,
                color: Colors.orange,
                size: 80,
              ),
            ),
            const SizedBox(height: 16),

            
            Text(
              userData['name'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.email, color: Colors.orange),
                const SizedBox(width: 8),
                Text(userData['email']),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.phone, color: Colors.orange),
                const SizedBox(width: 8),
                Text(userData['phone']),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cake, color: Colors.orange),
                const SizedBox(width: 8),
                Text(userData['birthday']),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person, color: Colors.orange),
                const SizedBox(width: 8),
                Text(userData['gender']),
              ],
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit),
              label: const Text('Chỉnh sửa thông tin'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const CustomBottomNav(currentIndex: 4),
    );
  }
}
