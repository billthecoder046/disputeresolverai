import 'package:fchat_app/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error'));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Login();
          }
          return Center(child: SizedBox(height: 36, width: 36, child: CircularProgressIndicator(),),);
        },
      ),
    );
  }
}