import 'package:complaints_portal/main.dart';
import 'package:complaints_portal/pages/auth_page.dart';
import 'package:complaints_portal/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavBarAdmin1 extends StatelessWidget {
  const NavBarAdmin1({Key? key}) : super(key: key);

  //Sign user out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: Image(
                image: NetworkImage(
                    'https://static.cdnlogo.com/logos/c/87/coat-of-arms-of-zambia.svg'),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AuthPage()),
                    );
                  },
                  child: Text(
                    'Citizens Login',
                    style: TextStyle(
                        color: Colors.deepOrange, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String title;
  final Color textColor;
  final FontWeight fontWeight; // Added a fontWeight parameter

  const _NavBarItem(this.title,
      {required this.textColor, this.fontWeight = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        color: textColor,
        fontWeight: fontWeight, // Use the provided fontWeight
      ),
    );
  }
}
