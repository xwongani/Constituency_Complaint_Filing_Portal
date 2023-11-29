import 'package:complaints_portal/authentication/user_repository.dart';
import 'package:complaints_portal/controllers/register_controller.dart';
import 'package:complaints_portal/controllers/complaintxcontroller.dart';
import 'package:complaints_portal/controllers/location_controller.dart';
import 'package:complaints_portal/controllers/usercontroller.dart';
import 'package:complaints_portal/pages/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  // User repository
  Get.put(UserRepository());
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: LocationBinding(),
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}

class LocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LocationController());
    Get.put(RegistrationController());
    Get.put(ComplaintxController());
    Get.put(UserController());
  }
}
