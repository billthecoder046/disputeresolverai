
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../login_screen/login_screen_view.dart';
import 'home_logic.dart';

class HomePage extends StatelessWidget {
  final logic = Get.put(HomeLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Home Screen"),
        actions: [
          IconButton(onPressed: () async{
            var myCo = Get.find<Login_screenLogic>();
            await myCo.logOut();
            myCo.isSignedIn .value = true;
            print("Signed Out successfully");
          }, icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Text("My home Screen"),
      ),
    );
  }
}
