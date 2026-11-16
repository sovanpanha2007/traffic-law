import '../models/chapter.dart';

class LawService {
  LawService(List<Chapter> chapters) : chapters = _ordered(chapters);

  final List<Chapter> chapters;

  static List<Chapter> _ordered(List<Chapter> chapters) {
    final sorted = [...chapters]..sort((a, b) => a.id.compareTo(b.id));
    return List.unmodifiable(sorted);
  }

  Chapter findChapter(int id) {
    for (final chapter in chapters) {
      if (chapter.id == id) {
        return chapter;
      }
    }
    throw ArgumentError('Chapter $id does not exist.');
  }

  int startPageFor(int chapterId) => findChapter(chapterId).startPage;

  Chapter? chapterForTopic(String topicId) {
    for (final chapter in chapters) {
      if (chapter.topicId == topicId) {
        return chapter;
      }
    }
    return null;
  }
}
