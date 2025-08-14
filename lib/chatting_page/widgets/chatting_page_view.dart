import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../firebase_utils.dart';
import '../../globalvariables.dart';
import '../../model/messages.dart';
import '../user_status/msgAnim_Icon.dart';
import 'appbar.dart';
import 'chatting_page_logic.dart';
import 'message_input_field.dart';

class AdminChattingPage extends StatefulWidget {
  final String chatRoomId;
  final String receiverId;
  final String receiverName;

  AdminChattingPage({
    Key? key,
    required this.chatRoomId,
    required this.receiverName,
    required this.receiverId,
  }) : super(key: key);

  @override
  State<AdminChattingPage> createState() => _AdminChattingPageState();
}

class _AdminChattingPageState extends State<AdminChattingPage>
    with WidgetsBindingObserver {
  final AdminChattingPageLogic logic = Get.put(AdminChattingPageLogic());
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    globalChatRoomId = widget.chatRoomId;
    print(
      'ChattingPage initialized with chatRoomId: ${widget.chatRoomId}',
    );
    WidgetsBinding.instance.addObserver(this);
    setUserOnline(globalChatRoomId);

    // Load messages after setting up the listener
    _loadMessages();
  }

  @override
  void dispose() {
    logic.setUserOffline();
    WidgetsBinding.instance.removeObserver(this);
    _typingTimer?.cancel();
    Get.delete<AdminChattingPageLogic>();
    super.dispose();
  }

  // Load messages from the database
  void _loadMessages() {
    logic.getMessages(widget.chatRoomId).listen((newMessages) {
      // Check if the messages list has changed
      if (newMessages != logic.messages) {
        // Update the messages list
        logic.updateMessages(newMessages);

        // After updating the messages, mark undelivered messages as delivered
        WidgetsBinding.instance.addPostFrameCallback((_) {
          for (var message in newMessages) {
            if (message.receiverId == logic.myFbAuth.currentUser!.uid && !message.isDelivered) {
              logic.markMessageAsDelivered(widget.chatRoomId, message.id);
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildProfessionalAppBar(
        context: context,
        receiverName: widget.receiverName,
        receiverId: widget.receiverId,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Obx(() {
                  if (logic.messages.isEmpty) {
                    return const Center(
                      child: Text(
                        'No messages',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: logic.messages.length,
                    itemBuilder: (context, index) {
                      Messages message = logic.messages[index];
                      bool isMe = message.senderId == logic.myFbAuth.currentUser!.uid;
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: InkWell(
                          onTap: () {
                            // Mark message as seen only if it's not already seen and is received by the current user
                            if (!message.isSeen && message.receiverId == logic.myFbAuth.currentUser!.uid) {
                              logic.markMessageAsSeen(widget.chatRoomId, message.id);
                            }
                          },
                          child: Container(
                            margin:  EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            padding:  EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.deepPurple : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: message.messageType == 'text'
                                ? Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: 260 - (12 * 2) - 30,
                                    ),
                                    child: Text(
                                      message.messageText,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: isMe ? Colors.white : Colors.black87,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      DateFormat(
                                        'hh:mm a',
                                      ).format(message.timestamp??DateTime.now()),
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: isMe ? Colors.white70 : Colors.grey[600],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (isMe) // Display read receipt only for the sender
                                      _buildReadReceipt(message),
                                  ],
                                ),
                              ],
                            )
                                : message.imageUrl != null && message.imageUrl!.isNotEmpty
                                ? GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => Dialog(
                                    backgroundColor: Colors.transparent,
                                    insetPadding: EdgeInsets.all(10),
                                    child: GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: InteractiveViewer(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            message.imageUrl!,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  value: loadingProgress.expectedTotalBytes != null
                                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: SizedBox(
                                height: 150,
                                width: 150,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    message.imageUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                                : const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              MsgAnimIcon(guestUserId: widget.receiverId),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: MessageInputField(

                        controller: logic.messageController,
                        onChanged: (String value) {
                          final isTyping = value.trim().isNotEmpty;
                          print(
                            "onChanged called. text: '$value', isTyping: $isTyping",
                          );

                          logic.setTypingStatus(isTyping);

                          if (_typingTimer != null && _typingTimer!.isActive) {
                            print("Timer cancelled");
                            _typingTimer!.cancel();
                          }

                          if (isTyping) {
                            _typingTimer = Timer(
                              const Duration(seconds: 1),
                                  () {
                                print(
                                  "Timer expired, setting isTyping to false",
                                );
                                logic.setTypingStatus(false);
                              },
                            );
                          } else {
                            print("Text field is empty");
                          }
                        }, chatRoomId: widget.chatRoomId, receiverId: widget.receiverId,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        setState(() {
                          logic.isLoading = true;
                        });
                        await logic.pickImage(
                          widget.chatRoomId,
                          widget.receiverId,
                        );
                        setState(() {
                          logic.isLoading = false;
                        });
                      },
                      icon: const Icon(Icons.image),
                    ),
                    GestureDetector(
                      onTap: () {
                        String messageText = logic.messageController.text.trim();
                        if (messageText.isNotEmpty) {
                          setState(() {
                           logic. isLoading = true;
                          });
                          logic.sendMessage(
                            widget.chatRoomId,
                            widget.receiverId,
                            messageText,
                          );
                          logic.messageController.clear();
                          setState(() {
                            logic.isLoading = false;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.deepPurple,
                        ),
                        child: const Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (logic.isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildReadReceipt(Messages message) {
    if (!message.isDelivered) {
      return Icon(
        Icons.check, // Single tick
        size: 12,
        color: Colors.white70,
      );
    } else if (!message.isSeen) {
      return Icon(
        Icons.done_all, // Double tick
        size: 12,
        color: Colors.white70,
      );
    } else {
      return Icon(
        Icons.done_all, // Double tick filled
        size: 12,
        color: Colors.blue[400],
      );
    }
  }
}