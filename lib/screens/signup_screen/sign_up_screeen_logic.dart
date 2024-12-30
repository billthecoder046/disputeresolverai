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
        .collection('Persons')
        .where('name', isEqualTo: username).get();
    List<DocumentSnapshot> saim= querySnapshot.docs;
    if(saim.isEmpty){
      return false;
    }else{
      return true;
    }
  }

  Future<void> createUserOnfirebase(String myImgUrl) async {
    if (userName.text.isEmpty || emailC.text.isEmpty || passC.text.isEmpty) {
      Get.snackbar('Error', 'teno khali ha');
    } else {
      try {
        bool isAvailable =await userNameAvailable(userName.text);
        if(isAvailable ==true){
          Get.snackbar('Error', 'User is already exist');
        }
        UserCredential myUser = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailC.text, password: passC.text);
        if (myUser != null) {
          String name = userName.text;
          // Create a new Person instance with the current date and time
          Person person = Person(
            name: name,
            imageUrl: myImgUrl,
            createdAt: DateTime.now().microsecondsSinceEpoch,
          );
          // Save the person object to Firestore
          FirebaseFirestore.instance.collection("Persons").doc(name).set(
                person.toJson(),
              );
          Get.to(() => Home_screenPage());
        }
      } catch (e) {
        print("apna error set karo $e");
      }
    }
  }


}
