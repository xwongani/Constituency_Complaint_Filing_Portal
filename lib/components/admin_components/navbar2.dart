import 'package:complaints_portal/pages/admin_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//for use in admin dashboard
class NavBarAdmin2 extends StatelessWidget {
  NavBarAdmin2({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser;

  //Sign user out
  void signUserOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      // Error occurred during sign-out
      print("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Container(
      height: 80,
      color: Colors.grey.shade200,
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
                color: Colors.black,
                size: 70,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Text('Official Dashboard',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center),
            SizedBox(
              width: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OfficialLoginPage()),
                    );
                  },
                  child: Text(
                    'LogOut',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
  final FontWeight fontWeight;

  const _NavBarItem(this.title,
      {required this.textColor, this.fontWeight = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        color: textColor,
        fontWeight: fontWeight,
      ),
    );
  }
}
