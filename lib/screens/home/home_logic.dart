import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disputeresolverai/model/users.dart';
import 'package:get/get.dart';

class HomeLogic extends GetxController {
  List<MyUser> myUsers = [];

  //Fetch all user documents from firebase
  //Convert each document of user into MyUser Object
  //Save each user into the list of myUsers list
  //Then simply use this myUsers list to show the users on HomePage
  getUsersFromFirebase() async {
    QuerySnapshot myAllDocuments =
        await FirebaseFirestore.instance.collection("Users").get();
    for (var element in myAllDocuments.docs) {
      MyUser myUser = MyUser.fromJson(element.data() as Map<String, dynamic>);
      myUsers.add(myUser);
    }
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await getUsersFromFirebase();
    myUsers.forEach((e) {
      print(e.name);
    });
  }
}
