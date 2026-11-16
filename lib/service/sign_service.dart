import '../models/road_sign.dart';

class SignService {
  final Map<String, String> categories;
  final List<RoadSign> signs;

  SignService({
    required Map<String, String> categories,
    required List<RoadSign> signs,
  })  : categories = Map.unmodifiable(categories),
        signs = List.unmodifiable(signs) {
    for (final sign in signs) {
      if (!categories.containsKey(sign.category)) {
        throw ArgumentError('Sign ${sign.id} has an unknown category ${sign.category}.');
      }
    }
  }

  List<RoadSign> signsIn(String categoryId) {
    if (!categories.containsKey(categoryId)) {
      throw ArgumentError('Category $categoryId does not exist.');
    }
    return signs.where((s) => s.category == categoryId).toList();
  }

  RoadSign findSign(String id) {
    for (final sign in signs) {
      if (sign.id == id) {
        return sign;
      }
    }
    throw ArgumentError('Sign $id does not exist.');
  }
}
