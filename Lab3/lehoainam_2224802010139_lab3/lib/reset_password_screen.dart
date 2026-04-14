import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset password")), // 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.lock_reset, size: 100, color: Colors.orange), // 
            const SizedBox(height: 30),
            
            // Trường nhập Email để reset
            const TextField(
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            
            // Nút Reset password
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý gửi email reset mật khẩu
                },
                child: const Text("Reset password"),
              ),
            ),
            const SizedBox(height: 10),
            
            // Nút Back quay lại 
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Back"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}