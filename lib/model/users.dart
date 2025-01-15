class Person {
  String id; // New field for ID
  String name;
  String imageUrl;
  int createdAt;

  Person({
    required this.id, // Include id in the constructor
    required this.name,
    required this.imageUrl,
    required this.createdAt,
  });

  // Method to convert a Person instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id, // Add id to the JSON map
      'name': name,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
    };
  }

  // Factory constructor to create a Person instance from a JSON map
  factory Person.fromJson(Map<String, dynamic> json) {
    int createdAtTimestamp;

    if (json['createdAt'].runtimeType == int) {
      createdAtTimestamp = json['createdAt'];
    } else {
      DateTime myDate = DateTime.parse(json['createdAt']);
      createdAtTimestamp = myDate.microsecondsSinceEpoch;
    }

    return Person(
      id: json['id'] as String, // Parse id from JSON
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      createdAt: createdAtTimestamp,
    );
  }
}
