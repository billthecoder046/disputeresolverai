import 'package:disputeresolverai/screens/commonWidgets/buttons.dart';
import 'package:disputeresolverai/screens/commonWidgets/fieldWidgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'login_screen_logic.dart';

class Login_screenPage extends StatelessWidget {
  final logic = Get.put(Login_screenLogic());

  @override
  Widget build(BuildContext context) {
    final screenType = ResponsiveBreakpoints.of(context);
    return Scaffold(
      body: Container(
        color: Colors.yellow,
        child: Center(
          child: screenType.largerThan(TABLET)
              ? showWebLoginScreen(context)
              : screenType.largerThan(MOBILE)
              ? showTabLoginScreen(context)
              : showMobileLoginScreen(context),
        ),
      ),
    );
  }

  showMobileLoginScreen(BuildContext context) {
    return myForm(context);
  }

  showWebLoginScreen(context) {
    return myForm(context);
  }

  showTabLoginScreen(context) {
    return myForm(context);
  }

  myForm(context){
    return   Column(
      children: [
        Gap(16),
        MyTextField(
            myController: logic.emailC,
            hintText: "Enter Email"
        ),
        Gap(16),
        MyTextField(
          myController: logic.passC,
          hintText: "Enter Password"
        ),
        Gap(16),
        myFirstButton(
          myFunction: () {
            print("My Email Data: ${logic.emailC.text}");
            print("My Password Data: ${logic.passC.text}");
          },
          myButtonWidget: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.ads_click),
              Gap(6),
              Text("Signin")
            ],
          ),

        )

      ],
    );
  }

}
