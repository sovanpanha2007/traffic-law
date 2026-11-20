import 'package:flutter_test/flutter_test.dart';
import 'package:traffic_law/models/question.dart';
import 'package:traffic_law/models/quiz.dart';
import 'package:traffic_law/service/quiz_service.dart';

import 'test_data.dart';

void main() {
  final service = QuizService();

  test('T1 normal: a quiz with all correct answers scores full marks', () {
    final quiz = service.startTopicQuiz('speed', makeQuestions('speed', 3));
    for (var i = 0; i < 3; i++) {
      service.answer(quiz, 0);
    }
    final results = service.finish(quiz)!;

    expect(results, hasLength(1));
    expect(results.single.score, 3);
    expect(results.single.total, 3);
    expect(results.single.wrongQuestionIds, isEmpty);
  });

  test('T2 normal: wrong answers are recorded by question ID', () {
    final quiz = service.startTopicQuiz('speed', makeQuestions('speed', 3));
    service.answer(quiz, 0);
    service.answer(quiz, 1);
    service.answer(quiz, 0);
    final result = service.finish(quiz)!.single;

    expect(result.wrongQuestionIds, ['speed2']);
    expect(result.correctQuestionIds, ['speed1', 'speed3']);
  });

  test('T3 invalid: a question with correctIndex outside its options is rejected', () {
    expect(
      () => Question(
        id: 'bad',
        topicId: 'speed',
        text: 'Bad',
        options: const ['A', 'B'],
        correctIndex: 5,
        explanation: 'None',
      ),
      throwsArgumentError,
    );
  });

  test('T4 invalid: answering after the quiz is finished is rejected', () {
    final quiz = service.startTopicQuiz('speed', makeQuestions('speed', 1));
    service.answer(quiz, 0);

    expect(() => service.answer(quiz, 0), throwsStateError);
  });

  test('T5 invalid: starting a quiz on a topic with no questions is rejected (R1)', () {
    expect(
      () => service.startTopicQuiz('parking', makeQuestions('speed', 3)),
      throwsArgumentError,
    );
  });

  test('T6 invalid: an answer index outside the options is rejected', () {
    final quiz = service.startTopicQuiz('speed', makeQuestions('speed', 1));

    expect(() => service.answer(quiz, 3), throwsRangeError);
  });

  test('T7 boundary: finish returns null while questions are still unanswered', () {
    final quiz = service.startTopicQuiz('speed', makeQuestions('speed', 2));
    service.answer(quiz, 0);

    expect(service.finish(quiz), isNull);
  });

  test('T8 multi-entity: a practice quiz across two topics gives one result per topic', () {
    final all = [...makeQuestions('speed', 2), ...makeQuestions('parking', 2)];
    final quiz = service.startPracticeQuiz(all, ['speed1', 'parking2']);
    service.answer(quiz, 0);
    service.answer(quiz, 1);
    final results = service.finish(quiz)!;

    expect(results.map((r) => r.topicId), ['speed', 'parking']);
    expect(results[0].score, 1);
    expect(results[1].wrongQuestionIds, ['parking2']);
  });

  test('T9 invalid: a practice quiz with no mistakes is rejected', () {
    expect(
      () => service.startPracticeQuiz(makeQuestions('speed', 2), []),
      throwsStateError,
    );
  });

  test('T10 invalid: a practice quiz whose mistakes are not in the content is rejected', () {
    expect(
      () => service.startPracticeQuiz(makeQuestions('speed', 2), ['missing']),
      throwsArgumentError,
    );
  });

  test('T43 invalid: calling addAnswer on the quiz after the last question is rejected', () {
    final quiz = Quiz([makeQuestion('speed1')]);
    quiz.addAnswer(0);

    expect(() => quiz.addAnswer(0), throwsStateError);
    expect(quiz.isFinished, isTrue);
  });
}
