import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'login_screen_logic.dart';

class Login_screenPage extends StatelessWidget {
  final logic = Get.put(Login_screenLogic());

  @override
  Widget build(BuildContext context) {
    final screenType = ResponsiveBreakpoints.of(context);
    return Container(
      color: Colors.yellow,
      child: Center(
        child: screenType.largerThan(MOBILE)
            ? showWebLoginScreen()
            : screenType.smallerThan(TABLET)
            ? showTabLoginScreen()
            : showMobileLoginScreen(),
      ),
    );
  }

  showMobileLoginScreen() {
    return const Text("My Mobile Screen");
  }

  showWebLoginScreen() {
    return const Text("My Web Login Screen");
  }

  showTabLoginScreen() {
    return const Text("My Tab Login Screen");
  }
}
