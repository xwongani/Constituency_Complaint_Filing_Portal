import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class ComplaintTile extends StatelessWidget {
  final String name;
  final String details;
  final DateTime dateTime;
  final String location;
  final String compId;
  String status;

  ComplaintTile({
    Key? key,
    required this.name,
    required this.details,
    required this.dateTime,
    required this.location,
    required this.compId,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('complaints')
          .doc(compId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return CircularProgressIndicator();
        }

        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
        String status = data['status'];

        Color statusColor = Colors.deepOrange; // Default text color

        // Assigning colors based on status
        switch (status) {
          case 'In Review':
            statusColor = Colors.orange;
            break;
          case 'In progress':
            statusColor = Colors.blue;
            break;
          case 'Done':
            statusColor = Color.fromARGB(255, 35, 165, 40);
            break;
          case 'Rejected':
            statusColor = Colors.red;
            break;
          default:
            break;
        }

        return ListTile(
          leading: Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Icon(
              Icons.image,
              size: 40, // Adjust the size as needed
            ),
          ),
          title: Text(
            name,
            style: const TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details,
                  style: TextStyle(color: Colors.grey.shade800),
                ),
                Text(
                  'Location: $location',
                  style:
                      TextStyle(fontSize: 13, color: Colors.blueGrey.shade300),
                ),
                Text(
                  '${dateTime.day}/${dateTime.month}/${dateTime.year}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 63, 252),
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
          trailing: Text(
            status,
            style: TextStyle(color: statusColor),
          ),
        );
      },
    );
  }
}
