import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTextField extends StatefulWidget {
  TextEditingController myController = TextEditingController();
  String? hintText;
  MyTextField({super.key, required this.myController, this.hintText});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Card(
      elevation: 8.0,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 12),
        width: size.width * .75,
        decoration:
            BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.circular(12.0)
      //           borderRadius: BorderRadius.only(
      //           bottomLeft: Radius.circular(26.0),
      //   topRight: Radius.circular(26.0),
      // )

            ),
        child:  TextField(
          controller: widget.myController,
          decoration: InputDecoration(
            border: InputBorder.none, // Removes the underline
            hintText: widget.hintText??"Enter value",
          ),
        ),
      ),
    );
  }
}
