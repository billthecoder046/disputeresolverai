import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTextField extends StatefulWidget {
  TextEditingController myController = TextEditingController();
  String? hintText;
  bool isPasswordField;

  MyTextField(
      {super.key,
      required this.myController,
      this.hintText,
      this.isPasswordField = false,});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _isObscured = true; // This controls password visibility

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Card(
      elevation: 8.0,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 12),
        width: size.width * .75,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12.0)),
        child: TextField(
          obscuringCharacter: '*',
          controller: widget.myController,
          obscureText: widget.isPasswordField ? _isObscured : false,
          // Show/hide password
          decoration: InputDecoration(
            border: InputBorder.none, // Removes the underline
            hintText: widget.hintText ?? "Enter value",
            suffixIcon: widget.isPasswordField
                ? IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured =
                            !_isObscured; // Toggle password visibility
                      });
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
