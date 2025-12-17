import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/change_service.dart';

const Color primaryColor = Color(0xFFFF6D00);
const Color textColor = Color(0xFF333333);

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  bool loading = false;

  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("userId");
  }

  void _changePassword() async {
    final oldPass = oldPassController.text.trim();
    final newPass = newPassController.text.trim();
    final confirmPass = confirmPassController.text.trim();

    // ===== VALIDATE =====
    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      _showMsg("Vui lòng nhập đầy đủ thông tin");
      return;
    }

    if (newPass.length < 6) {
      _showMsg("Mật khẩu mới phải có ít nhất 6 ký tự");
      return;
    }

    if (newPass != confirmPass) {
      _showMsg("Xác nhận mật khẩu không khớp");
      return;
    }

    final userId = await _getUserId();
    if (userId == null) {
      _showMsg("Không xác định được người dùng");
      return;
    }

    setState(() => loading = true);

    final result = await ChangePasswordService().changePassword(
      userId: userId,
      oldPassword: oldPass,
      newPassword: newPass,
    );

    setState(() => loading = false);

    _showMsg(result["message"]);

    if (result["success"]) {
      Navigator.pop(context);
    }
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        content: Text(msg, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  InputDecoration _inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: primaryColor, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Đổi mật khẩu", style: TextStyle(color: textColor)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: primaryColor),
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: oldPassController,
              obscureText: true,
              decoration: _inputStyle("Mật khẩu cũ"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: newPassController,
              obscureText: true,
              decoration: _inputStyle("Mật khẩu mới (≥ 6 ký tự)"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: confirmPassController,
              obscureText: true,
              decoration: _inputStyle("Xác nhận mật khẩu mới"),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: loading ? null : _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Xác nhận",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
