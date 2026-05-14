import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';
import '../constants/color_constants.dart';
import 'home_page.dart';
import '../widgets/loading_view.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    ChatAuthProvider authProvider = Provider.of<ChatAuthProvider>(context);
    switch (authProvider.status) {
      case Status.authenticateError:
        Fluttertoast.showToast(msg: "Sign in fail");
        break;
      case Status.authenticateCanceled:
        Fluttertoast.showToast(msg: "Sign in canceled");
        break;
      case Status.authenticated:
        Fluttertoast.showToast(msg: "Sign in success");
        break;
      default:
        break;
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "LOGIN",
            style: TextStyle(color: ColorConstants.primaryColor),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Center(
              child: TextButton(
                onPressed: () async {
                  bool isSuccess = await authProvider.handleSignIn();
                  if (isSuccess) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  }
                },
                child: const Text(
                  "SIGN IN WITH GOOGLE",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(const Color(0xffdd4b39)),
                  padding: WidgetStateProperty.all<EdgeInsets>(
                    const EdgeInsets.fromLTRB(30, 15, 30, 15),
                  ),
                ),
              ),
            ),
            // Loading
            Positioned(
              child: authProvider.status == Status.authenticating ? const LoadingView() : const SizedBox.shrink(),
            ),
          ],
        ));
  }
}
