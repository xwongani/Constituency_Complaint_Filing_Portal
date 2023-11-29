import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaints_portal/components/date_of_birth.dart';
import 'package:complaints_portal/components/dropdown_field.dart';
import 'package:complaints_portal/components/my_button.dart';
import 'package:complaints_portal/components/text_formfield.dart';
import 'package:complaints_portal/controllers/register_controller.dart';
import 'package:complaints_portal/components/text_field.dart';
import 'package:complaints_portal/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

final _formKey = GlobalKey<FormState>();

class RegisterContainer extends StatefulWidget {
  RegisterContainer({Key? key}) : super(key: key);

  @override
  State<RegisterContainer> createState() => _RegisterContainerState();
}

class _RegisterContainerState extends State<RegisterContainer> {
  final RegistrationController _registrationController =
      Get.put(RegistrationController());
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

  void signUp() async {
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Call the registration function from the controller
    await _registrationController.signingUp(
      email: nrcController.text.trim(),
      password: passwordController.text,
      fullname: fullnameController.text.trim(),
      nrc: cardController.text.trim(),
      phone: phonenumberController.text.trim(),
      age: ageController.text.trim(),
      gender: genderController.text.trim(),
      region: regionController.text.trim(),
      constituency: constuencyController.text.trim(),
      role: 'citizen',
    );

    // Pop the loader
    Navigator.pop(context);
    _formKey.currentState!.validate();
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

  bool validateNRC(String nrc) {
    // Regular expression for NRC validation
    RegExp nrcRegex = RegExp(r'^\d{6}/\d{2}/\d{1}$');
    return nrcRegex.hasMatch(nrc);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 650,
      height: 690,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 7),
                  // Name Fields
                  Row(
                    children: [
                      Expanded(
                        child: MyTextFormField(
                            controller: fullnameController,
                            hintText: 'Full Name',
                            obscureText: false,
                            validator: (fullname) => fullname!.length < 3
                                ? 'Full Name should be at least 3 characters'
                                : null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // NRC and Phone Number
                  Row(
                    children: [
                      Expanded(
                        child: MyTextFormField(
                            controller: cardController,
                            hintText: 'NRC(e.g., 111111/11/1)',
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an NRC';
                              } else if (!validateNRC(value)) {
                                return 'Please enter a valid NRC (e.g., 111111/11/1)';
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: MyTextField(
                          controller: phonenumberController,
                          hintText: 'Phone Number (+260)',
                          obscureText: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Text(
                            'Date Of Birth',
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      //date of birth
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: DOB(),
                      )),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    child: Row(
                      children: [
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: DropDownField(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: MyTextField(
                            controller: constuencyController,
                            hintText: 'Constituency',
                            obscureText: false,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Email and Password
                  Column(
                    children: [
                      MyTextFormField(
                          controller: nrcController,
                          hintText: 'Email',
                          obscureText: false,
                          validator: validateEmail,
                          autovalidateMode: AutovalidateMode.onUserInteraction),
                      const SizedBox(height: 10),
                      MyTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      MyTextField(
                        controller: confirmpasswordController,
                        hintText: 'Confirm Password',
                        obscureText: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  // Submit button
                  SubmitButton(onTap: signUp, text: 'Register'),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
