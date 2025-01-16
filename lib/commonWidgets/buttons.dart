import 'package:flutter/material.dart';

class myFirstButton extends StatelessWidget {
  VoidCallback myFunction;
  Widget myButtonWidget;
  myFirstButton({super.key,required this.myFunction,required this.myButtonWidget});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      width: size.width * 0.75,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
          elevation: 5, // Elevation
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
              // borderRadius: BorderRadius.only(
              //   bottomLeft: Radius.circular(26.0),
              //   topRight: Radius.circular(26.0),
              // )
          ),
          shadowColor: Colors.black, // Shadow color
        ),
      onPressed: myFunction,
        child: myButtonWidget,

      ),
    );
  }
}
