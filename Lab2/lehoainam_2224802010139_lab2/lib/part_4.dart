import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Form Application',
      theme: ThemeData(
        // Cấu hình UI chung cho toàn bộ TextField trong app để code DRY (Don't Repeat Yourself)
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      home: const RegistrationPage(),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // 1. Khai báo controllers để lấy và quản lý dữ liệu người dùng nhập
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void dispose() {
    // 2. BẮT BUỘC: Phải dispose các controller khi màn hình bị hủy để tránh rò rỉ bộ nhớ (Memory Leak)
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _showSuccessDialog() {
    // Lấy dữ liệu từ controller và loại bỏ khoảng trắng thừa
    final String fullName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Successful'),
          content: Text('Welcome, $fullName'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Đóng dialog
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Application'),
        centerTitle: true,
      ),
      // 3. Bọc SingleChildScrollView để tránh lỗi Bottom Overflow khi bàn phím ảo bật lên che mất UI
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Avatar Placeholder (Thay cho ảnh asset local của Lab)
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 24),

              // 4. Sử dụng Custom Widget để tái sử dụng code, giúp build method ngắn gọn
              CustomTextField(
                label: 'First Name',
                controller: _firstNameController,
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'Last Name',
                controller: _lastNameController,
              ),
              const SizedBox(height: 16),

              const CustomTextField(
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              const CustomTextField(
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
                maxLength: 10,
              ),
              const SizedBox(height: 16),

              const CustomTextField(
                label: 'Username',
              ),
              const SizedBox(height: 16),

              const CustomTextField(
                label: 'Password',
                obscureText: true, // Ẩn text khi nhập mật khẩu
              ),
              const SizedBox(height: 16),

              const CustomTextField(
                label: 'Confirm Password',
                obscureText: true,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity, // Kéo dài nút bấm ra full chiều ngang
                height: 48,
                child: ElevatedButton(
                  onPressed: _showSuccessDialog,
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// CustomTextField: Component tái sử dụng chuyên biệt cho form nhập liệu.
/// Việc tách Widget này ra (Composition) tuân thủ quy tắc Clean Architecture.
class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final int? maxLength;

  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }
}