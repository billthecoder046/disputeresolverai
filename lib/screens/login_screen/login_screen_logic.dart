import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disputeresolverai/screens/home/home_view.dart';
import 'package:disputeresolverai/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/users.dart';
import 'login_screen_view.dart';

class Login_screenLogic extends GetxController {
  //MyVariables
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController userName = TextEditingController();



  //ifSignedInVariable
  RxBool isSignedIn = true.obs;
  
  
  //MyFunctions
  Future<void> createUserOnFirebase(String myProfileImageUrl) async{
    if(emailC.text.isEmpty || passC.text.isEmpty){
      Get.snackbar(
         'Email or password is empty',
        "Both are required",
        colorText: Colors.white,
        backgroundColor: Colors.lightBlue,
        icon: const Icon(Icons.add_alert),
      );
    }else {
      try {
        // Create user with Firebase Authentication
        UserCredential? myUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );

        if (myUser != null) {
          // Extract user ID
          String myUserId = myUser.user!.uid;

          // Create MyUser object (assuming `MyUser` class exists)
          MyUser myUserData = MyUser(id: myUserId,name: userName.text,imageUrl:myProfileImageUrl,createdAt: DateTime.now().toString() );

          // Save user data to Firestore (you need to add the actual data)
          await FirebaseFirestore.instance.collection("Users").doc(myUserId).set(
            myUserData.toJson()
          );

          // Navigate to HomePage with transition (assuming HomePage exists)
          Get.to(
                () => HomePage(),
            transition: Transition.leftToRight,
          );
        } else {
          // Show snackbar for failed user creation
          Get.snackbar(
            MyStrings.someErrorOccurred.tr,
            MyStrings.userCantLogin.tr,
          );
        }
      } on FirebaseAuthException catch (e) {
        // Handle specific FirebaseAuth exceptions (recommended)
        String message = "";
        switch (e.code) {
          case "weak-password":
            message = "Password is too weak.";
            break;
          case "email-already-in-use":
            message = "Email already exists.";
            break;
          default:
            message = MyStrings.someErrorOccurred.tr;
        }
        Get.snackbar("Error Creating User", message, colorText: Colors.white, backgroundColor: Colors.lightBlue, icon: const Icon(Icons.add_alert));
      } catch (e) {
        // Catch other exceptions (generic error handling)
        print(e);
        Get.snackbar(
          'Some issue occurred',
          e.toString(), // Avoid showing complete error message for security reasons
          colorText: Colors.white,
          backgroundColor: Colors.lightBlue,
          icon: const Icon(Icons.add_alert),
        );
      } finally {
        print("Thankyou for your time"); // This can be removed if not needed
      }
    }

  }
  Future<void> signInUserOnApp() async{
    if(emailC.text.isEmpty || passC.text.isEmpty){
      Get.snackbar(
         'Email or password is empty',
        "Both are required",
        colorText: Colors.white,
        backgroundColor: Colors.lightBlue,
        icon: const Icon(Icons.add_alert),
      );
    }else{
      try {
              Get.to(()=> HomePage(), transition: Transition.leftToRight);
                  } catch (e) {
        print(e);
        Get.snackbar(
          'Some issue occurred',
          e.toString(),
          colorText: Colors.white,
          backgroundColor: Colors.lightBlue,
          icon: const Icon(Icons.add_alert),
        );
      } finally {
        print("Thankyou for your time");
      }
    }

  }
  //

  Future<void> loginUser() async{
      try {
        UserCredential myUser = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailC.text, password: passC.text);
        if(myUser != null){
          Get.to(()=> HomePage(), transition: Transition.leftToRight);
              }else{
                Get.snackbar(MyStrings.someErrorOccurred.tr,MyStrings.userCantLogin.tr);
              }
      } catch (e) {
        print(e);
        Get.snackbar(MyStrings.someErrorOccurred.tr,e.toString());
      }
  }

  //MyFunctions
  Future<void> logOut() async{
   await _firebaseAuth.signOut();
   Get.offAll(Login_screenPage());

  }
  

}
