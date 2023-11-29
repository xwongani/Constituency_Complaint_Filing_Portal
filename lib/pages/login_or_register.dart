import 'package:flutter/material.dart';
import 'package:complaints_portal/pages/login_page.dart';
import 'package:complaints_portal/pages/register_page.dart';

class LoginOrResisterPage extends StatefulWidget {
  const LoginOrResisterPage({super.key});

  @override
  State<LoginOrResisterPage> createState() => _LoginOrResisterPageState();
}

class _LoginOrResisterPageState extends State<LoginOrResisterPage> {
//Initially show login page
  bool showLoginPage = true;

//toggle between login and register pages
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return RegisterPage(
        onTap: togglePages,
      );
    }
  }
}
