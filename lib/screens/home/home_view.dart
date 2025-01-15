import 'package:disputeresolverai/model/users.dart';
import 'package:disputeresolverai/screens/commonWidgets/otherWidgets.dart';
import 'package:disputeresolverai/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../login_screen/sign_up_screeen_logic.dart';
import 'home_logic.dart';

class HomePage extends StatelessWidget {
  final logic = Get.put(HomeLogic());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:  Text("My Home Screen".tr),
        actions: [
          IconButton(
              onPressed: () async {
                var result = await showDialog(
                    context: context,
                    builder: (context) {
                      return IsSureAlertBox(
                          title: "Signing Out",
                          content: "Are you sure to sign out?".tr);
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
      body: FutureBuilder(
        future: logic.getUsersFromFirebase(),
        builder: (context, AsyncSnapshot<List<Person>> sanaShot) {
          if (sanaShot.hasData) {
            return Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(12),
              height: size.height * 0.8,
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade200,
              ),
              child: ListView.builder(
                itemCount: logic.myPerson.length,
                itemBuilder: (context, i) {
                  DateTime dateTime ;
                  if(logic.myPerson[i].createdAt.runtimeType == int){
                    dateTime  = DateTime.fromMicrosecondsSinceEpoch(logic.myPerson[i].createdAt!);
                  }else{
                    dateTime  = DateTime.parse(logic.myPerson[i].createdAt.toString());
                  }
                  String papuDate = DateFormat('EEEE ,dd MMMM yyyy').format(dateTime);
                  String formattedDate = DateFormat('hh:mm:ss a').format(dateTime);

                  // bool c = a==b;
                  bool isAlreadySignedIn =  logic.myPerson[i].id ==  FirebaseAuth.instance.currentUser!.uid;
                  //Remove duplicate values from list
                  logic.myPerson.toSet().toList();

                  return isAlreadySignedIn == true? Container(): ListTile(
                    onTap: (){
                      logic.createChatRoom(logic.myPerson[i].id);

                    },
                    trailing: Text(
                      logic.myPerson[i].id,
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),

                    title: Text(
                      logic.myPerson[i].name.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("$papuDate $formattedDate"),
                    leading: Container(
                      height: 80,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.red
                      ),
                      child: ClipOval(
                        child: Image.network(
                          logic.myPerson[i].imageUrl ?? "NO Image ",
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}


///