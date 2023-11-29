import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavBarAdmin extends StatelessWidget {
  const NavBarAdmin({Key? key}) : super(key: key);

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
              child: Icon(
                Icons.flag_circle_rounded,
                color: const Color.fromARGB(255, 165, 99, 0),
                size: 70,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.logout_outlined),
                  onPressed: signUserOut,
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
