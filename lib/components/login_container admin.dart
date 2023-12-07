import 'package:complaints_portal/components/my_button.dart';
import 'package:complaints_portal/components/text_field.dart';
import 'package:complaints_portal/pages/official_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoginAdminContainer extends StatefulWidget {
  const LoginAdminContainer({super.key});

  @override
  State<LoginAdminContainer> createState() => _LoginAdminContainerState();
}

class _LoginAdminContainerState extends State<LoginAdminContainer> {
  final nrcController = TextEditingController();

  final passwordController = TextEditingController();

  void singIn() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: nrcController.text, password: passwordController.text);

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          final userRole = userData['Role'];

          if (userRole == 'official') {
            // Redirect to the official dashboard
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OfficialDashboard()),
            );
          } else {
            // User is not an official
            showErrorMessage("You are not an official.");
          }
        } else {
          // User document not found, show an error message
          showErrorMessage("User data not found.");
        }
      } else {
        // User is null (authentication failed)
        print('User is null');
      }
    } on FirebaseAuthException catch (e) {
      //pop the loader
      Navigator.pop(context);
      //show error message
      showErrorMessage(e.code);
    }
  }

  //error message
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: Colors.red,
            title: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500, // Set a fixed width for the container
      height: 400, // Set a fixed height for the container
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: [
            const SizedBox(height: 7),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Official Login',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 1, 46, 2),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            //Nrc Login
            MyTextField(
              controller: nrcController,
              hintText: 'Email',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            //Password
            MyTextField(
              controller: passwordController,
              hintText: 'password',
              obscureText: true,
            ),
            const SizedBox(height: 5),

            const SizedBox(height: 20),
            //Submit button
            SubmitButton(onTap: singIn, text: 'Sign In'),
            const SizedBox(height: 5),
          ]),
        ),
      ),
    );
  }
}
