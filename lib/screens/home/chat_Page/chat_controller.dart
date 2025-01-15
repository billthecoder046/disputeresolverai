import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final messageController = TextEditingController();
  final RxBool isSending = false.obs;
  final RxBool isTyping = false.obs;
  final focusNode = FocusNode();

  ChatController() {
    messageController.addListener(() {
      if (messageController.text.isNotEmpty) {
        isTyping.value = true;
        updateTypingStatus(true);
      } else {
        isTyping.value = false;
        updateTypingStatus(false);
      }
    });
  }

  Future<void> updateTypingStatus(bool typing) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('typingStatus').doc(user.uid).set({
        'isTyping': typing,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<DocumentSnapshot> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    }
    throw Exception("User not logged in");
  }

  Future<void> sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    isSending.value = true;
    try {
      if (user != null && messageController.text.isNotEmpty) {
        await FirebaseFirestore.instance.collection('msg').add({
          'text': messageController.text.trim(),
          'senderId': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
        });
        messageController.clear();
        focusNode.requestFocus();
      }
    } catch (e) {
      print("Error sending message: $e");
    } finally {
      isSending.value = false;
      updateTypingStatus(false);
    }
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      await FirebaseFirestore.instance.collection('msg').doc(messageId).delete();
    } catch (e) {
      print("Error deleting message: $e");
      Get.snackbar('Error', 'Failed to delete message');
    }
  }


  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
