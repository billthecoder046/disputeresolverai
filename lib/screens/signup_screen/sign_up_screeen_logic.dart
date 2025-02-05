import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/users.dart';
import '../home/home_view.dart';

class SignUp_screeenLogic extends GetxController {
  TextEditingController userName = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  Future<bool> userNameAvailable(String username) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('name', isEqualTo: username)
        .get();
    List<DocumentSnapshot> saim = querySnapshot.docs;
    if (saim.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> createUserOnFirebase(String myImgUrl) async {
    if (userName.text.isEmpty || emailC.text.isEmpty || passC.text.isEmpty) {
      Get.snackbar('Error', 'All fields are required!');
    } else {
      try {
        bool isAvailable = await userNameAvailable(userName.text);
        if (isAvailable == true) {
          Get.snackbar('Error', 'User already exists');
        } else {
          UserCredential myUser = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
              email: emailC.text, password: passC.text);
          if (myUser.user != null) {
            String name = userName.text;
            String id = myUser.user!.uid; // Set id as the Firebase user's UID

            // Create a new Person instance with the current date and time
            Person person = Person(
              id: id, // Pass the id
              name: name,
              imageUrl: myImgUrl,
              createdAt: DateTime.now().microsecondsSinceEpoch,
            );

            // Save the person object to Firestore
            FirebaseFirestore.instance.collection("Users").doc(id).set(
              person.toJson(),
            );

            Get.to(() => HomeScreenPage());
          }
        }
      } catch (e) {
        print("Error occurred: $e");
        Get.snackbar('Error', e.toString());
      }
    }
  }
  Future<void> resetPassword() async {
if(emailC.text.isEmpty){
  Get.snackbar('Error', 'Please enter your email address');
  try{
     await FirebaseAuth.instance.sendPasswordResetEmail(email: emailC.text.trim());
     Get.snackbar('Success', 'Password reset email sent!');
  }catch(e){
    print(e);
    Get.snackbar('Error', 'Failed to send password reset email');
  }
}
  }
}
