import 'package:disputeresolverai/screens/home/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login_screenLogic extends GetxController {
  TextEditingController passCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  var isLoading = false.obs; // Observable for loading state
  var isPasswordHidden = true.obs;
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  String getUserInitials() {
    // Example: Extracting the first character of the name
    String userName = "User Name";
    return userName.isNotEmpty ? userName[0].toUpperCase() : "?";
  }
  Future<void> signUser() async {
    if (passCon.text.isEmpty || emailCon.text.isEmpty) {
      Get.snackbar('Error', 'Some Error occurred');
    }
    isLoading.value = true; // Start loading
    await Future.delayed(const Duration(seconds: 2)); // Simulate a login process
    isLoading.value = false; // Stop loading

    UserCredential userCredential =await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCon.text, password: passCon.text);
    if(userCredential != null){
      Get.to(()=>HomeScreenPage());
    }
  }
}
