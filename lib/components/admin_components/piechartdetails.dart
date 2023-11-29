import 'package:flutter/material.dart';

class details extends StatelessWidget {
  const details({super.key});

  @override
  Widget build(BuildContext context) {
    Color defaultcolor = Colors.white;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              height: 17,
              width: 17,
              color: Color.fromARGB(255, 202, 17, 4),
            ),
            SizedBox(
              height: 2,
            ),
            const Text(
              'High',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        SizedBox(width: 15),
        Column(
          children: [
            Container(
              height: 17,
              width: 17,
              color: Colors.orange,
            ),
            SizedBox(
              height: 2,
            ),
            const Text(
              'Neutral',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        SizedBox(width: 15),
        Column(
          children: [
            Container(
              height: 17,
              width: 17,
              color: const Color.fromARGB(255, 45, 91, 242),
            ),
            SizedBox(
              height: 2,
            ),
            const Text(
              'Low',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
