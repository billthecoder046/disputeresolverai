import 'dart:io';
import 'package:disputeresolverai/screens/commonWidgets/buttons.dart';
import 'package:disputeresolverai/screens/commonWidgets/fieldWidgets.dart';
import 'package:disputeresolverai/utilities/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'login_screen_logic.dart';

class Login_screenPage extends StatefulWidget {
  @override
  State<Login_screenPage> createState() => _Login_screenPageState();
}

class _Login_screenPageState extends State<Login_screenPage> {
  final logic = Get.put(Login_screenLogic());
  bool isLoading = false; // Step 1: Add loading state

  @override
  Widget build(BuildContext context) {
    final screenType = ResponsiveBreakpoints.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Center(
              child: screenType.largerThan(TABLET)
                  ? showWebLoginScreen(context)
                  : screenType.largerThan(MOBILE)
                      ? showTabLoginScreen(context)
                      : showMobileLoginScreen(context),
            ),
          ),
          if (isLoading) // Step 2: Show loading indicator when isLoading is true
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
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
      return logic.isSignedIn.value
          ? mySignInForm(context)
          : mySignUpForm(context);
    });
  }

  mySignInForm(context) {
    return Column(
      children: [
        Gap(16),
        Text(
          "Sign In Form",
          style: MyTextStyles.myTextStyleBlueLarge,
        ),
        Container(
            height: 150,
            width: 150,
            child: Image.asset('assets/images/icon.png')),
        Gap(11),
        Text(
          '°•Dispute Resolver Ai•°',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Gap(16),
        MyTextField(myController: logic.emailC, hintText: "Enter Email"),
        Gap(16),
        MyTextField(myController: logic.passC, hintText: "Enter Password"),
        Gap(16),
        myFirstButton(
          myFunction: () async {
            print("My Email Data: ${logic.emailC.text}");
            print("My Password Data: ${logic.passC.text}");
            await logic.loginUser();
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

  Uint8List? bytesFromPicker;

  mySignUpForm(context) {
    return Column(
      children: [
        Gap(16),
        Text(
          "Sign Up Form",
          style: MyTextStyles.myTextStyleBlueLarge,
        ),
        Gap(16),
        InkWell(
          onTap: () async {
            if (kIsWeb) {
              print("perform image_picker_web package");
              bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
              setState(() {});
            } else if (Platform.isAndroid || Platform.isIOS) {
              print("Perform image_picker package");
            }
          },
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.cyanAccent,
              borderRadius: BorderRadius.circular(100),
            ),
            child: bytesFromPicker == null
                ? SizedBox(
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/addicon.png'),
                    ))
                : ClipOval(
                    child: Image.memory(
                      bytesFromPicker!,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
        Gap(16),
        MyTextField(myController: logic.userName, hintText: "Enter Username"),
        Gap(16),
        MyTextField(myController: logic.emailC, hintText: "Enter Email"),
        Gap(16),
        MyTextField(myController: logic.passC, hintText: "Enter Password"),
        Gap(16),
        myFirstButton(
          myFunction: () async {
            setState(() {
              isLoading = true;
            });

            var myFolderName = logic.userName.text;

            String? myProfileImageUrl = await uploadMyPicture(
                bytesFromPicker!, "myProfileImages/$myFolderName");

            //onpressed
            if (myProfileImageUrl != null) {
              await logic.createUserOnFirebase(myProfileImageUrl);
            } else {
              print("Image couldn't be uploaded for some reason");
            }

            setState(() {
              isLoading = false;
            });

            print("Thank you!");
          },
          myButtonWidget: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.ads_click), Gap(6), Text("Signup")],
          ),
        ),
        Gap(16),
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

  // This function will upload your image to Firebase Storage
  Future<String?> uploadMyPicture(
    Uint8List image,
    String folderPath, // Path to the folder in Firebase Storage
  ) async {
    String? myDownloadUrl;

    const String fileName = ''; // You can customize the filename

    // Get path where you want to upload your profile pic
    final Reference ref =
        FirebaseStorage.instance.ref().child(folderPath).child(fileName);

    try {
      // Will upload your bytesImage data on firebase storage
      await ref.putData(image);

      // Will return the file download URL link
      String downloadUrl = await ref.getDownloadURL();
      myDownloadUrl = downloadUrl;
      print('MyProfile Image uploaded successfully: $downloadUrl');
    } catch (e) {
      print('Error uploading thumbnail: $e');
    }
    return myDownloadUrl;
  }
}
