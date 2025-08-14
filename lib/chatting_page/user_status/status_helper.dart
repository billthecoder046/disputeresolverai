// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
//
// class StatusHelper {
//   static Future<void> updateOnlineStatus(bool online) async {
//     final uid = FirebaseAuth.instance.currentUser!.uid; // Or however you access currentUser
//     if (kDebugMode) {
//       print("Setting online status for user $uid to $online");
//     }
//
//     final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
//
//     try {
//       if (online) {
//         // Listen to the document stream
//         userRef.snapshots().listen((snapshot) async {
//           // Inside the listener, update the online status and set onDisconnect
//           await userRef.update({
//             'online': true,
//             'lastSeen': FieldValue.serverTimestamp(),
//           });
//
//           // Set onDisconnect to set offline status when the user disconnects
//           await userRef.set(
//               {'online': false, 'lastSeen': FieldValue.serverTimestamp()},
//               SetOptions(merge: true));
//           if (kDebugMode) {
//             print("onDisconnect set successfully");
//           }
//
//           if (kDebugMode) {
//             print("Online status updated successfully, onDisconnect set");
//           }
//         });
//       } else {
//         // When setting offline, no need for stream or onDisconnect
//         await userRef.set({
//           'online': false,
//           'lastSeen': FieldValue.serverTimestamp(),
//         }, SetOptions(merge: true));
//         if (kDebugMode) {
//           print("Offline status updated successfully");
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print("Error updating online status: $e");
//       }
//     }
//   }
//
//   static Future<void> setTyping(bool isTyping) async {
//     final uid = FirebaseAuth.instance.currentUser!.uid; // Or however you access currentUser
//
//     try {
//       await FirebaseFirestore.instance.collection('users').doc(uid).set({
//         'typing': isTyping,
//       }, SetOptions(merge: true));
//       if (kDebugMode) {
//         print("Typing status updated successfully in Firestore.");
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print("Error setting typing status: $e");
//       }
//     }
//   }
// }