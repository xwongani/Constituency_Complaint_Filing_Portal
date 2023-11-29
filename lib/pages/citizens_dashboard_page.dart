import 'dart:html' as html;
import 'dart:ui';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaints_portal/components/complaint_tile.dart';
import 'package:complaints_portal/components/navigation_bar_admin.dart';
import 'package:complaints_portal/components/text_field.dart';
import 'package:complaints_portal/controllers/complaint_controller.dart';
import 'package:complaints_portal/controllers/complaintxcontroller.dart';
import 'package:complaints_portal/controllers/location_controller.dart';
import 'package:complaints_portal/data/dateutils.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:complaints_portal/models/complaint_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

class ComplaintInputDialog extends StatefulWidget {
  final LocationController locationController;

  const ComplaintInputDialog({required this.locationController});

  @override
  State<ComplaintInputDialog> createState() => _ComplaintInputDialogState();
}

class _ComplaintInputDialogState extends State<ComplaintInputDialog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController complaintController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  LocationController controller = Get.find<LocationController>();
  String selectedFile = '';
  File? file;
  Uint8List? selectedImageInBytes;
  List<Uint8List> pickedImagesInBytes = [];
  List<String> imageUrls = [];
  int imageCounts = 0;
  ImagePicker image = ImagePicker();
  String? location;
  bool isItemSaved = false;

  @override
  void initState() {
    super.initState();
    fetchUserInformation();
  }

// Function to get an image from the camera
  /* Future<void> getCam() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        file = File(image.path);
      });
    }
  }*/
  Future<void> _selectFile(bool imageFrom) async {
    FilePickerResult? fileResult =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (fileResult != null) {
      setState(() {
        selectedFile = fileResult.files.first.name;
        fileResult.files.forEach((element) {
          pickedImagesInBytes.add(element.bytes!);
          imageCounts += 1;
        });
      });
    }
    print(selectedFile);
  }

  // Function to get an image from the gallery
  Future<String> _uploadFile() async {
    String imageUrl = '';
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('complaints')
          .child(selectedFile);

      final metadata =
          firebase_storage.SettableMetadata(contentType: 'image/jpg');

      // Upload the selected image bytes to Firebase Storage
      await ref.putData(selectedImageInBytes!, metadata);

      // Retrieve the download URL of the uploaded image
      imageUrl = await ref.getDownloadURL();
    } catch (e) {
      print(e);
    }
    return imageUrl;
  }

  final complaintxController = Get.find<ComplaintxController>();

