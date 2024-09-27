import 'package:disputeresolverai/model/users.dart';
import 'package:disputeresolverai/screens/commonWidgets/otherWidgets.dart';
import 'package:disputeresolverai/screens/login_screen/login_screen_logic.dart';
import 'package:disputeresolverai/utilities/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_logic.dart';

class HomePage extends StatelessWidget {
  final logic = Get.put(HomeLogic());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("My Home Screen"),
        actions: [
          IconButton(
              onPressed: () async {
                var result = await showDialog(
                    context: context,
                    builder: (context) {
                      return IsSureAlertBox(
                          title: "Signing Out",
                          content: "Are you sure to signout?".tr);
                    });

                if (result == true) {
                  var myCo = Get.find<Login_screenLogic>();
                  await myCo.logOut();
                  myCo.isSignedIn.value = true;
                  if (kDebugMode) {
                    print("Signed Out successfully");
                  }
                  Get.snackbar(
                      MyStrings.success, MyStrings.signedOutSuccessfully);
                }
                // else{
                //   print("Signed Out successfully");
                //   Get.snackbar(MyStrings.success, MyStrings.signedOutSuccessfully);
                // }
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: logic.getUsersFromFirebase(),
            builder: (context, AsyncSnapshot<List<MyUser>> sanaShot) {
              if (sanaShot.hasData) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.all(12),
                  height: size.height * 0.8,
                  // Adjust the height as a proportion
                  width: size.width,
                  // Full width of the screen
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade200,
                  ),
                  child: ListView.builder(
                      itemCount: logic.myUsers.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          trailing: Text(logic.myUsers[i].id,),
                          title: Text(logic.myUsers[i].name),
                          leading: Image.network(
                            logic.myUsers[i].imageUrl ?? "NO Image ",
                          ),
                        );
                      }),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
