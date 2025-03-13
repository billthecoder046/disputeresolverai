class GroupModel {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> members;

  GroupModel({required this.id, required this.name, required this.imageUrl, required this.members});

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      members: List<String>.from(json['members']),
    );
  }
}
