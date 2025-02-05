import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String messageText;
  final String? repliedMessageText; // 🔹 Add this field
  final DateTime timestamp;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.messageText,
    this.repliedMessageText, // 🔹 Add this field
    required this.timestamp,
  });

  // 🔹 Modify fromJson to include repliedMessageText
  factory Message.fromJson(Map<String, dynamic> json, String messageId) {
    return Message(
      id: messageId,
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      messageText: json['messageText'],
      repliedMessageText: json['repliedMessageText'], // 🔹 Include this
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  // 🔹 Modify toJson to include repliedMessageText
  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'messageText': messageText,
      'repliedMessageText': repliedMessageText, // 🔹 Include this
      'timestamp': timestamp,
    };
  }
}
