
class MyUser {
  String id;
  String name;
  int? createdAt;
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
    dynamic createdAtValue = json['createdAt'];

    int createdAtTimestamp;

    if (createdAtValue is int) {
      createdAtTimestamp = createdAtValue;
    } else if (createdAtValue is String) {
      DateTime createdAtDate = DateTime.parse(createdAtValue);
      createdAtTimestamp = createdAtDate.microsecondsSinceEpoch;
    } else {
      throw Exception("Invalid createdAt type in JSON");
    }

    return MyUser(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdAt: createdAtTimestamp,
    );
  }
}
