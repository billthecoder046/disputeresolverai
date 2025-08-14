import 'package:cloud_firestore/cloud_firestore.dart';

class Students {
  String name;
  int createdAt;
  String id;
  String email;
  String? lastMessage;         // Add this
  Timestamp? lastMessageTime;
  Students({required this.name, required this.id, required this.createdAt,required this.email, this.lastMessage,          // Initialize in constructor
    this.lastMessageTime });

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'createdAt': createdAt,
      'email' : email,
      'lastMessage': lastMessage,        // Add this
      'lastMessageTime': lastMessageTime
    };
  }

  // Create object from JSON
  factory Students.fromJson(Map<String, dynamic> json) {
    int timestamp;
    if (json['createdAt'].runtimeType == int) {
      timestamp = json['createdAt'];
    } else {
      DateTime myDate = DateTime.parse(json['createdAt']);
      timestamp = myDate.microsecondsSinceEpoch;
    }

    return Students(
      name: json['name'] as String,
      id: json['id'] as String,
      email: json['email'] as String,
      createdAt: timestamp,
        lastMessage: json['lastMessage'] as String?,     // Add this, handle null
        lastMessageTime: json['lastMessageTime'] as Timestamp?
    );
  }
}
