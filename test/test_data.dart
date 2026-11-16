import 'package:traffic_law/data/progress_storage.dart';
import 'package:traffic_law/models/question.dart';
import 'package:traffic_law/models/quiz_result.dart';

Question makeQuestion(String id, {String topicId = 'speed', int correctIndex = 0}) {
  return Question(
    id: id,
    topicId: topicId,
    text: 'Question $id',
    options: const ['A', 'B', 'C'],
    correctIndex: correctIndex,
    explanation: 'Because $id.',
  );
}

List<Question> makeQuestions(String topicId, int count) {
  return [for (var i = 1; i <= count; i++) makeQuestion('$topicId$i', topicId: topicId)];
}

class FakeProgressStorage implements ProgressStorage {
  List<QuizResult> results = [];
  List<String> mistakeIds = [];

  @override
  Future<List<QuizResult>> loadResults() async => List.of(results);

  @override
  Future<void> saveResult(QuizResult result) async {
    results = [...results, result];
  }

  @override
  Future<List<String>> loadMistakeIds() async => List.of(mistakeIds);

  @override
  Future<void> saveMistakeIds(List<String> ids) async {
    mistakeIds = List.of(ids);
  }

  @override
  Future<void> resetAll() async {
    results = [];
    mistakeIds = [];
  }
}
