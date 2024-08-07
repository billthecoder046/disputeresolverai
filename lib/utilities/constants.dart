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