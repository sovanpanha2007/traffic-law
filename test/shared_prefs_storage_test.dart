import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traffic_law/data/progress_storage.dart';
import 'package:traffic_law/models/quiz_result.dart';

void main() {
  test('T33 normal: results and mistakes survive a save and load on the phone storage', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = SharedPrefsProgressStorage();
    final date = DateTime(2026, 11, 20, 9, 15);

    await storage.saveResult(QuizResult(
      topicId: 'speed',
      score: 1,
      total: 2,
      wrongQuestionIds: const ['sp02'],
      correctQuestionIds: const ['sp01'],
      date: date,
    ));
    await storage.saveMistakeIds(['sp02']);

    final results = await storage.loadResults();
    expect(results.single.topicId, 'speed');
    expect(results.single.date, date);
    expect(await storage.loadMistakeIds(), ['sp02']);
  });

  test('T34 normal: reset removes all saved progress from the phone storage', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = SharedPrefsProgressStorage();
    await storage.saveMistakeIds(['sp02']);

    await storage.resetAll();

    expect(await storage.loadMistakeIds(), isEmpty);
    expect(await storage.loadResults(), isEmpty);
  });
}
