import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker_web/image_picker_web.dart';

import 'login_screen_logic.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUp_screeenLogic logic = Get.put(SignUp_screeenLogic());
  Uint8List? _selectedImage;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Allows scrolling if content overflows
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Align children to stretch horizontally
            children: [
              InkWell(
                onTap: () async {
                  _selectedImage = await ImagePickerWeb.getImageAsBytes();
                  setState(() {});
                },
                child: Center( // Center the avatar
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _selectedImage != null ? MemoryImage(_selectedImage!) : null,
                    child: _selectedImage == null
                        ? const Icon(Icons.person_add, size: 60)
                        : null,
                  ),
                ),
              ),
              const Gap(20),
              TextFormField(
                controller: logic.userName,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const Gap(16),
              TextFormField(
                controller: logic.emailC,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const Gap(16),
              TextFormField(
                controller: logic.passC,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const Gap(24),
              ElevatedButton(
                onPressed: _isLoading ? null : () async {
                  setState(() => _isLoading = true);
                  String username = logic.userName.text;
                  String? imageUrl = await _uploadImage(username, _selectedImage!);

                  if (imageUrl != null) {
                    await logic.createUserOnfirebase(imageUrl);
                  }

                  setState(() => _isLoading = false);
                },

                child: _isLoading
                    ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : const Text('Sign Up'),


              ),

            ],
          ),
        ),

      ),


    );
  }



  Future<String?> _uploadImage(String folderPath, Uint8List image) async {
    const String filename = 'profile.jpg'; // Lowercase filename is generally preferred
    final Reference ref = FirebaseStorage.instance.ref().child(folderPath).child(filename);

    try {
      await ref.putData(image);
      return await ref.getDownloadURL();
    } catch (e) {
      // Show a snackbar or dialog with the error message
      Get.snackbar('Error', 'Error uploading image: $e');
      print('Error uploading image: $e');
      return null;
    }
  }
}
