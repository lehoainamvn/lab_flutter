import 'package:flutter/material.dart';
import 'api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService api = ApiService();

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi đóng màn hình
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registration")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.person_add, size: 100, color: Colors.blue),
              const SizedBox(height: 20),

              // --- USERNAME ---
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username không được để trống';
                  }
                  if (value.length < 3) {
                    return 'Username phải >= 3 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // --- EMAIL ---
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email không được để trống';
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Email không hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // --- PASSWORD ---
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password không được để trống';
                  }
                  if (value.length < 7) {
                    return 'Password phải >= 7 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // --- NÚT SIGN UP ---
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    
                    // Gọi hàm register từ ApiService và đợi kết quả
                    bool isSuccess = await api.register({
                      "name": nameController.text,
                      "email": emailController.text,
                      "password": passwordController.text, // Nhớ đảm bảo password trên MockAPI là String
                    });

                    if (mounted) {
                      if (isSuccess) {
                        // Đăng ký thành công -> Hiện Dialog
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Thành công', style: TextStyle(color: Colors.green)),
                            content: const Text("Bạn đã đăng ký tài khoản thành công!"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Đóng Dialog
                                  Navigator.pop(context); // Quay về trang đăng nhập
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Đăng ký thất bại -> Hiện Dialog
                        showDialog(
                          context: context,
                          builder: (_) => const AlertDialog(
                            title: Text('Thất bại', style: TextStyle(color: Colors.red)),
                            content: Text("Có lỗi xảy ra khi đăng ký. Vui lòng thử lại!"),
                          ),
                        );
                      }
                    }
                  }
                },
                child: const Text("Sign up"),
              ),

              const SizedBox(height: 10),

              // --- NÚT QUAY LẠI ---
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Back"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}