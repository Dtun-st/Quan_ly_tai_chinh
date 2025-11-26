import 'package:flutter/material.dart';
import '../services/forgot_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool codeSent = false;
  bool isLoading = false;

  void sendCode() async {
    if (_emailController.text.isEmpty) return showSnack("Vui lòng nhập email!");

    setState(() => isLoading = true);
    bool success = await AuthService.sendResetCode(_emailController.text);
    setState(() => isLoading = false);

    if (success) {
      setState(() => codeSent = true);
      showSnack("Mã xác thực đã gửi đến email!");
    } else {
      showSnack("Gửi email thất bại");
    }
  }

  void resetPassword() async {
    if (_codeController.text.isEmpty || _newPasswordController.text.isEmpty) {
      return showSnack("Vui lòng nhập đầy đủ thông tin!");
    }

    setState(() => isLoading = true);
    bool success = await AuthService.resetPassword(
      email: _emailController.text,
      code: _codeController.text,
      newPassword: _newPasswordController.text,
    );
    setState(() => isLoading = false);

    if (success) {
      showSnack("Đặt lại mật khẩu thành công!");
      Navigator.pop(context);
    } else {
      showSnack("Mã xác thực không hợp lệ hoặc lỗi server");
    }
  }

  void showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text("Quên mật khẩu", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Icon(Icons.lock_reset, color: Colors.deepOrange, size: 90),
            const SizedBox(height: 20),
            const Text("Khôi phục mật khẩu", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text(
              "Nhập email đã đăng ký để nhận mã OTP.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            if (codeSent) ...[
              TextField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: "Mã OTP",
                  prefixIcon: const Icon(Icons.verified),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Mật khẩu mới",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : (codeSent ? resetPassword : sendCode),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(codeSent ? "Đặt lại mật khẩu" : "Gửi mã OTP", style: const TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Quay lại đăng nhập", style: TextStyle(color: Colors.deepOrange)),
            ),
          ],
        ),
      ),
    );
  }
}
