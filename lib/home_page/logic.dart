// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import '../chatting_page/chatting_page_view.dart';
// import '../model/students.dart';
//
//
// class HomeLogic extends GetxController {
//   var getStudents = <Students>[].obs;
//
//   var currentUserId;
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final FirebaseAuth auth = FirebaseAuth.instance;
//
//   // ✅ Global Chat Info to be used in Dashboard
//   var selectedChatRoomId = ''.obs;
//   var selectedReceiverId = ''.obs;
//   var selectedReceiverName = ''.obs;
//
//   Future<List<Students>> getUserOnFirebase() async {
//     try {
//       QuerySnapshot data = await firestore.collection("Students").get();
//       for (var element in data.docs) {
//         Students students =
//         Students.fromJson(element.data() as Map<String, dynamic>);
//         getStudents.add(students);
//       }
//       return getStudents;
//     } catch (e) {
//       Get.snackbar("Error", "Failed to fetch users: $e");
//       return [];
//     }
//   }
//
//   Future<void> createChatRoomId(String otherUserId, String receiverName) async {
//     try {
//       if (auth.currentUser == null || otherUserId.isEmpty) {
//         Get.snackbar("Error", "❌ User ID is missing!");
//         return;
//       }
//
//       String currentUserId = auth.currentUser!.uid;
//       String chatRoomId = currentUserId.hashCode <= otherUserId.hashCode
//           ? "$currentUserId-$otherUserId"
//           : "$otherUserId-$currentUserId";
//
//       print('Creating chat room with ID: $chatRoomId');
//
//       DocumentSnapshot chatRoomDoc =
//       await firestore.collection("ChatsRoomId").doc(chatRoomId).get();
//
//       if (!chatRoomDoc.exists) {
//         await firestore.collection('ChatsRoomId').doc(chatRoomId).set({
//           'chatRoomId': chatRoomId,
//           'participants': [currentUserId, otherUserId],
//           'createdAt': FieldValue.serverTimestamp(),
//         });
//       }
//   Get.to(ChattingPage(chatRoomId: chatRoomId, receiverName: receiverName, receiverId: otherUserId));
//       // ✅ Save chat data globally
//       selectedChatRoomId.value = chatRoomId;
//       selectedReceiverId.value = otherUserId;
//       selectedReceiverName.value = receiverName;
//
//       // ✅ ONLY navigate if all values are set
//       if (selectedChatRoomId.value.isNotEmpty &&
//           selectedReceiverId.value.isNotEmpty &&
//           selectedReceiverName.value.isNotEmpty) {
//         // Get.find<DashboardLogic>().selectedScreenIndex.value = 6;
//       } else {
//         print("❌ Some chat data is still missing");
//         Get.snackbar("Error", "⚠️ Failed to open chat. Try again.");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "❌ Failed to create chat room: $e");
//     }
//   }
//
//   Future<void> signOut() async {
//     await FirebaseAuth.instance.signOut();
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disputeresolverai/chatting_page/chatting_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../model/students.dart';

class HomeLogic extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  var selectedChatRoomId = ''.obs;
  var selectedReceiverId = ''.obs;
  var selectedReceiverName = ''.obs;

  /// 🔹 Real-time contacts stream
  Stream<List<Students>> contactsStream() {
    final currentUser = auth.currentUser;
    if (currentUser == null) {
      return const Stream<List<Students>>.empty();
    }

    return firestore
        .collection('Students')
        .doc(currentUser.uid)
        .collection('contacts')
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) {
        return Students.fromJson(doc.data());
      }).toList();
    });
  }

  /// 🔹 Add contact by Gmail
  /// 🔹 Add contact by Gmail
  Future<void> addContactByEmail(String contactEmail) async {
    try {
      if (contactEmail.isEmpty) {
        Get.snackbar('Error', 'Please enter an email');
        return;
      }

      // Check if user exists in Students collection
      var snapshot = await firestore
          .collection('Students')
          .where('email', isEqualTo: contactEmail)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var contactData = snapshot.docs.first.data();

        // ✅ Add contact inside Students → currentUser → contacts
        await firestore
            .collection('Students')
            .doc(auth.currentUser!.uid)
            .collection('contacts')
            .doc(contactData['id'])
            .set(contactData);

        Get.snackbar('Success', 'Contact added successfully');
      } else {
        Get.snackbar('Not Found', 'This user is not registered');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Something went wrong');
    }
  }

  /// 🔹 Create chat room
  Future<void> createChatRoomId(String otherUserId, String receiverName) async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null || otherUserId.isEmpty) {
        Get.snackbar('Error', '❌ User ID is missing!');
        return;
      }

      final myId = currentUser.uid;
      final chatRoomId = myId.hashCode <= otherUserId.hashCode
          ? '$myId-$otherUserId'
          : '$otherUserId-$myId';

      final chatRoomDoc =
      await firestore.collection('ChatsRoomId').doc(chatRoomId).get();

      if (!chatRoomDoc.exists) {
        await firestore.collection('ChatsRoomId').doc(chatRoomId).set({
          'chatRoomId': chatRoomId,
          'participants': [myId, otherUserId],
          'createdAt': FieldValue.serverTimestamp(),
        });

        // ✅ Update contacts for both users with lastMessageTime
        var myData = (await firestore.collection('Students').doc(myId).get()).data();
        var otherData = (await firestore.collection('Students').doc(otherUserId).get()).data();

        if (myData != null && otherData != null) {
          await firestore.collection('Students').doc(myId)
              .collection('contacts')
              .doc(otherUserId)
              .set({...otherData, 'lastMessageTime': FieldValue.serverTimestamp()});

          await firestore.collection('Students').doc(otherUserId)
              .collection('contacts')
              .doc(myId)
              .set({...myData, 'lastMessageTime': FieldValue.serverTimestamp()});
        }
      }

      selectedChatRoomId.value = chatRoomId;
      selectedReceiverId.value = otherUserId;
      selectedReceiverName.value = receiverName;

      Get.to(ChattingPage(
        chatRoomId: chatRoomId,
        receiverName: receiverName,
        receiverId: otherUserId,
      ));
    } catch (e) {
      Get.snackbar('Error', '❌ Failed to create chat room: $e');
    }
  }

  /// 🔹 Sign Out
  Future<void> signOut() async {
    await auth.signOut();
    Get.back();
  }
}
