
class Person {
  String name;
  String? color;
  String imageUrl;
  int createdAt;
  String id ;

  Person({
    required this.name,
    this.color,
    required this.imageUrl,
    required this.createdAt,
  required this.id,
  });

  // Method to convert a Person instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'color': color,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'id': id,

    };
  }

  // Factory constructor to create a Person instance from a JSON map
  factory Person.fromJson(Map<String, dynamic> json) {
    if(json['createdAt'].runtimeType == int ){
      return Person(
        name: json['name'] as String,
        color: json['color'] ?? 'Em',
        imageUrl: json['imageUrl'] as String,
        createdAt: (json['createdAt']),
        id : json['id'] as String,
      );
    }
    else{
      DateTime myDate =DateTime.parse(json['createdAt']);
      int myMicroSecondDate = myDate.microsecondsSinceEpoch;

      return Person(
        name: json['name'] as String,
        color: json['color'] ?? 'Em',
        imageUrl: json['imageUrl'] as String,
        createdAt: myMicroSecondDate,
        id: json['id'] as String,
      );
    }


  }
}
