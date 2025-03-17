import 'package:disputeresolverai/login_screen/sign-up_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../home_page/view.dart';
import 'logic.dart';

class SignIn_page extends StatefulWidget {
  SignIn_page({Key? key}) : super(key: key);

  @override
  State<SignIn_page> createState() => _SignIn_pageState();
}

class _SignIn_pageState extends State<SignIn_page> {
  final Login_pageLogic logic = Get.put(Login_pageLogic());
  bool _isObscure = true;

  Future<void> _initialize() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("My user is not null");
      Future.delayed(const Duration(seconds: 2));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

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
                Container(
                  height: 200,
                  width: 200,
                  child: Lottie.network(
                    'https://lottie.host/230db473-bae4-4f7b-b597-5466e1072f60/74TD71RDUh.json',
                  ),
                ),
                const Text(
                  "Sign-In",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.red,
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
                      prefixIcon: Icon(Icons.email, color: Colors.red),
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
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      hintText: "Enter Password",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.lock, color: Colors.red),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const Gap(30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => logic.signIn(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Gap(20),
                TextButton(
                  onPressed: () => Get.to(SignUp()),
                  child: const Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(fontSize: 16, color: Colors.red),
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
