
import 'package:disputeresolverai/screens/home/home_view.dart';
import 'package:disputeresolverai/screens/login_screen/login_screen_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var firebase = FirebaseAuth.instance;

checkSignedIn(BuildContext context){
  if(firebase.currentUser != null){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
  }
}