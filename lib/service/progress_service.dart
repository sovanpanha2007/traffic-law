import '../data/progress_storage.dart';
import '../model/quiz_result.dart';

class ProgressService {
  ProgressService(this._storage);

  static const double weakThreshold = 70;

  final ProgressStorage _storage;
  final List<QuizResult> _results = [];
  final Set<String> _mistakeIds = {};

  List<QuizResult> get results => List.unmodifiable(_results);

  List<String> get mistakeIds => List.unmodifiable(_mistakeIds);

  Future<void> load() async {
    _results
      ..clear()
      ..addAll(await _storage.loadResults());
    _mistakeIds
      ..clear()
      ..addAll(await _storage.loadMistakeIds());
  }

  Future<void> saveResult(QuizResult result) async {
    if (result.total <= 0) {
      throw ArgumentError('A result needs at least one question.');
    }
    if (result.wrongQuestionIds.length + result.correctQuestionIds.length != result.total) {
      throw ArgumentError('The answered question IDs do not match the total.');
    }
    if (result.score != result.correctQuestionIds.length) {
      throw ArgumentError('The score does not match the number of correct answers.');
    }
    _results.add(result);
    _mistakeIds.addAll(result.wrongQuestionIds);
    _mistakeIds.removeAll(result.correctQuestionIds);
    await _storage.saveResult(result);
    await _storage.saveMistakeIds(_mistakeIds.toList());
  }

  Map<String, double> latestScoreByTopic() {
    final latest = <String, QuizResult>{};
    for (final result in _results) {
      final current = latest[result.topicId];
      if (current == null || !result.date.isBefore(current.date)) {
        latest[result.topicId] = result;
      }
    }
    return {for (final entry in latest.entries) entry.key: entry.value.percent};
  }

  bool isWeak(String topicId) {
    final score = latestScoreByTopic()[topicId];
    return score != null && score < weakThreshold;
  }

  Future<void> resetAll({required bool confirmed}) async {
    if (!confirmed) {
      throw StateError('Reset needs confirmation.');
    }
    _results.clear();
    _mistakeIds.clear();
    await _storage.resetAll();
  }
}
