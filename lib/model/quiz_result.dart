class QuizResult {
  QuizResult({
    required this.topicId,
    required this.score,
    required this.total,
    required List<String> wrongQuestionIds,
    required List<String> correctQuestionIds,
    DateTime? date,
  })  : wrongQuestionIds = List.unmodifiable(wrongQuestionIds),
        correctQuestionIds = List.unmodifiable(correctQuestionIds),
        date = date ?? DateTime.now();

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      topicId: json['topicId'] as String,
      score: json['score'] as int,
      total: json['total'] as int,
      wrongQuestionIds: (json['wrongQuestionIds'] as List).cast<String>(),
      correctQuestionIds: (json['correctQuestionIds'] as List).cast<String>(),
      date: DateTime.parse(json['date'] as String),
    );
  }

  final String topicId;
  final int score;
  final int total;
  final List<String> wrongQuestionIds;
  final List<String> correctQuestionIds;
  final DateTime date;

  double get percent => total == 0 ? 0 : score / total * 100;

  Map<String, dynamic> toJson() {
    return {
      'topicId': topicId,
      'score': score,
      'total': total,
      'wrongQuestionIds': wrongQuestionIds,
      'correctQuestionIds': correctQuestionIds,
      'date': date.toIso8601String(),
    };
  }
}