// Function to save a complaint
  Future<void> save() async {
    if (titleController.text.isNotEmpty &&
        complaintController.text.isNotEmpty) {
      try {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          CollectionReference complaintsCollection =
              FirebaseFirestore.instance.collection('complaints');
          String imageUrl = await _uploadFile();
          DocumentReference newComplaintRef = await complaintsCollection.add({
            'userId': user.uid,
            'image': imageUrl,
            'name': titleController.text,
            'details': complaintController.text,
            'dateTime': DateTime.now().toUtc(),
            'location': controller.currentLocation ?? 'Unknown',
            'priority': 'N/A',
            'status': 'In Review',
            'username': fullNameController.text,
            'useremail': emailController.text,
            'userphone': phoneController.text,
          });

          // Get the auto-generated document ID
          String compId = newComplaintRef.id;

          // Update the document with the compId
          await newComplaintRef.update({'compId': compId});

          // Create a ComplaintItem with the user's ID and other details
          ComplaintItem newComplaint = ComplaintItem(
            compId: compId,
            userId: user.uid,
            image: file,
            name: titleController.text,
            details: complaintController.text,
            dateTime: DateTime.now().toUtc(),
            location: controller.currentLocation ?? 'Unknown',
            priority: 'N/A',
            status: 'In Review',
            username: fullNameController.text,
            useremail: emailController.text,
            userphone: phoneController.text,
          );

          // Create an instance of FirestoreService
          FirestoreService firestoreService = FirestoreService();

          // Add the new complaint to Firestore
          await firestoreService.addComplaintItem(newComplaint);

          // Add the new complaint to the ComplaintController
          complaintxController.addComplaint(newComplaint);
        } else {
          print("User not authenticated");
        }
      } catch (e) {
        print("Error saving complaint: $e");
      }
    }
    Navigator.pop(context);
    clear();
  }

  //cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  // clear
  void clear() {
    titleController.clear();
    complaintController.clear();
    file = file;
    controller.currentLocation = null;
  }

  Future<void> fetchUserInformation() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('userId', isEqualTo: user.uid)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Assuming there's only one document with a specific userId
          DocumentSnapshot userDataSnapshot = querySnapshot.docs.first;

          String? fullName = userDataSnapshot.get('FullName');
          String? email = userDataSnapshot.get('Email');
          String? phone = userDataSnapshot.get('Phone');

          if (fullName != null && email != null && phone != null) {
            print("Retrieved user data:");
            print("FullName: $fullName");
            print("Email: $email");
            print("Phone: $phone");

            setState(() {
              fullNameController.text = fullName;
              emailController.text = email;
              phoneController.text = phone;
              // Set other text controllers for Age, Constituency, Gender, etc., if needed
            });
          } else {
            print("One or more fields are null");
          }
        } else {
          print("User document not found");
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    } else {
      print("User is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(builder: (controller) {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Center(
                  child: Container(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: selectedFile.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.add_a_photo,
                                      size: 50,
                                    ),
                                  )
                                : file != null && file!.path.isNotEmpty
                                    ? Image.file(
                                        File(file!.path),
                                        fit: BoxFit.cover,
                                      )
                                    : selectedImageInBytes != null &&
                                            selectedImageInBytes!.isNotEmpty
                                        ? Image.memory(
                                            selectedImageInBytes!,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            //case where both file and selectedImageInBytes are null
                                            child: Text('Image'),
                                          ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _selectFile(true);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue[900],
                          ),
                          child: Text(
                            "Select Photo",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              )),
            ),
            const SizedBox(
              height: 10,
            ),

            //Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: MyTextField(
                controller: titleController,
                hintText: 'Title',
                obscureText: false,
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            const SizedBox(
              height: 10,
            ),
            //Complaint
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: 100,
                  width: 322,
                  child: TextField(
                    minLines: 2,
                    maxLines: 20,
                    controller: complaintController,
                    keyboardType: TextInputType.multiline,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Complaint',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: MyTextField(
                controller: fullNameController,
                hintText: 'Full Name',
                obscureText: false,
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            // Email text field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            // Phone text field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: MyTextField(
                controller: phoneController,
                hintText: 'Phone',
                obscureText: false,
              ),
            ),

            Row(
              children: [
                Flexible(
                  child: Text(
                    widget.locationController.currentLocation == null
                        ? 'Location'
                        : widget.locationController.currentLocation!,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 150),
                  child: Container(
                    child: IconButton(
                      onPressed: () async {
                        await widget.locationController.getCurrentLocation();
                      },
                      icon: const Icon(Icons.my_location),
                      iconSize: 35,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 5),
//buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  onPressed: cancel,
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 5),
                MaterialButton(
                  onPressed: save,
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  LocationController controller = Get.find<LocationController>();

  // Function to file a complaint
  void fileComplaint() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text('File Complaint'),
            content: ComplaintInputDialog(
              locationController: controller,
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? userId = user?.uid;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 5,
            ),
            const NavBarAdmin(),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      height: 650,
                      width: 800,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        border: Border.all(
                          color: Color.fromARGB(255, 4, 159, 6),
                          width: 5.0,
                        ),
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
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 250,
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_box_outlined),
                            iconSize: 60,
                            onPressed: fileComplaint,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "File Complaint",
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(),
                              child: Text(
                                "Logged In As: ${user?.email ?? 'Unknown'}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    height: 650,
                    width: 800,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 1, 46, 2),
                      border: Border.all(
                        color: const Color.fromARGB(255, 1, 46, 2),
                        width: 2.0,
                      ),
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
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('complaints')
                          .where('userId', isEqualTo: userId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          final List<QueryDocumentSnapshot> complaints =
                              snapshot.data!.docs;

                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Obx(
                              () {
                                final complaints =
                                    Get.find<ComplaintxController>().complaints;
                                return ListView.builder(
                                    itemCount: complaints.length,
                                    itemBuilder: (context, index) => Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Card(
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0)),
                                            child: ComplaintTile(
                                              image: complaints[index].image,
                                              name: complaints[index].name,
                                              details:
                                                  complaints[index].details,
                                              location:
                                                  complaints[index].location,
                                              dateTime:
                                                  complaints[index].dateTime,
                                              status: complaints[index].status,
                                              compId: complaints[index].compId,
                                            ),
                                          ),
                                        ));
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
