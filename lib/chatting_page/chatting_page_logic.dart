import 'dart:io';

import 'package:disputeresolverai/model/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'group_chat_screen.dart';

class ChattingPageLogic extends GetxController {
  var messages = <Messages>[].obs;
  List<String> selectedUserIds = [];
  final FirebaseStorage storage = FirebaseStorage.instance;
  TextEditingController groupNameController = TextEditingController();
  final FirebaseFirestore myFbFs = FirebaseFirestore.instance;
  final FirebaseAuth myFbAuth = FirebaseAuth.instance;

  Future<void> sendMessage(
      String chatRoomId, String receiverId, String messageText) async {
    try {
      String senderId = myFbAuth.currentUser!.uid;
      await myFbFs
          .collection('Chatting') // Ensure this collection exists in Firebase
          .doc(chatRoomId)
          .collection('Messages')
          .add({
        'senderId': senderId,
        'messageText': messageText,
        'receiverId': receiverId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message: $e');
    }
  }

  saveGroup() async {
    if (groupNameController.text.isEmpty || selectedUserIds.isEmpty) {
      Get.snackbar("Error", "Group name & users required!");
      return;
    }
    String groupId = FirebaseFirestore.instance.collection('Groups').doc().id;
    selectedUserIds.add(FirebaseAuth.instance.currentUser!.uid);

    await FirebaseFirestore.instance.collection('Groups').doc(groupId).set({
      'groupName': groupNameController.text,
      'members': selectedUserIds,
      'createdAt': FieldValue.serverTimestamp(),
    });

    Get.off(() => GroupChatScreen(groupId: groupId));
  }

  Stream<List<Messages>> getMessages(String chatRoomId) {
    try {
      return myFbFs
          .collection('Chatting')
          .doc(chatRoomId)
          .collection('Messages')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) =>
                  Messages.fromJson(doc.data() as Map<String, dynamic>, doc.id))
              .toList());
    } catch (e) {
      print('Error fetching messages: $e');
      return Stream.value([]);
    }
  }

  void updateMessages(List<Messages> newMessages) {
    messages.value = newMessages;
  }
}
