import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintItem {
  String compId;
  final String userId;
  final String name;
  final String details;
  final DateTime dateTime;
  final String location;
  final String priority;
  String status;
  final String username;
  final String useremail;
  final String userphone;

  ComplaintItem({
    required this.compId,
    required this.userId,
    required this.name,
    required this.details,
    required this.dateTime,
    required this.location,
    required this.priority,
    required this.status,
    required this.username,
    required this.userphone,
    required this.useremail,
  });

  toJson() {
    return {
      'compId': compId,
      'userId': userId,
      'name': name,
      'details': details,
      'dateTime': Timestamp.fromDate(dateTime),
      'location': location,
      'priority': priority,
      'status': status,
      'username': username,
      'useremail': useremail,
      'userphone': userphone,
    };
  }

  factory ComplaintItem.fromJson(Map<String, dynamic> json) {
    return ComplaintItem(
      compId: json['compId'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      details: json['details'] ?? '',
      dateTime: (json['dateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      location: json['location'] ?? 'Unknown',
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      username: json['username'] ?? '',
      useremail: json['useremail'] ?? '',
      userphone: json['userphone'] ?? '',
    );
  }
}
