class MyUser {
  String id;
  String name;
  DateTime? createdAt;
  String? imageUrl;

  MyUser({required this.id, required this.name, this.imageUrl,this.createdAt, });

  // Convert a User object into a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'createdAt':createdAt,

    };
  }

  // Create a User object from a map
  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] as DateTime,

    );
  }
}
