import 'dart:typed_data';
import 'package:disputeresolverai/model/person.dart';
import 'package:disputeresolverai/screens/home/home_view.dart';
import 'package:disputeresolverai/utilities/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker_web/image_picker_web.dart';
import '../login_screen/login_screen_view.dart';
import 'sign_up_screeen_logic.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUp_screeenLogic logic = Get.put(SignUp_screeenLogic());
  Uint8List? _selectedImage;
  bool _isLoading = false;

  Future<void> _initialize() async {
    // Check if the user is signed in
    User? user =  FirebaseAuth.instance.currentUser;


    if (user != null) {
      print("My user is not null");
      Future.delayed(const Duration(seconds: 2));
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreenPage()));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: Card(
          elevation: 8,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    child: Image.asset('assets/images/pngegg (1).png'),
                  ),
                  const Divider(color: Colors.deepPurpleAccent),
                  InkWell(
                    onTap: () async {
                      _selectedImage = await ImagePickerWeb.getImageAsBytes();
                      setState(() {});
                    },
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: _selectedImage != null
                                ? MemoryImage(_selectedImage!)
                                : null,
                          ),
                          if (_selectedImage == null)
                            const Icon(Icons.camera_alt,
                                size: 40, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const Gap(10),
                  if (_selectedImage == null)
                    const Text(
                      "Tap to upload profile picture",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  const Gap(20),
                  TextFormField(
                    controller: logic.userName,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const Gap(16),
                  TextFormField(
                    controller: logic.emailC,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const Gap(16),
                  TextFormField(
                    controller: logic.passC,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    obscureText: true,
                  ),
                  const Gap(24),
                  InkWell(
                    onTap: _isLoading
                        ? null
                        : () async {
                            if (_selectedImage == null) {
                              Get.snackbar(
                                'Error',
                                'Please upload a profile picture before signing up.',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.redAccent,
                                colorText: Colors.white,
                              );
                              return;
                            }

                            setState(() => _isLoading = true);
                            String username = logic.userName.text;
                            String? imageUrl =
                                await _uploadImage(username, _selectedImage!);

                            if (imageUrl != null) {
                              await logic.createUserOnFirebase(imageUrl);
                            }

                            setState(() => _isLoading = false);
                          },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.teal, Colors.tealAccent],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(16),
                  TextButton(
                    onPressed: () {
                      _navigateToLogin();
                    },
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> _uploadImage(String folderPath, Uint8List image) async {
    const String filename = 'profile.jpg';
    final Reference ref =
        FirebaseStorage.instance.ref().child(folderPath).child(filename);

    try {
      await ref.putData(image);
      return await ref.getDownloadURL();
    } catch (e) {
      Get.snackbar('Error', 'Error uploading image: $e');
      print('Error uploading image: $e');
      return null;
    }
  }

  void _navigateToLogin() {
    Get.to(() => Login_screenPage());
  }
}
