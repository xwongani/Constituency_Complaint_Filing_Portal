import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaints_portal/models/complaint_item.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference complaintsCollection =
      FirebaseFirestore.instance.collection('complaints');

  Future<String?> addComplaintItem(ComplaintItem complaint) async {
    try {
      // Get the currently authenticated user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Add the complaint to Firestore with the user's ID
        DocumentReference newComplaintRef = await complaintsCollection.add({
          'userId': user.uid, // Associate the user ID with the complaint
          'image': complaint.image.toString(),
          'name': complaint.name,
          'details': complaint.details,
          'dateTime': complaint.dateTime,
          'location': complaint.location,
          'priority': 'N/A',
          'status': 'In Review',
          'username': complaint.username,
          'useremail': complaint.useremail,
          'userphone': complaint.userphone,
        });

        // Get the auto-generated document ID
        String compId = newComplaintRef.id;

        // Update the complaint's compId after addition to Firestore
        await newComplaintRef.update({'compId': compId});

        return compId; // Return the document ID
      } else {
        // Handle the case where the user is not authenticated
        print("User not authenticated");
      }
    } catch (e) {
      print("Error adding complaint: $e");
    }
  }
}
