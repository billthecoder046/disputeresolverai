import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> setUserOnline(globalChatRoomId) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      await FirebaseFirestore.instance.collection('ChatsRoomId').doc(globalChatRoomId).collection("usersStatus").doc(user.uid).set({
        'isOnline': true,
        'lastSeen': FieldValue.serverTimestamp(),
        // 'isTyping': false, // Set default value for isTyping
      }, SetOptions(merge: true));
      print("User ${user.uid} set to online");
    } catch (e) {
      print("Error setting user online: $e");
    }
  } else {
    print("No user logged in, cannot set online status.");
  }
}