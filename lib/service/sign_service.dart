import '../models/road_sign.dart';
import '../models/sign_category.dart';

class SignService {
  SignService(List<SignCategory> categories) : categories = List.unmodifiable(categories);

  final List<SignCategory> categories;

  List<RoadSign> signsIn(String categoryId) {
    for (final category in categories) {
      if (category.id == categoryId) {
        return category.signs;
      }
    }
    throw ArgumentError('Category $categoryId does not exist.');
  }

  RoadSign findSign(String id) {
    for (final category in categories) {
      for (final sign in category.signs) {
        if (sign.id == id) {
          return sign;
        }
      }
    }
    throw ArgumentError('Sign $id does not exist.');
  }
}
