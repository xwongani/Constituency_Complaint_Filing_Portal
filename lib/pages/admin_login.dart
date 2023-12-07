import 'package:complaints_portal/components/login_container%20admin.dart';
import 'package:complaints_portal/components/navbar3.dart';
import 'package:complaints_portal/components/navigation_bar_admin.dart';
import 'package:flutter/material.dart';

class OfficialLoginPage extends StatefulWidget {
  OfficialLoginPage({
    super.key,
  });

  @override
  State<OfficialLoginPage> createState() => _OfficialLoginPageState();
}

class _OfficialLoginPageState extends State<OfficialLoginPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 46, 2),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(children: [
//NavbarAdmin1 is found in navbar3 in components
            NavBarAdmin1(),
            SizedBox(height: 80),
            // Citizens Complaint Portal
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                'WELCOME BACK!',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),

            SizedBox(height: 30),
            // Login container

            LoginAdminContainer(),

            SizedBox(height: 20),
          ]),
        ),
      )),
    );
  }
}
