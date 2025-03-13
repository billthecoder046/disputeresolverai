class Students {
  String name;
  int createdAt;
  String id;

  Students({required this.name, required this.id, required this.createdAt});

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'createdAt': createdAt,
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
      createdAt: timestamp,
    );
  }
}
