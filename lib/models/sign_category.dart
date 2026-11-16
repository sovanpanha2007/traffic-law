import 'road_sign.dart';

class SignCategory {
  SignCategory({
    required this.id,
    required this.title,
    required List<RoadSign> signs,
  }) : signs = List.unmodifiable(signs) {
    for (final sign in signs) {
      if (sign.category != id) {
        throw ArgumentError('Sign ${sign.id} belongs to ${sign.category}, not $id.');
      }
    }
  }

  factory SignCategory.fromJson(Map<String, dynamic> json, List<RoadSign> signs) {
    return SignCategory(
      id: json['id'] as String,
      title: json['title'] as String,
      signs: signs,
    );
  }

  final String id;
  final String title;
  final List<RoadSign> signs;
}
