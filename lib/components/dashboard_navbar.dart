import 'package:flutter/material.dart';

class DashNavBarAdmin extends StatelessWidget {
  const DashNavBarAdmin({Key? key}) : super(key: key);

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
              height: 80,
              width: 150,
              child: Image.asset('assets/images/logo.png'),
            ),
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [],
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
