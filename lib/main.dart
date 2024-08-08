import 'package:disputeresolverai/screens/login_screen/login_screen_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyRootWidget());
}
class MyRootWidget extends StatelessWidget {
  const MyRootWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dispute Resolver AI',
       debugShowCheckedModeBanner: false,

       builder: (context, child) => ResponsiveBreakpoints.builder(
      child: child!,
      breakpoints: [
        const Breakpoint(start: 0, end: 550, name: MOBILE),
        const Breakpoint(start: 551, end: 1000, name: TABLET),
        const Breakpoint(start: 1001, end: 1920, name: DESKTOP),
        const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
      ],
    ),
      home: Login_screenPage(),
    );
  }
}

