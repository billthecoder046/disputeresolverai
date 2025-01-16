import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../model/message.dart';

class ChatLogic extends GetxController {
  var messages = <Message>[].obs;
  final myFbFs = FirebaseFirestore.instance;
  final myFbAuth = FirebaseAuth.instance;

  Future<void> sendMessage(
      String chatRoomId, String messageText, String receiverId) async {
    try {
      String senderId = myFbAuth.currentUser!.uid;

      await myFbFs
          .collection('Chatting')
          .doc(chatRoomId)
          .collection('Messages')
          .add({
        'senderId': senderId,
        'receiverId': receiverId,
        'messageText': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message: $e');
    }
  }

  void loadMessages(String chatRoomId) {
    getMessages(chatRoomId).listen((newMessages) {
      messages.value = newMessages;
    });
  }

  Stream<List<Message>> getMessages(String chatRoomId) {
    return myFbFs
        .collection('Chatting')
        .doc(chatRoomId)
        .collection('Messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Message.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }
}
