import 'package:complaints_portal/authentication/user_repository.dart';
import 'package:complaints_portal/models/user_model.dart';
import 'package:complaints_portal/pages/citizens_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final nrcController = TextEditingController();
  final fullnameController = TextEditingController();
  final cardController = TextEditingController();
  final phonenumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final ageController = TextEditingController();
  final regionController = TextEditingController();
  final constuencyController = TextEditingController();
  final genderController = TextEditingController();

  Future<void> signingUp({
    required String email,
    required String password,
    required String fullname,
    required String nrc,
    required String phone,
    required String age,
    required String gender,
    required String region,
    required String constituency,
    required String role,
  }) async {
    try {
      // Check if the passwords match
      if (passwordController.text != confirmpasswordController.text) {
        Get.snackbar('Error', 'Passwords do not match');
        return;
      }

      final UserCredential authResult =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = authResult.user;

      if (user != null) {
        final UserModel userModel = UserModel(
          userId: user.uid,
          fullname: fullname,
          nrc: nrc,
          phone: phone,
          age: age,
          gender: gender,
          region: region,
          constituency: constituency,
          email: email,
          role: role,
          password: password,
        );

        // Clear text controllers
        fullnameController.clear();
        cardController.clear();
        phonenumberController.clear();
        ageController.clear();
        genderController.clear();
        regionController.clear();
        constuencyController.clear();
        nrcController.clear();
        passwordController.clear();
        confirmpasswordController.clear();

        // Create a Firestore document for the user
        await UserRepository.instance.createUser(userModel);

        // Navigate to the next screen or perform any desired action
        Get.offAll(HomePage()); // Use GetX navigation
      }
    } catch (e) {
      print(e.toString());
      // Show error message using GetX Snackbar or AlertDialog
      Get.snackbar('Error', e.toString());
    }
  }
}
