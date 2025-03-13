import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  String id;
  String senderId;
  String messageText;
  String receiverId;
  String messageType; // Added
  DateTime? timestamp;
  String? audioUrl; // Added for audio messages

  Messages({
    required this.id,
    required this.senderId,
    required this.messageText,
    required this.receiverId,
    required this.messageType,
    this.timestamp,
    this.audioUrl, // Optional for text messages
  });

  factory Messages.fromJson(Map<String, dynamic> json, String id) {
    return Messages(
      id: id,
      senderId: json['senderId'] ?? '',
      messageText: json['messageText'] ?? '',
      receiverId: json['receiverId'] ?? '',
      messageType: json['messageType'] ?? 'text', // Default to 'text'
      timestamp: (json['timestamp'] as Timestamp?)?.toDate(),
      audioUrl: json['audioUrl'], // Get audio URL if available
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'messageText': messageText,
      'receiverId': receiverId,
      'messageType': messageType,
      'timestamp': timestamp,
      'audioUrl': audioUrl, // Save audio URL if available
    };
  }
}
