import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:complaints_portal/pages/citizens_dashboard_page.dart';
import 'package:complaints_portal/pages/login_or_register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
//User is logged in
          if (snapshot.hasData) {
            return HomePage();
          }
          //User Is not logged In
          else {
            return LoginOrResisterPage();
          }
        }),
      ),
    );
  }
}
