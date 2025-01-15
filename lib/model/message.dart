import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String? id; // Add this field for document ID
  final String senderId;
  final String receiverId;
  final String messageText;
  final DateTime timestamp;

  Message({
    this.id, // Optional field for document ID
    required this.senderId,
    required this.receiverId,
    required this.messageText,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json, {String? id}) {
    // Handle null timestamp and fallback to the current date-time if it's null
    Timestamp? timestamp = json['timestamp'];
    DateTime timestampDate = timestamp != null ? timestamp.toDate() : DateTime.now();

    return Message(
      id: id, // Set document ID
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      messageText: json['messageText'],
      timestamp: timestampDate,
    );
  }
}
