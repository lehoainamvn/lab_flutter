import 'package:flutter/material.dart';
import 'api_service.dart'; 
import 'signup_screen.dart'; 
import 'reset_password_screen.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. Khai báo các Controller và Key 
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService api = ApiService(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, 
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.person_outline, size: 100),
              const SizedBox(height: 20),

              // --- EMAIL FIELD --- 
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'The field cannot be empty'; 
                  }
                  final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Invalid email address'; 
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // --- PASSWORD FIELD --- 
              TextFormField(
                controller: passwordController,
                obscureText: true, 
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'The field cannot be empty'; 
                  }
                  if (value.length < 7) {
                    return 'The password must contain at least 7 characters'; 
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // --- NÚT SIGN IN (XỬ LÝ LOGIC ĐĂNG NHẬP) --- 
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    
                    // Gọi hàm login từ ApiService
                    bool isSuccess = await api.login(
                      emailController.text,
                      passwordController.text,
                    );

                    if (mounted) {
                      if (isSuccess) {
                        // Đăng nhập thành công: Hiển thị Dialog
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Thành công', style: TextStyle(color: Colors.green)),
                            content: const Text("Bạn đã đăng nhập thành công!"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Đóng Dialog
                                  // TODO: Mở comment dòng dưới đây để chuyển hướng sang màn hình Home sau khi bấm OK
                                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Đăng nhập thất bại (Sai email/password)
                        showDialog(
                          context: context,
                          builder: (_) => const AlertDialog(
                            title: Text('Thất bại', style: TextStyle(color: Colors.red)),
                            content: Text("Email hoặc mật khẩu không chính xác. Vui lòng thử lại!"),
                          ),
                        );
                      }
                    }
                  }
                },
                child: const Text("Sign in"),
              ),
              const SizedBox(height: 10),

              // --- NÚT SIGN UP --- 
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SignupScreen()),
                  ); 
                },
                child: const Text("Sign up"),
              ),

              // --- QUÊN MẬT KHẨU --- 
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
                  ); 
                },
                child: const Text("Forgot password?"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}