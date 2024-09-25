import 'package:disputeresolverai/screens/commonWidgets/otherWidgets.dart';
import 'package:disputeresolverai/screens/login_screen/login_screen_logic.dart';
import 'package:disputeresolverai/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_logic.dart';

class HomePage extends StatelessWidget {
  final logic = Get.put(HomeLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("My Home Screen"),
        actions: [
          IconButton(onPressed: () async{
            var result = await showDialog(context: context, builder: (context){
              return IsSureAlertBox(title: "Signing Out", content:"Are you sure to signout?".tr );
            });

            if(result == true){
              var myCo = Get.find<Login_screenLogic>();
              await myCo.logOut();
              myCo.isSignedIn .value = true;
              print("Signed Out successfully");
              Get.snackbar(MyStrings.success, MyStrings.signedOutSuccessfully);
            }
            // else{
            //   print("Signed Out successfully");
            //   Get.snackbar(MyStrings.success, MyStrings.signedOutSuccessfully);
            // }





            //



          }, icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Card(
                elevation: 100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                shadowColor: Colors.black,
                child: Container(
                  width: 300,
                  height: 200,
                  padding: const EdgeInsets.all(16),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'This is an elevated card',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'The card has an elevation of 100, a shadow color, and rounded corners.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                shadowColor: Colors.black,
                child: Container(
                  width: 300,
                  height: 200,
                  padding: const EdgeInsets.all(16),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'This is an elevated card',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'The card has an elevation of 100, a shadow color, and rounded corners.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                shadowColor: Colors.black,
                child: Container(
                  width: 300,
                  height: 200,
                  padding: const EdgeInsets.all(16),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'This is an elevated card',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'The card has an elevation of 100, a shadow color, and rounded corners.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                shadowColor: Colors.black,
                child: Container(
                  width: 300,
                  height: 200,
                  padding: const EdgeInsets.all(16),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'This is an elevated card',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'The card has an elevation of 100, a shadow color, and rounded corners.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
