import 'package:complaints_portal/components/register_container.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 46, 2),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            const SizedBox(height: 80),
            // Citizens Complaint Portal

            const Text(
              'YOU\RE ALMOST THERE',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),

            // Register container

            RegisterContainer(),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already registered?',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    'Log in',
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
          ]),
        ),
      )),
    );
  }
}
