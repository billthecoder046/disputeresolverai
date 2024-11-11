import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  String name;
  String? color;
  String imageUrl;
  DateTime createdAt; // Ensure this is non-nullable if you always want a timestamp

  // Constructor using named parameters
  Person({
    required this.name,
    this.color,
    required this.imageUrl,
    required this.createdAt, // Required parameter (non-nullable)
  });

  // Method to convert a Person instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'color': color,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt), // Convert DateTime to Timestamp
    };
  }

  // Factory constructor to create a Person instance from a JSON map
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'] as String,
      color: json['color'] ?? 'Em',
      imageUrl: json['imageUrl'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(), // Convert Timestamp to DateTime
    );
  }
}
