import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String messageText;
  final DateTime timestamp;
  final String? audioUrl; // Added audio URL support
  final bool isVoiceMessage; // Added to distinguish voice messages

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.messageText,
    required this.timestamp,
    this.audioUrl, // Optional for voice messages
    this.isVoiceMessage = false, // Default to false
  });

  factory Message.fromJson(Map<String, dynamic> json, String documentId) {
    return Message(
      id: documentId,
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      messageText: json['messageText'] ?? '',
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      audioUrl: json['audioUrl'], // Fetching audio URL if available
      isVoiceMessage: json['isVoiceMessage'] ?? false, // Fetching isVoiceMessage
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'messageText': messageText,
      'timestamp': timestamp,
      'audioUrl': audioUrl, // Include audio URL
      'isVoiceMessage': isVoiceMessage, // Include isVoiceMessage
    };
  }
}