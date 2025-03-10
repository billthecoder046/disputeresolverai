

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../model/message.dart';
import 'logic.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  final String receiverId;
  final String receiverName;

  ChatScreen({
    required this.chatRoomId,
    required this.receiverId,
    required this.receiverName,
    Key? key,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatLogic chatLogic = Get.put(ChatLogic());
  final TextEditingController messageController = TextEditingController();
  bool isSelectionMode = false;
  Set<String> selectedMessages = {};

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    chatLogic.getMessages(widget.chatRoomId).listen((newMessages) {
      chatLogic.updateMessages(newMessages);
    });
  }

  void _toggleSelection(String messageId) {
    setState(() {
      if (selectedMessages.contains(messageId)) {
        selectedMessages.remove(messageId);
      } else {
        selectedMessages.add(messageId);
      }
      if (selectedMessages.isEmpty) {
        isSelectionMode = false;
      }
    });
  }

  void _deleteSelectedMessages() {
    for (var messageId in selectedMessages) {
      chatLogic.deleteMessage(widget.chatRoomId, messageId);
    }
    setState(() {
      selectedMessages.clear();
      isSelectionMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        title: isSelectionMode
            ? Text('${selectedMessages.length} selected')
            : Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/profile_placeholder.png'),
              radius: 24,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.receiverName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18, // Reduced from 20
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (isSelectionMode)
            IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: _deleteSelectedMessages,
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 100),
            Expanded(
              child: Obx(() {
                if (chatLogic.messages.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet.',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  );
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: chatLogic.messages.length,
                  itemBuilder: (context, index) {
                    Message message = chatLogic.messages[index];
                    bool isMe =
                        message.senderId == chatLogic.myFbAuth.currentUser!.uid;
                    return Align(
                      alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: GestureDetector(
                        onLongPress: () {
                          if (isMe) {
                            setState(() {
                              isSelectionMode = true;
                              _toggleSelection(message.id);
                            });
                          }
                        },
                        onTap: () {
                          if (isSelectionMode && isMe) {
                            _toggleSelection(message.id);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          constraints: BoxConstraints(
                            maxWidth:
                            MediaQuery.of(context).size.width * 0.6,
                          ),
                          decoration: BoxDecoration(
                            color: selectedMessages.contains(message.id)
                                ? Colors.blue.withOpacity(0.5)
                                : (isMe ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.1)),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: isMe ? Radius.circular(12) : Radius.zero,
                              bottomRight: isMe ? Radius.zero : Radius.circular(12),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 2,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),

                          child: Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.messageText,
                                style: TextStyle(
                                  color: isMe ? Colors.black : Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                DateFormat('hh:mm a').format(message.timestamp),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isMe ? Colors.black54 : Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0), // Reduced padding
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)), // Reduced from 20
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8, // Reduced from 10
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          chatLogic.sendMessage(
                            widget.chatRoomId,
                            value.trim(),
                            widget.receiverId,
                          );
                          messageController.clear();
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        hintText: 'Your Message',
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10), // Reduced padding
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24), // Reduced from 30
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6), // Reduced from 8
                  GestureDetector(
                    onTap: () {
                      if (messageController.text.trim().isNotEmpty) {
                        chatLogic.sendMessage(
                          widget.chatRoomId,
                          messageController.text.trim(),
                          widget.receiverId,
                        );
                        messageController.clear();
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: Color(0xFF6A11CB),
                      radius: 22,
                      child: Icon(Icons.send, color: Colors.white, size: 18),
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
