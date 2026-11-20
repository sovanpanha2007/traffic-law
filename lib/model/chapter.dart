class Chapter {
  Chapter({
    required this.id,
    required this.title,
    required this.startPage,
    this.topicId,
  }) {
    if (startPage < 1) {
      throw ArgumentError('startPage must be at least 1.');
    }
  }

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] as int,
      title: json['title'] as String,
      startPage: json['startPage'] as int,
      topicId: json['topicId'] as String?,
    );
  }

  final int id;
  final String title;
  final int startPage;
  final String? topicId;
}
