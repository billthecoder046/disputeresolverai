import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  String id;
  String senderId;
  String messageText;
  String receiverId;
  String messageType; // 'text' or 'image'
  DateTime? timestamp;
  String? imageUrl;
  bool isSeen; // New field to track if the message has been seen
  bool isDelivered; // New field to track if the message has been delivered

  Messages({
    required this.id,
    required this.senderId,
    required this.messageText,
    required this.receiverId,
    required this.messageType,
    this.timestamp,
    this.imageUrl,
    this.isSeen = false, // Default to false (not seen)
    this.isDelivered = false, // Default to false (not delivered)
  });

  factory Messages.fromJson(Map<String, dynamic> json, String id) {
    return Messages(
      id: id,
      senderId: json['senderId'] ?? '',
      messageText: json['messageText'] ?? '',
      receiverId: json['receiverId'] ?? '',
      messageType: json['messageType'] ?? 'text',
      timestamp: (json['timestamp'] as Timestamp?)?.toDate(),
      imageUrl: json['imageUrl'],
      isSeen: json['isSeen'] ?? false, // Retrieve from JSON, default to false
      isDelivered: json['isDelivered'] ?? false, // Retrieve from JSON, default to false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'messageText': messageText,
      'receiverId': receiverId,
      'messageType': messageType,
      'timestamp': timestamp != null
          ? Timestamp.fromDate(timestamp!)
          : FieldValue.serverTimestamp(),
      'imageUrl': imageUrl,
      'isSeen': isSeen, // Include in JSON
      'isDelivered': isDelivered, // Include in JSON
    };
  }
}