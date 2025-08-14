import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../chatting_page_logic.dart';

class MessageInputField extends StatefulWidget {
  final TextEditingController controller;
  // final Function(String) onSend;
  final ValueChanged<String> onChanged;
 final String chatRoomId;
 final String receiverId; // Added

   MessageInputField({
    super.key,
    required this.controller,
    required this.chatRoomId,

    required this.receiverId,

    // required this.onSend,
    required this.onChanged, // Added
  });

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final ChattingPageLogic logic = Get.put(ChattingPageLogic());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: logic.messageController,
              textInputAction: TextInputAction.send,
              onFieldSubmitted: (value) {
                String messageText = value.trim();
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
                   logic. isLoading = false;
                  });
                }
              },
              decoration: InputDecoration(
                hintText: "Type a message...",
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                fillColor: const Color(0xFFF2F2F5),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // CircleAvatar(
          //   backgroundColor: const Color(0xFF4B2EDF),
          //   child: IconButton(
          //     icon: const Icon(Icons.send, color: Colors.white, size: 20),
          //     onPressed: () => onSend(controller.text),
          //   ),
          // )
        ],
      ),
    );
  }
}
