class Question {
  Question({
    required this.id,
    required this.topicId,
    required this.text,
    this.image,
    required List<String> options,
    required this.correctIndex,
    required this.explanation,
    this.lawPage,
  }) : options = List.unmodifiable(options) {
    if (options.length < 2 || options.length > 4) {
      throw ArgumentError('A question needs 2 to 4 options.');
    }
    if (correctIndex < 0 || correctIndex >= options.length) {
      throw ArgumentError('correctIndex is outside the options.');
    }
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      topicId: json['topicId'] as String,
      text: json['text'] as String,
      image: json['image'] as String?,
      options: (json['options'] as List).cast<String>(),
      correctIndex: json['correctIndex'] as int,
      explanation: json['explanation'] as String,
      lawPage: json['lawPage'] as int?,
    );
  }

  final String id;
  final String topicId;
  final String text;
  final String? image;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final int? lawPage;

  bool isCorrect(int answer) => answer == correctIndex;
}
