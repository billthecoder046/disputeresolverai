import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../model/message.dart';
import 'logic.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  final String receiverId;
  final String receiverName;

  ChatScreen({required this.chatRoomId, required this.receiverId, required this.receiverName, Key? key})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatLogic chatLogic = Get.put(ChatLogic());
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load initial messages when the widget is built
    _loadMessages();
  }

  void _loadMessages() {
    chatLogic.getMessages(widget.chatRoomId).listen((newMessages) {
      chatLogic.updateMessages(newMessages);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverName),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (chatLogic.messages.isEmpty) {
                return const Center(child: Text('No messages yet.'));
              }
              return ListView.builder(
                reverse: true,
                itemCount: chatLogic.messages.length,
                itemBuilder: (context, index) {
                  Message message = chatLogic.messages[index];
                  bool isMe = message.senderId == chatLogic.myFbAuth.currentUser!.uid;

                  // Message Bubble
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.teal.shade300 : Colors.grey.shade300,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                          bottomLeft: isMe ? Radius.circular(12) : Radius.zero,
                          bottomRight: isMe ? Radius.zero : Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.messageText,
                            style: TextStyle(color: isMe ? Colors.white : Colors.black),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('hh:mm a').format(message.timestamp),
                            style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (messageController.text.trim().isNotEmpty) {
                      chatLogic.sendMessage(
                        widget.chatRoomId,
                        messageController.text.trim(),
                        widget.receiverId,
                      );
                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}