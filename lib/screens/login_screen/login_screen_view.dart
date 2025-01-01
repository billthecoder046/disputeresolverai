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
        Gap(16),
        Text("Sign In Form",style: MyTextStyles.myTextStyleBlueLarge,),
        const Gap(16),
        MyTextField(myController: logic.emailC, hintText: "Enter Email"),
        Gap(16),
        MyTextField(myController: logic.passC, hintText: "Enter Password"),
        const Gap(16),
        myFirstButton(
          myFunction: () async{
            print("My Email Data: ${logic.emailC.text}");
            print("My Password Data: ${logic.passC.text}");
            await logic.loginUser();
          },
          myButtonWidget: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.ads_click), Gap(6), Text("Signin")],
          ),
        ),
        const Gap(16),
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

        const Gap(16),
        Text("Sign Up Form",style: MyTextStyles.myTextStyleBlueLarge,),
        const Gap(16),

        InkWell(
          onTap: () async {
            if (kIsWeb) {
              if (kDebugMode) {
                print("perform image_picker_web package");
              }
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
              color: Colors.red,
              borderRadius: BorderRadius.circular(100),
            ),
            child: bytesFromPicker == null
                ? const SizedBox()
                : ClipOval(
              child: Image.memory(bytesFromPicker!),
            ),
          ),
        ),
        Gap(16),
        MyTextField(myController: logic.userName, hintText: "Enter Username"),
        Gap(16),
        MyTextField(myController: logic.emailC, hintText: "Enter Email"),
        const Gap(16),
        MyTextField(myController: logic.passC, hintText: "Enter Password"),
        Gap(16),
        myFirstButton(
          myFunction: () async{
            var myFolderName = logic.userName.text;

              String?  myProfileImageUrl = await uploadMyPicture(bytesFromPicker!, "myProfileImages/$myFolderName");

            ///onpressed
            if(myProfileImageUrl !=null){
              await logic.createUserOnFirebase(myProfileImageUrl);
            }else{
              print("Image couldn't be uploaded for some reason");
            }

            print("Thankyou zain");
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



  //This function will upload your image to firebase storage
  Future<String?> uploadMyPicture(Uint8List image, String folderPath, ) async {
    String? myDownloadUrl;

    const String fileName = 'profile.jpg'; // You can customize the filename

    //Get path where you want to upload your profile pic
    final Reference ref =  FirebaseStorage.instance.ref().child(folderPath).child(fileName);

    try {
      //Will upload your bytesImage data on firebase storage
      await ref.putData(image);

      //Will return the file download url link
      String downloadUrl = await ref.getDownloadURL();
      myDownloadUrl = downloadUrl;
      print('MyProfile Image uploaded successfully: $downloadUrl');
    } catch (e) {
      print('Error uploading thumbnail: $e');
    }

    return myDownloadUrl;
  }
}
