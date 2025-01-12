import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chat_controller.dart';

class ChatScreen extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1E3C72), // Professional dark blue
              Color(0xFF2A5298),
              Color(0xFF3B8D99), // Teal accent
            ],
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
                  return Column(
                    children: [
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('typingStatus')
                            .snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> typingSnapshot) {
                          if (typingSnapshot.hasData) {
                            final typingUsers = typingSnapshot.data!.docs
                                .where((doc) => doc['isTyping'] == true && doc.id != FirebaseAuth.instance.currentUser?.uid)
                                .toList();

                            if (typingUsers.isNotEmpty) {
                              return Text(
                                "Someone is typing...",
                                style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                              );
                            }
                          }
                          return SizedBox.shrink();
                        },
                      ),
                      Expanded(
                        child: ListView.builder(
                          reverse: true,
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final doc = snapshot.data!.docs[index];
                            final isMe = doc['senderId'] == FirebaseAuth.instance.currentUser?.uid;
                            final timestamp = doc['timestamp'] != null
                                ? (doc['timestamp'] as Timestamp).toDate()
                                : DateTime.now();

                            return Align(
                              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment:
                                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onLongPress: isMe ? () => chatController.deleteMessage(doc.id) : null,
                                    child: AnimatedOpacity(
                                      opacity: 1.0,
                                      duration: Duration(milliseconds: 500),
                                      child: Container(
                                        margin: EdgeInsets.symmetric(vertical: 8),
                                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                        decoration: BoxDecoration(
                                          gradient: isMe
                                              ? LinearGradient(colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)])
                                              : LinearGradient(
                                              colors: [Colors.grey.shade300, Colors.grey.shade100]),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                            bottomLeft: isMe ? Radius.circular(16) : Radius.zero,
                                            bottomRight: isMe ? Radius.zero : Radius.circular(16),
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
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')} ${timestamp.hour >= 12 ? 'PM' : 'AM'}', // Format the time
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                    ],
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.shade200,
                    Colors.grey.shade100,
                  ],
                ),
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
                        fillColor: Colors.white,
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => chatController.sendMessage(),
                    ),
                  ),
                  SizedBox(width: 8),
                  Obx(
                        () => CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFF1E88E5),
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
