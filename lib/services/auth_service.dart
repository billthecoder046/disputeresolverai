import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/home/home_view.dart';
import '../screens/signup_screen/sign_up_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
// ok
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return Home_screenPage();
        } else {
          return const SignUpScreen();
        }
      },
    );
  }
}
