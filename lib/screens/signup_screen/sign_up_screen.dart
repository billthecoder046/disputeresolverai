import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker_web/image_picker_web.dart';

import '../../login_screen/view.dart';
import 'sign_up_screeen_logic.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final SignUp_screeenLogic logic = Get.put(SignUp_screeenLogic());
  Uint8List? _selectedImage;
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _buttonAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      _animationController.forward().whenComplete(() {
                        _animationController.reset();
                      });

                      setState(() => _isLoading = true);
                      String username = logic.userName.text;
                      String? imageUrl =
                      await _uploadImage(username, _selectedImage!);

                      if (imageUrl != null) {
                        await logic.createUserOnfirebase(imageUrl);
                      }

                      setState(() => _isLoading = false);
                    },
                    child: ScaleTransition(
                      scale: _buttonAnimation,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.deepPurpleAccent,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white),
                        )
                            : const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: null,
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
    Get.to(() => Login_screenPage()); // Navigate to the Login screen.
  }
}

