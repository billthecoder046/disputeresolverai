import 'package:disputeresolverai/screens/home/home_view.dart';
import 'package:disputeresolverai/screens/login_screen/login_screen_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator while waiting
        } else if (snapshot.hasData) {
          return HomePage(); // User is logged in
        } else {
          return Login_screenPage(); // User is not logged in
        }
      },
    );
  }
}
