class RoadSign {
  RoadSign({
    required this.id,
    required this.category,
    required this.name,
    required this.meaning,
    required this.image,
  });

  factory RoadSign.fromJson(Map<String, dynamic> json) {
    return RoadSign(
      id: json['id'] as String,
      category: json['category'] as String,
      name: json['name'] as String,
      meaning: json['meaning'] as String,
      image: json['image'] as String,
    );
  }

  final String id;
  final String category;
  final String name;
  final String meaning;
  final String image;
}
