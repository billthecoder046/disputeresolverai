import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/students.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeLogic logic = Get.put(HomeLogic());
  final TextEditingController _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _showAddByGmailDialog() async {
    _emailCtrl.clear();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Contact by Gmail'),
          content: TextField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter Gmail (e.g. user@gmail.com)',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.person_add),
              label: const Text('Add'),
              onPressed: () async {
                final email = _emailCtrl.text.trim();
                Navigator.pop(context);
                await logic.addContactByEmail(email);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Contacts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          if (currentUser != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Text(
                  currentUser.email ?? '',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ),
          IconButton(
            onPressed: () => logic.signOut(),
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Sign out',
          ),
        ],
      ),

      /// ✅ Real-time list of contacts
      body: StreamBuilder<List<Students>>(
        stream: logic.contactsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple));
          }
          final contacts = snapshot.data ?? [];

          if (contacts.isEmpty) {
            return const Center(
              child: Text(
                'No contacts yet.\nTap the + button to add by Gmail.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, i) {
              final user = contacts[i];

              return Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  onTap: () async {
                    await logic.createChatRoomId(user.id, user.name);
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    child: Text(
                      (user.name.isNotEmpty ? user.name[0] : '?')
                          .toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  subtitle: Text(user.email ?? ''),
                  trailing: const Icon(Icons.chat_bubble_outline),
                ),
              );
            },
          );
        },
      ),

      /// 🔹 Floating Button — Add by Gmail
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text('Add'),
        onPressed: _showAddByGmailDialog,
      ),
    );
  }
}

class HomeLogic extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  var selectedChatRoomId = ''.obs;
  var selectedReceiverId = ''.obs;
  var selectedReceiverName = ''.obs;

  /// 🔹 Real-time contacts
  Stream<List<Students>> contactsStream() {
    final currentUser = auth.currentUser;
    if (currentUser == null) {
      return const Stream<List<Students>>.empty();
    }

    return firestore
        .collection('Students')
        .doc(currentUser.uid)
        .collection('contacts')
        .orderBy('name', descending: false)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) {
        return Students.fromJson(doc.data());
      }).toList();
    });
  }

  /// 🔹 Add contact by Gmail
  Future<void> addContactByEmail(String emailInput) async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        Get.snackbar('Error', 'You are not logged in.');
        return;
      }

      final email = emailInput.trim();
      if (email.isEmpty) {
        Get.snackbar('Error', 'Please enter a Gmail address.');
        return;
      }

      /// 1️⃣ Find the user by email
      QuerySnapshot<Map<String, dynamic>> usersSnap = await firestore
          .collection('Students')
          .where('emailLower', isEqualTo: email.toLowerCase())
          .limit(1)
          .get();

      if (usersSnap.docs.isEmpty) {
        Get.snackbar('Not found', 'No user found with this email.');
        return;
      }

      final doc = usersSnap.docs.first;
      final otherUserId = doc.id;

      /// 2️⃣ Prevent adding yourself
      if (otherUserId == currentUser.uid) {
        Get.snackbar('Oops', 'You cannot add yourself.');
        return;
      }

      /// 3️⃣ Prevent duplicate contact
      final existing = await firestore
          .collection('Students')
          .doc(currentUser.uid)
          .collection('contacts')
          .doc(otherUserId)
          .get();

      if (existing.exists) {
        Get.snackbar('Info', 'This contact already exists.');
        return;
      }

      final userData = doc.data();
      final receiverName = userData['name'] ?? 'User';
      final receiverEmail = userData['email'] ?? email;
      final receiverPhoto = userData['photoUrl'];

      /// 4️⃣ Save contact
      await firestore
          .collection('Students')
          .doc(currentUser.uid)
          .collection('contacts')
          .doc(otherUserId)
          .set({
        'id': otherUserId,
        'name': receiverName,
        'email': receiverEmail,
        'photoUrl': receiverPhoto,
        'addedAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar('Success', '$receiverName added to your contacts.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add contact: $e');
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
      }

      selectedChatRoomId.value = chatRoomId;
      selectedReceiverId.value = otherUserId;
      selectedReceiverName.value = receiverName;

      /// Navigate to chat page (replace with your page)
      // Get.to(ChattingPage(...));
    } catch (e) {
      Get.snackbar('Error', '❌ Failed to create chat room: $e');
    }
  }

  /// 🔹 Sign Out
  Future<void> signOut() async {
    await auth.signOut();
  }
}
