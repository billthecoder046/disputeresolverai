import 'dart:ui';
/// ok kar yaar
///
import 'package:flutter/material.dart';

class MyTextStyles{



  static var myTextStyleBlueLarge = TextStyle(color: Colors.blue, fontSize: Sizes.myFontSizeLarge,fontWeight: FontWeight.bold);
  static var myTextStyleBlueMedium = TextStyle(color: Colors.blue, fontSize: Sizes.myFontSizeMedium);
  static var myTextStyleBlueSmall = TextStyle(color: Colors.blue, fontSize: Sizes.myFontSizeSmall);
}

class Sizes{
  static var myFontSizeLarge = 24.0;
  static var myFontSizeMedium = 14.0;
  static var myFontSizeSmall = 10.0;
}

class MyStrings {
  static const String userCantLogin = "User can't login";
  static const String someErrorOccurred = "Some error occurred";
  static const String invalidCredentials = "Invalid credentials";
  static const String networkError = "Network error";
  static const String serverError = "Server error";
  static const String unauthorizedAccess = "Unauthorized access";
  static const String sessionExpired = "Session expired";
  static const String unknownError = "Unknown error";
  static const String loading = "Loading...";
  static const String success = "Success";
  static const String failure = "Failure";
  static const String retry = "Retry";
  static const String cancel = "Cancel";
  static const String ok = "OK";
  static const String yes = "Yes";
  static const String no = "No";
  static const String pleaseWait = "Please wait...";
  static const String signedOutSuccessfully = "Signed Out successfully";
  static const String signedInSuccessfully = "Signed In successfully";

}