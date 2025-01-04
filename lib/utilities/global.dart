

import 'package:disputeresolverai/login_screen/view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/home/home_view.dart';

var firebase = FirebaseAuth.instance;
checkSignedIn(BuildContext context){
  if(firebase.currentUser !=null){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home_screenPage()));
  }

}
