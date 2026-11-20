import '../models/question.dart';
import '../models/quiz.dart';
import '../models/quiz_result.dart';

class QuizService {
  Quiz startTopicQuiz(String topicId, List<Question> allQuestions) {
    final questions = allQuestions.where((q) => q.topicId == topicId).toList();
    if (questions.isEmpty) {
      throw ArgumentError('Topic $topicId has no questions.');
    }
    return Quiz(questions);
  }

  Quiz startPracticeQuiz(List<Question> allQuestions, List<String> mistakeIds) {
    if (mistakeIds.isEmpty) {
      throw StateError('There are no mistakes to practice.');
    }
    final questions = allQuestions.where((q) => mistakeIds.contains(q.id)).toList();
    if (questions.isEmpty) {
      throw ArgumentError('None of the mistake questions exist in the content.');
    }
    return Quiz(questions);
  }

  void answer(Quiz quiz, int index) {
    quiz.addAnswer(index);
  }

  List<QuizResult>? finish(Quiz quiz) {
    if (!quiz.isFinished) {
      return null;
    }
    final byTopic = <String, _TopicTally>{};
    for (var i = 0; i < quiz.questions.length; i++) {
      final question = quiz.questions[i];
      final tally = byTopic.putIfAbsent(question.topicId, _TopicTally.new);
      tally.add(question, question.isCorrect(quiz.answers[i]));
    }
    return [
      for (final entry in byTopic.entries)
        QuizResult(
          topicId: entry.key,
          score: entry.value.correct.length,
          total: entry.value.correct.length + entry.value.wrong.length,
          wrongQuestionIds: entry.value.wrong,
          correctQuestionIds: entry.value.correct,
        ),
    ];
  }
}

class _TopicTally {
  final List<String> correct = [];
  final List<String> wrong = [];

  void add(Question question, bool isCorrect) {
    (isCorrect ? correct : wrong).add(question.id);
  }
}
