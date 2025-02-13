import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../model/message.dart';
import '../../model/person.dart';

class ChatLogic extends GetxController {
  List<Person> myUsers = [];

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
        'timestamp': FieldValue.serverTimestamp(), // Ensure Firestore timestamp
      });
    } catch (e) {
      Get.snackbar(
          'Error', 'Failed to send message: $e'); // Show error to the user
    }
  }

  Stream<List<Message>> getMessages(String chatRoomId) {
    try {
      return myFbFs
          .collection('Chatting')
          .doc(chatRoomId)
          .collection('Messages')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) =>
                  Message.fromJson(doc.data() as Map<String, dynamic>, doc.id))
              .toList());
    } catch (e) {
      Get.snackbar(
          'Error', 'Failed to retrieve messages: $e'); // Show error to the user
      return Stream.empty(); // Return an empty stream if an error occurs
    }
  }

  Future<void> deleteMessage(String chatRoomId, String messageId) async {
    try {
      await myFbFs
          .collection('Chatting')
          .doc(chatRoomId)
          .collection('Messages')
          .doc(messageId)
          .delete();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete message: $e');
    }
  }

  void updateMessages(List<Message> newMessages) {
    messages.value = newMessages; // Update the observable list
  }
}
