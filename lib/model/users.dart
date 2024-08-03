class User {
  String id;
  String name;
  String? imageUrl;

  User({required this.id, required this.name, this.imageUrl});

  // Convert a User object into a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  // Create a User object from a map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
