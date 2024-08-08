import 'package:disputeresolverai/screens/commonWidgets/buttons.dart';
import 'package:disputeresolverai/screens/commonWidgets/fieldWidgets.dart';
import 'package:disputeresolverai/utilities/constants.dart';
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

  myForm(context) {
    return Obx(() {
      return logic.isSignedIn.value ? mySignInForm(context) : mySignUpForm(context);
    });
  }

  mySignInForm(context) {
    return Column(
      children: [
        const Gap(16),
        Text("Sign In Form",style: MyTextStyles.myTextStyleBlueLarge,),
        Gap(16),
        MyTextField(myController: logic.emailC, hintText: "Enter Email"),
        Gap(16),
        MyTextField(myController: logic.passC, hintText: "Enter Password"),
        Gap(16),
        myFirstButton(
          myFunction: () async{
            print("My Email Data: ${logic.emailC.text}");
            print("My Password Data: ${logic.passC.text}");
            await logic.signInUserOnApp();

          },
          myButtonWidget: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.ads_click), Gap(6), Text("Signin")],
          ),
        ),
        Gap(16),
        TextButton(
            onPressed: () {
              logic.isSignedIn.value = !logic.isSignedIn.value;
            },
            child: Text(
              "Not Signed In? SignUP!",
              style: MyTextStyles.myTextStyleBlueMedium,
            ))
      ],
    );
  }

  mySignUpForm(context) {
    return Column(
      children: [

        Gap(16),
        Text("Sign Up Form",style: MyTextStyles.myTextStyleBlueLarge,),
        Gap(16),
        MyTextField(myController: logic.userName, hintText: "Enter Username"),
        Gap(16),
        MyTextField(myController: logic.emailC, hintText: "Enter Email"),
        Gap(16),
        MyTextField(myController: logic.passC, hintText: "Enter Password"),
        Gap(16),
        myFirstButton(
          myFunction: () async{
            print("My Email Data: ${logic.emailC.text}");
            print("My Password Data: ${logic.passC.text}");
            print("My Username: ${logic.userName.text}");
            ///onpressed
            await logic.createUserOnFirebase();
            print("Thankyou zain");
          },
          myButtonWidget: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.ads_click), Gap(6), Text("Signup")],
          ),
        ),
        const Gap(16),
        TextButton(
            onPressed: () {
              logic.isSignedIn.value = !logic.isSignedIn.value;
            },
            child: Text(
              "Already Signed UP? SignIn!",
              style: MyTextStyles.myTextStyleBlueMedium,
            ))
      ],
    );
  }
}
