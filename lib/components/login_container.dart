import 'package:complaints_portal/components/my_button.dart';
import 'package:complaints_portal/components/text_field.dart';
import 'package:complaints_portal/components/text_formfield.dart';
import 'package:complaints_portal/pages/forgot_pw.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _formKey = GlobalKey<FormState>();

class LoginContainer extends StatefulWidget {
  const LoginContainer({super.key});

  @override
  State<LoginContainer> createState() => _LoginContainerState();
}

class _LoginContainerState extends State<LoginContainer> {
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
      //pop the loader
      Navigator.pop(context);
      _formKey.currentState!.validate();
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

  String? validateEmail(String? email) {
    RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final isEmailValid = emailRegex.hasMatch(email ?? '');
    if (!isEmailValid) {
      return 'Please enter a valid email';
    }
    return null;
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
          child: SingleChildScrollView(
            child: Column(children: [
              const SizedBox(height: 7),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Citizens Login',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              //Nrc Login
              MyTextFormField(
                controller: nrcController,
                hintText: 'Email',
                obscureText: false,
                validator: validateEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 10),
              //Password
              MyTextField(
                controller: passwordController,
                hintText: 'password',
                obscureText: true,
              ),
              const SizedBox(height: 5),
              //forgot password
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ForgotPasswordPage();
                            },
                          ),
                        );
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              const SizedBox(height: 20),
              //Submit button
              SubmitButton(onTap: singIn, text: 'Sign In'),
              const SizedBox(height: 20),

              //bottom text
            ]),
          ),
        ),
      ),
    );
  }
}
