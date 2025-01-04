import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController
{
  final messageController = TextEditingController();
  final RxBool isSending = false.obs;
  final focusNode = FocusNode();

  Future<void> sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    isSending.value = true;
    try {
      if (user != null && messageController.text.isNotEmpty) {
        await FirebaseFirestore.instance.collection('messages').add({
          'text': messageController.text.trim(),
          'senderId': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
        });
        messageController.clear();
        focusNode.requestFocus(); // TextField پر دوبارہ فوکس کریں
      }
    } catch (e) {
      print("Error sending message: $e");
    } finally {
      isSending.value = false;
    }
  }


  Future<void> deleteMessage(String messageId) async {
    try {
      await FirebaseFirestore.instance.collection('messages').doc(messageId).delete();
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