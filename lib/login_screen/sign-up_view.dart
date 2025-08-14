
import 'package:disputeresolverai/login_screen/view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'logic.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final Login_pageLogic logic = Get.put(Login_pageLogic());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Sign-Up Page",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.deepPurple,
                  ),
                ),
                const Gap(20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: logic.nameC,
                    decoration: InputDecoration(
                      hintText: "Enter name",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.person, color: Colors.deepPurple),
                    ),
                  ),
                ),
                const Gap(20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: logic.emailC,
                    decoration: InputDecoration(
                      hintText: "Enter Email",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.email, color: Colors.deepPurple),
                    ),
                  ),
                ),
                const Gap(20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: logic.passC,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Enter password",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.lock, color: Colors.deepPurple),
                    ),
                  ),
                ),
                const Gap(30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => logic.createUser(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const Gap(20),
                TextButton(
                  onPressed: () => Get.to(SignIn_page()),
                  child: const Text(
                    "Already have an account? Sign In",
                    style: TextStyle(fontSize: 16, color: Colors.deepPurple),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
