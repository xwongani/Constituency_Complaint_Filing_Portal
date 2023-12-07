import 'dart:html' as html;
import 'dart:js';
import 'package:complaints_portal/components/admin_components/navbar2.dart';
import 'package:complaints_portal/components/admin_components/piechartdetails.dart';
import 'package:complaints_portal/components/admin_components/total.dart';
import 'package:complaints_portal/components/navigation_bar_admin.dart';
import 'package:complaints_portal/components/admin_components/chart.dart';
import 'package:complaints_portal/models/complaint_item.dart';
import 'package:complaints_portal/pages/admin_login.dart';
import 'package:complaints_portal/pages/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintDataSource extends DataTableSource {
  final List<ComplaintItem> complaints;
  final Function(ComplaintItem) onRowTap;
  final user = FirebaseAuth.instance.currentUser;

  ComplaintDataSource(
    this.complaints, {
    required this.onRowTap,
  }) {
    sortComplaintsByPriority();
  }

  void sortComplaintsByPriority() {
    complaints.sort((a, b) {
      if (a.priority == 'High' && b.priority != 'High') {
        return -1; // 'High' priority comes before other priorities
      } else if (a.priority != 'High' && b.priority == 'High') {
        return 1; // 'High' priority comes after other priorities
      } else if (a.priority == 'Neutral' && b.priority == 'Low') {
        return -1; // 'Neutral' comes before 'Low'
      } else if (a.priority == 'Low' && b.priority == 'Neutral') {
        return 1; // 'Low' comes after 'Neutral'
      } else if (a.priority == 'Neutral' &&
          b.priority != 'High' &&
          b.priority != 'Low') {
        return -1; // 'Neutral' comes before other non-'High' and non-'Low'
      } else if (a.priority == 'Low' && b.priority != 'High') {
        return 1; // 'Low' comes after other non-'High'
      } else {
        return 0;
      }
    });
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    if (index >= complaints.length) return null;

    final complaint = complaints[index];
    Color priorityColor = Colors.black; //Default color for priority
// Assigning colors based on priority
    switch (complaint.priority) {
      case 'High':
        priorityColor = const Color.fromARGB(255, 246, 35, 20);
        break;
      case 'Neutral':
        priorityColor = const Color.fromARGB(255, 246, 160, 47);
        break;
      case 'Low':
        priorityColor = const Color.fromARGB(255, 45, 91, 242);
        break;
      default:
        break;
    }
    Color textColor = Colors.black;
    // Assigning colors based on status
    switch (complaint.status) {
      case 'In Review':
        textColor = Colors.deepOrange;
        break;
      case 'In progress':
        textColor = const Color.fromARGB(255, 45, 91, 242);
        break;
      case 'Done':
        textColor = const Color.fromARGB(255, 35, 165, 40);
        break;
      case 'Rejected':
        textColor = Colors.red;
        break;
      default:
        break;
    }

    return DataRow(
      cells: [
        DataCell(Text(complaint.name)),
        DataCell(
          Text(
            complaint.details,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        DataCell(Text(
          complaint.status,
          style: TextStyle(color: textColor, fontSize: 12),
        )),
        DataCell(Container(
          height: 25,
          width: 50,
          decoration: BoxDecoration(
            color: priorityColor,
            borderRadius: BorderRadius.circular(4.0),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              complaint.priority,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            ),
          ),
        )),
      ],
      onSelectChanged: (isSelected) {
        if (isSelected != null && isSelected) {
          onRowTap(complaint);
        }
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => complaints.length;

  @override
  int get selectedRowCount => 0;
}

class OfficialDashboard extends StatefulWidget {
  const OfficialDashboard({Key? key});

  @override
  State<OfficialDashboard> createState() => _OfficialDashboardState();
}

class _OfficialDashboardState extends State<OfficialDashboard> {
  final user = FirebaseAuth.instance.currentUser;
  bool sort = true;
  List<ComplaintItem> complaints = [];
  Map<String, Map<String, dynamic>> usersMap = {};

  @override
  void initState() {
    super.initState();
    fetchComplaintDataFromFirestore();
  }

  //Sign user out
  void signadminOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  Future<void> fetchComplaintDataFromFirestore() async {
    final complaintsCollection =
        FirebaseFirestore.instance.collection('complaints');
    final querySnapshot = await complaintsCollection.get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        complaints = querySnapshot.docs
            .map((doc) => ComplaintItem.fromJson(doc.data()))
            .toList();
      });
      await fetchUsersDataForComplaints(); // Fetch user data
    }
  }

  Future<void> fetchUsersDataForComplaints() async {
    final userIds = complaints.map((complaint) => complaint.userId).toSet();
    final usersCollection = FirebaseFirestore.instance.collection('Users');

    // Fetch user data based on complaint userId and associate it with complaints
    for (final userId in userIds) {
      final userQuery = await usersCollection.doc(userId).get();

      if (userQuery.exists) {
        final userData = userQuery.data();
        if (userData != null) {
          usersMap[userId] =
              userData.cast<String, dynamic>(); // Handling nullable types
        }
      }
    }
    setState(() {});
  }

  Future<void> updateComplaintStatus(
      ComplaintItem complaint, String newValue) async {
    if (newValue != null && complaint.status != newValue) {
      try {
        await FirebaseFirestore.instance
            .collection('complaints')
            .doc(complaint.compId)
            .update({'status': newValue});

        setState(() {
          // Update the status directly in the existing complaint item
          final index = complaints
              .indexWhere((element) => element.compId == complaint.compId);
          complaints[index].status = newValue;
          complaints = List.from(complaints);
        });
      } catch (e) {
        print('Error updating status: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 1, 41, 2),
      body: Builder(builder: (BuildContext context) {
        return Column(
          children: [
            NavBarAdmin2(),
            const SizedBox(height: 5),
            const Divider(),
            Expanded(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width *
                      0.25, // Width for the chart space
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      TotalComplaints(),
                      const SizedBox(
                        height: 30,
                      ),
                      //Chart
                      Container(
                        height: 400,
                        width: 400,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(
                            child: MyPieChart(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Center(child: details()),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          SizedBox(
                            width: double.infinity,
                            child: Theme(
                              data: ThemeData.light().copyWith(
                                cardColor: Theme.of(context).canvasColor,
                              ),
                              child: SingleChildScrollView(
                                child: PaginatedDataTable(
                                  sortColumnIndex: 0,
                                  sortAscending: sort,
                                  columns: [
                                    DataColumn(
                                      label: const Text(
                                        "Complaint Name",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      onSort: (columnIndex, ascending) {
                                        setState(() {
                                          sort = !sort;
                                          complaints.sort((a, b) {
                                            if (ascending) {
                                              return a.name.compareTo(b.name);
                                            } else {
                                              return b.name.compareTo(a.name);
                                            }
                                          });
                                        });
                                      },
                                    ),
                                    DataColumn(
                                      label: const Text(
                                        "Complaint Details",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      onSort: (columnIndex, ascending) {
                                        setState(() {
                                          sort = !sort;
                                          complaints.sort((a, b) {
                                            if (ascending) {
                                              return a.details
                                                  .compareTo(b.details);
                                            } else {
                                              return b.details
                                                  .compareTo(a.details);
                                            }
                                          });
                                        });
                                      },
                                    ),
                                    const DataColumn(
                                      label: Text(
                                        "Status",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      numeric: false,
                                    ),
                                    DataColumn(
                                      label: const Text(
                                        "Priority",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      onSort: (columnIndex, ascending) {
                                        setState(() {
                                          sort = !sort;
                                          complaints.sort((a, b) {
                                            if (ascending) {
                                              return a.priority
                                                  .compareTo(b.priority);
                                            } else {
                                              return b.priority
                                                  .compareTo(a.priority);
                                            }
                                          });
                                        });
                                      },
                                    ),
                                  ],
                                  source: ComplaintDataSource(
                                    complaints,
                                    onRowTap: (complaint) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          final userData =
                                              usersMap[complaint.userId] ?? {};
                                          String dropdownValue =
                                              complaint.status;
                                          final List<String> statusOptions = [
                                            'In Review',
                                            'In progress',
                                            'Rejected',
                                            'Done'
                                          ];

                                          return AlertDialog(
                                            title: const Text(
                                              'Complaint Details',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blueAccent),
                                            ),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Center(
                                                    child: Container(
                                                        height: 200,
                                                        width: 200,
                                                        color: Colors
                                                            .grey.shade300,
                                                        child: const Icon(
                                                          Icons.image,
                                                          size: 70,
                                                        )),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Text(
                                                    'Complaint',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    'Title: ${complaint.name}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Text(
                                                    'Details: ${complaint.details}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Text(
                                                    'Status: ${complaint.status}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Text(
                                                    'Priority: ${complaint.priority}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  const SizedBox(height: 10),

                                                  //User Details
                                                  const Text(
                                                    'User Details:',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    'Name: ${complaint.username}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Text(
                                                    'Email: ${complaint.useremail}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Text(
                                                    'Phone: ${complaint.userphone}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),

                                                  DropdownButton<String>(
                                                    value: complaint.status ==
                                                            'N/A'
                                                        ? 'In Review'
                                                        : complaint.status,
                                                    items: statusOptions
                                                        .map((String value) {
                                                      Color textColor =
                                                          Colors.black;
                                                      // Assigning colors based on status
                                                      switch (value) {
                                                        case 'In Review':
                                                          textColor =
                                                              Colors.orange;
                                                          break;
                                                        case 'In progress':
                                                          textColor =
                                                              Colors.blue;
                                                          break;
                                                        case 'Done':
                                                          textColor =
                                                              const Color
                                                                  .fromARGB(255,
                                                                  35, 165, 40);
                                                          break;
                                                        case 'Rejected':
                                                          textColor =
                                                              Colors.red;
                                                          break;
                                                        default:
                                                          break;
                                                      }

                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value,
                                                          style: TextStyle(
                                                              color: textColor),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (String?
                                                        newValue) async {
                                                      if (newValue != null &&
                                                          complaint.status !=
                                                              newValue) {
                                                        await updateComplaintStatus(
                                                            complaint,
                                                            newValue);
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Close'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  rowsPerPage: 10,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(),
                                child: Text(
                                  "Logged In As: ${user?.email ?? 'Unknown'}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
          ],
        );
      }),
    );
  }
}

class PriorityData {
  final String priority;
  final int count;

  PriorityData(this.priority, this.count);
}
