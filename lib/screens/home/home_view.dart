import 'package:disputeresolverai/model/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../commonWidgets/otherWidgets.dart';
import '../login_screen/login_screen_logic.dart';
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
        title: Text("My Home Screen".tr),
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
                  Get.snackbar("Success", "Signed Out Successfully");
                }
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: FutureBuilder(
        future: logic.getUsersFromFirebase(),
        builder: (context, AsyncSnapshot<List<MyUser>> sanaShot) {
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
                itemCount: logic.myUsers.length,
                itemBuilder: (context, i) {
                  DateTime dateTime;
                  if (logic.myUsers[i].createdAt.runtimeType == int) {
                    dateTime = DateTime.fromMicrosecondsSinceEpoch(
                        logic.myUsers[i].createdAt!);
                  } else {
                    dateTime =
                        DateTime.parse(logic.myUsers[i].createdAt.toString());
                  }
                  String papuDate =
                  DateFormat('EEEE ,dd MMMM yyyy').format(dateTime);
                  String formattedDate =
                  DateFormat('hh:mm:ss a').format(dateTime);

                  // Get current user
                  MyUser currentUser = MyUser(id: FirebaseAuth.instance.currentUser!.uid, name: '', imageUrl: '');

                  return FirebaseAuth.instance.currentUser!.uid == logic.myUsers[i].id
                      ? Container()
                      : ListTile(
                    onTap: () {
                      // Get selected user
                      MyUser selectedUser = logic.myUsers[i];

                      // Generate chatId using getChatId
                      String chatId = getChatId(currentUser, selectedUser);

                      // Navigate to ChatScreen with chatId and selectedUser data
                      Get.to(
                            () => HomePage(),
                        arguments: {
                          "selectedUser": selectedUser,
                          "chatId": chatId,
                        },
                      );
                    },
                    trailing: Text(
                      logic.myUsers[i].id,
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    title: Text(
                      logic.myUsers[i].name.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.indigo, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("$papuDate $formattedDate"),
                    leading: Container(
                      height: 80,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.red),
                      child: ClipOval(
                        child: Image.network(
                          logic.myUsers[i].imageUrl ?? "NO Image",
                          fit: BoxFit.cover,
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

  String getChatId(MyUser user1, MyUser user2) {
    return user1.id.compareTo(user2.id) < 0
        ? "${user1.id}_${user2.id}"
        : "${user2.id}_${user1.id}";
  }
}
