import 'package:flutter_test/flutter_test.dart';
import 'package:traffic_law/model/quiz_result.dart';
import 'package:traffic_law/service/progress_service.dart';

import 'test_data.dart';

void main() {
  late FakeProgressStorage storage;
  late ProgressService service;

  setUp(() {
    storage = FakeProgressStorage();
    service = ProgressService(storage);
  });

  test('T11 boundary: a score of exactly 70% is not marked weak (R4)', () async {
    await service.saveResult(QuizResult(
      topicId: 'speed',
      score: 7,
      total: 10,
      wrongQuestionIds: const ['q8', 'q9', 'q10'],
      correctQuestionIds: const ['q1', 'q2', 'q3', 'q4', 'q5', 'q6', 'q7'],
    ));

    expect(service.latestScoreByTopic()['speed'], 70);
    expect(service.isWeak('speed'), isFalse);
  });

  test('T12 special case: a correct answer removes the question from the mistake list (R3)', () async {
    await service.saveResult(QuizResult(
      topicId: 'speed',
      score: 0,
      total: 1,
      wrongQuestionIds: const ['q1'],
      correctQuestionIds: const [],
    ));
    expect(service.mistakeIds, ['q1']);

    await service.saveResult(QuizResult(
      topicId: 'speed',
      score: 1,
      total: 1,
      wrongQuestionIds: const [],
      correctQuestionIds: const ['q1'],
    ));

    expect(service.mistakeIds, isEmpty);
  });

  test('T13 normal: saving a result writes results and mistakes to storage', () async {
    await service.saveResult(QuizResult(
      topicId: 'speed',
      score: 1,
      total: 2,
      wrongQuestionIds: const ['q2'],
      correctQuestionIds: const ['q1'],
    ));

    expect(storage.results, hasLength(1));
    expect(storage.mistakeIds, ['q2']);
  });

  test('T14 normal: progress survives a restart (load into a new service)', () async {
    await service.saveResult(QuizResult(
      topicId: 'speed',
      score: 1,
      total: 2,
      wrongQuestionIds: const ['q2'],
      correctQuestionIds: const ['q1'],
    ));

    final restarted = ProgressService(storage);
    await restarted.load();

    expect(restarted.results, hasLength(1));
    expect(restarted.mistakeIds, ['q2']);
  });

  test('T15 normal: the latest score by topic uses the newest result', () async {
    await service.saveResult(QuizResult(
      topicId: 'speed',
      score: 2,
      total: 10,
      wrongQuestionIds: const ['q3', 'q4', 'q5', 'q6', 'q7', 'q8', 'q9', 'q10'],
      correctQuestionIds: const ['q1', 'q2'],
      date: DateTime(2026, 11, 1),
    ));
    await service.saveResult(QuizResult(
      topicId: 'speed',
      score: 9,
      total: 10,
      wrongQuestionIds: const ['q10'],
      correctQuestionIds: const ['q1', 'q2', 'q3', 'q4', 'q5', 'q6', 'q7', 'q8', 'q9'],
      date: DateTime(2026, 11, 10),
    ));

    expect(service.latestScoreByTopic()['speed'], 90);
    expect(service.isWeak('speed'), isFalse);
  });

  test('T16 invalid: a result with no questions is rejected', () async {
    expect(
      () => service.saveResult(QuizResult(
        topicId: 'speed',
        score: 0,
        total: 0,
        wrongQuestionIds: const [],
        correctQuestionIds: const [],
      )),
      throwsArgumentError,
    );
  });

  test('T17 invalid: a result whose IDs do not add up to the total is rejected', () async {
    expect(
      () => service.saveResult(QuizResult(
        topicId: 'speed',
        score: 1,
        total: 3,
        wrongQuestionIds: const ['q2'],
        correctQuestionIds: const ['q1'],
      )),
      throwsArgumentError,
    );
  });

  test('T18 invalid: reset without confirmation is rejected', () async {
    expect(() => service.resetAll(confirmed: false), throwsStateError);
  });

  test('T19 normal: confirmed reset clears results and mistakes', () async {
    await service.saveResult(QuizResult(
      topicId: 'speed',
      score: 0,
      total: 1,
      wrongQuestionIds: const ['q1'],
      correctQuestionIds: const [],
    ));

    await service.resetAll(confirmed: true);

    expect(service.results, isEmpty);
    expect(service.mistakeIds, isEmpty);
    expect(storage.results, isEmpty);
    expect(storage.mistakeIds, isEmpty);
  });

  test('T39 boundary: a score just under 70% is marked weak (R4)', () async {
    await service.saveResult(QuizResult(
      topicId: 'speed',
      score: 9,
      total: 13,
      wrongQuestionIds: const ['q10', 'q11', 'q12', 'q13'],
      correctQuestionIds: [for (var i = 1; i <= 9; i++) 'q$i'],
    ));

    expect(service.latestScoreByTopic()['speed'], lessThan(70));
    expect(service.isWeak('speed'), isTrue);
  });

  test('T40 special case: a topic with no result yet is not weak (R4)', () {
    expect(service.isWeak('speed'), isFalse);
  });

  test('T44 invalid: a result whose score does not match its correct IDs is rejected (R7)', () async {
    expect(
      () => service.saveResult(QuizResult(
        topicId: 'speed',
        score: 2,
        total: 2,
        wrongQuestionIds: const ['q2'],
        correctQuestionIds: const ['q1'],
      )),
      throwsArgumentError,
    );
  });
}
