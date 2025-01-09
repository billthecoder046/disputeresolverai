import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../model/users.dart';
import 'chat_Page/chat_screen.dart';

class Details_screenLogic extends GetxController {
  List<Person> myAllStudets = [];
  var myFbIns = FirebaseAuth.instance;
  var myFbFs = FirebaseFirestore.instance;

  Future<List<Person>> getUsersOnFirebase() async {
    QuerySnapshot myalldocs =
        await FirebaseFirestore.instance.collection('Persons').get();
    for (var elements in myalldocs.docs) {
      Person myStudent =
          Person.fromJson(elements.data() as Map<String, dynamic>);
      myAllStudets.add(myStudent);
    }
    return myAllStudets;
  }

  Future<void> createChatRoom(String otherUserId) async {
    String chatRoomId = "${myFbIns.currentUser!.uid}-$otherUserId";
    print(chatRoomId);
    var myChatRoomDoc =
        await myFbFs.collection('Chating').doc(chatRoomId).get();

    if (myChatRoomDoc.exists) {
      //Navigate chat Screen
      Get.to(ChatScreen());
    } else {
      await myFbFs
          .collection('Chating')
          .doc(chatRoomId)
          .set({'chatRoomId': chatRoomId, 'timeStamp': DateTime.now()}).then(
              (value) {
        print("Collection was created");
      });
      //Navigate
      Get.to(ChatScreen());
    }
  }
}
