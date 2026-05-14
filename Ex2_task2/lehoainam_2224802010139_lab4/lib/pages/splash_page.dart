import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';
import '../constants/color_constants.dart';
import 'home_page.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      checkSignedIn();
    });
  }

  void checkSignedIn() async {
    ChatAuthProvider authProvider = context.read<ChatAuthProvider>();
    bool isLoggedIn = await authProvider.isLoggedIn();
    if (!context.mounted) return;
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "images/app_icon.png",
              width: 100,
              height: 100,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.chat, size: 100, color: ColorConstants.themeColor),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: ColorConstants.themeColor),
          ],
        ),
      ),
    );
  }
}
