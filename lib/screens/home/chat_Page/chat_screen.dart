import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade900, Colors.blueGrey.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/chat_logo.png'),
                    radius: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Chat Screen',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout, color: Colors.white),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ],
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('messages')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error loading messages'));
                    }
                    return ListView.builder(
                      reverse: true,
                      padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final doc = snapshot.data!.docs[index];
                        final isMe = doc['senderId'] ==
                            FirebaseAuth.instance.currentUser?.uid;

                        return Align(
                          alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: GestureDetector(
                            onLongPress: isMe
                                ? () => chatController.deleteMessage(doc.id)
                                : null,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                gradient: isMe
                                    ? LinearGradient(colors: [
                                  Colors.blue.shade400,
                                  Colors.blue.shade300
                                ])
                                    : LinearGradient(colors: [
                                  Colors.grey.shade300,
                                  Colors.grey.shade100
                                ]),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                  bottomLeft: isMe
                                      ? Radius.circular(16)
                                      : Radius.zero,
                                  bottomRight: isMe
                                      ? Radius.zero
                                      : Radius.circular(16),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                doc['text'],
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: chatController.messageController,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) =>
                          chatController.sendMessage(), // Trigger send on Enter
                    ),
                  ),
                  SizedBox(width: 8),
                  Obx(
                        () => CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.blue.shade600,
                      child: chatController.isSending.value
                          ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : IconButton(
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: chatController.isSending.value
                            ? null
                            : chatController.sendMessage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatController extends GetxController {
  final messageController = TextEditingController();
  final RxBool isSending = false.obs;

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
      }
    } catch (e) {
      print("Error sending message: $e");
    } finally {
      isSending.value = false;
    }
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(messageId)
          .delete();
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
