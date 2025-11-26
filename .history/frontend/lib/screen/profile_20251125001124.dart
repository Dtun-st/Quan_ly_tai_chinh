import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
    if (_isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    if (userData == null)
      return const Scaffold(
        body: Center(child: Text("Không tải được dữ liệu")),
      );

    return Scaffold(
      appBar: AppBar(title: const Text("Trang cá nhân")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(radius: 50, child: Icon(Icons.person, size: 60)),
            const SizedBox(height: 16),
            Text(userData!['name'] ?? '', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            _buildRow(Icons.email, "Email", userData!['email']),
            const SizedBox(height: 8),
            _buildRow(Icons.phone, "SĐT", userData!['phone']),
            const SizedBox(height: 8),
            _buildRow(Icons.cake, "Ngày sinh", userData!['birthday']),
            const SizedBox(height: 8),
            _buildRow(Icons.wc, "Giới tính", userData!['gender']),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, dynamic value) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value?.toString() ?? ""), // luôn có string
      ],
    );
  }
}
