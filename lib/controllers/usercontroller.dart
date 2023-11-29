import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserController extends GetxController {
  RxMap<String, dynamic>? userData;

  Future<void> fetchUserData(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        userData = (userDoc.data() as Map<String, dynamic>).obs;
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
}
