import 'package:disputeresolverai/chatting_page/chatting_page_.dart';
import 'package:disputeresolverai/model/students.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class HomeLogic extends GetxController {
  List<Students> getStudents = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<List<Students>> getUserOnFirebase() async {
    try {
      QuerySnapshot data = await firestore.collection("Students").get();
      for (var element in data.docs) {
        Students students =
            Students.fromJson(element.data() as Map<String, dynamic>);
        getStudents.add(students);
      }
      return getStudents;
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch users: $e");
      return [];
    }
  }

  Future<void> createChatRoomId(String otherUserId, String receiverName,) async {
    try {
      String currentUserId = auth.currentUser!.uid;
      String chatRoomId = currentUserId.hashCode <= otherUserId.hashCode
          ? "$currentUserId-$otherUserId"
          : "$otherUserId-$currentUserId";

      DocumentSnapshot chatRoomDoc =
          await firestore.collection("Chats").doc(chatRoomId).get();

      if (!chatRoomDoc.exists) {
        await firestore.collection('ChatsRoomId').doc(chatRoomId).set({
          'chatRoomId': chatRoomId,
          'participants': [currentUserId, otherUserId],
          'createdAt': FieldValue.serverTimestamp(),
        });
        if (kDebugMode) {
          print("✅ New Chat Room Created: $chatRoomId");
        }
      } else {
        if (kDebugMode) {
          print("⚡ Chat Room Already Exists: $chatRoomId");
        }
      }
      // Navigate to ChatPage
      Get.to(() => ChattingPage(
            chatRoomId: chatRoomId,
            receiverId: otherUserId,
            receiverName: receiverName,
          ));
    } catch (e) {
      Get.snackbar("Error", "❌ Failed to create chat room: $e");
    }
  }

  Future<void> sigout() async {
    await FirebaseAuth.instance.signOut();
  }
}
