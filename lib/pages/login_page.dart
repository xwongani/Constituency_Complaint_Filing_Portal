import 'package:complaints_portal/components/login_container.dart';
import 'package:flutter/material.dart';
import 'package:complaints_portal/components/navigation_bar.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 46, 2),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            const NavBar(),
            const SizedBox(height: 80),
            // Citizens Complaint Portal
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                'CONSTITUENCY COMPLAINT FILING AND HANDLING PORTAL',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
            const SizedBox(height: 50),
            // Login containe
            const LoginContainer(),

            const SizedBox(height: 20),
            //register

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Not a registered?',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    'Register Now',
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        decorationColor: Colors.amberAccent),
                  ),
                ),
              ],
            ),
          ]),
        ),
      )),
    );
  }
}
