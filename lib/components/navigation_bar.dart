import 'package:complaints_portal/pages/admin_login.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 150,
              width: 150,
              child: Icon(
                Icons.flag_circle_rounded,
                color: Colors.orange,
                size: 70,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _NavBarItem(
                  'Official Login',
                  textColor: Colors.red,
                  fontWeight: FontWeight.bold,
                  onTap: () {
                    // Navigate to the admin login page when the button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OfficialLoginPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 5),
                const Icon(
                  Icons.supervised_user_circle,
                  color: Colors.black,
                )
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
  final VoidCallback? onTap; // Callback for handling button press

  const _NavBarItem(
    this.title, {
    required this.textColor,
    this.fontWeight = FontWeight.normal,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap, // Use the provided callback
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          color: textColor,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
