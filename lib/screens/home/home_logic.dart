import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../model/users.dart';
import '../chat/view.dart';

class DetailsScreenLogic extends GetxController {
  List<Person> myUsers = [];
  var myFbAuth = FirebaseAuth.instance;
  var myFbFs = FirebaseFirestore.instance;

  // Fetch all users from Firebase
  Future<List<Person>> getUsersOnFirebase() async {
    try {
      QuerySnapshot myAllDocs = await myFbFs.collection('Users').get();
      for (var element in myAllDocs.docs) {
        Person myUser = Person.fromJson(element.data() as Map<String, dynamic>);
        if (!myUsers.any((user) => user.id == myUser.id)) {
          myUsers.add(myUser);
        }
      }
      return myUsers;
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch users: $e");
      return [];
    }
  }

  // Create chat room or navigate to existing one
  Future<void> createChatRoom(String otherUserId, String receiverName) async {
    try {
      String currentUserId = myFbAuth.currentUser!.uid;
      String chatRoomId = currentUserId.hashCode <= otherUserId.hashCode
          ? "$currentUserId-$otherUserId"
          : "$otherUserId-$currentUserId";

      var myChatRoomDoc = await myFbFs.collection('Chatting').doc(chatRoomId).get();

      if (!myChatRoomDoc.exists) {
        // Create new chat room
        await myFbFs.collection('Chatting').doc(chatRoomId).set({
          'chatRoomId': chatRoomId,
          'participants': [currentUserId, otherUserId],
          'timestamp': FieldValue.serverTimestamp(),
        });
        print("Chat room created: $chatRoomId");
      }

      // Navigate to chat screen
      Get.to(() => ChatScreen(
        chatRoomId: chatRoomId,
        receiverId: otherUserId,
        receiverName: receiverName,
      ));
    } catch (e) {
      Get.snackbar("Error", "Failed to create chat room: $e");
    }
  }
}
