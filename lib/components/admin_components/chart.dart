import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MyPieChart extends StatelessWidget {
  const MyPieChart({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('complaints').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final docs = snapshot.data?.docs ?? [];
        int highCount = 0;
        int neutralCount = 0;
        int lowCount = 0;

        for (var doc in docs) {
          final priority = doc['priority'];
          if (priority == 'High') {
            highCount++;
          } else if (priority == 'Neutral') {
            neutralCount++;
          } else if (priority == 'Low') {
            lowCount++;
          }
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            const Text(
              'Complaints',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            PieChart(
              swapAnimationDuration: const Duration(milliseconds: 750),
              swapAnimationCurve: Curves.easeInOutQuint,
              PieChartData(sections: [
                PieChartSectionData(
                  value: highCount.toDouble(),
                  color: Color.fromARGB(255, 202, 17, 4),
                ),
                PieChartSectionData(
                  value: neutralCount.toDouble(),
                  color: Colors.orange,
                ),
                PieChartSectionData(
                  value: lowCount.toDouble(),
                  color: const Color.fromARGB(255, 45, 91, 242),
                ),
              ]),
            ),
          ],
        );
      },
    );
  }
}
