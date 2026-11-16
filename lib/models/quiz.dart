import 'question.dart';

class Quiz {
  Quiz(List<Question> questions) : questions = List.unmodifiable(questions);

  final List<Question> questions;
  final List<int> _answers = [];

  List<int> get answers => List.unmodifiable(_answers);

  bool get isFinished => _answers.length == questions.length;

  Question get currentQuestion {
    if (isFinished) {
      throw StateError('The quiz is already finished.');
    }
    return questions[_answers.length];
  }

  void addAnswer(int index) {
    _answers.add(index);
  }
}
