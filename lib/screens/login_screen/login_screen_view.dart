
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_screen_logic.dart';

import 'package:disputeresolverai/screens/home/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


class Login_screenLogic extends GetxController {
  //MyVariables
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController userName = TextEditingController();

  //ifSignedInVariable
  RxBool isSignedIn = true.obs;


  //MyFunctions
  Future<void> createUserOnFirebase() async{
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

  //MyFunctions
  Future<void> logOut() async{
    await _firebaseAuth.signOut();
    Get.offAll(Login_screenPage());

    }


}
// am here

