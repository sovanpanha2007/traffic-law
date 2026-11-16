import 'package:flutter_test/flutter_test.dart';
import 'package:traffic_law/data/content_repository.dart';
import 'package:traffic_law/models/chapter.dart';

void main() {
  test('T20 normal: chapters load from JSON in their stored order', () async {
    final repo = ContentRepository(
      loader: (_) async => '[{"id":1,"title":"General","startPage":1},'
          '{"id":2,"title":"Speed","startPage":21}]',
    );

    final chapters = await repo.loadChapters();

    expect(chapters.map((c) => c.title), ['General', 'Speed']);
    expect(chapters[1].startPage, 21);
  });

  test('T21 normal: a second load does not read the file again', () async {
    var reads = 0;
    final repo = ContentRepository(
      loader: (_) async {
        reads++;
        return '[{"id":1,"title":"General","startPage":1}]';
      },
    );

    await repo.loadChapters();
    await repo.loadChapters();

    expect(reads, 1);
  });

  test('T22 invalid: a broken JSON file shows an error, not a crash', () async {
    final repo = ContentRepository(loader: (_) async => '[{ broken');

    expect(repo.loadChapters(), throwsA(isA<ContentException>()));
  });

  test('T23 invalid: a missing file shows an error', () async {
    final repo = ContentRepository(loader: (_) async => throw Exception('missing'));

    expect(repo.loadChapters(), throwsA(isA<ContentException>()));
  });

  test('T24 invalid: duplicate question IDs are rejected', () async {
    final repo = ContentRepository(
      loader: (_) async => '{"topics":[{"id":"speed","title":"Speed"}],'
          '"questions":['
          '{"id":"sp01","topicId":"speed","text":"a","options":["x","y"],'
          '"correctIndex":0,"explanation":"e"},'
          '{"id":"sp01","topicId":"speed","text":"b","options":["x","y"],'
          '"correctIndex":0,"explanation":"e"}]}',
    );

    expect(repo.loadQuestions(), throwsA(isA<ContentException>()));
  });

  test('T25 invalid: a question with no explanation is rejected', () async {
    final repo = ContentRepository(
      loader: (_) async => '{"topics":[{"id":"speed","title":"Speed"}],'
          '"questions":[{"id":"sp01","topicId":"speed","text":"a",'
          '"options":["x","y"],"correctIndex":0,"explanation":""}]}',
    );

    expect(repo.loadQuestions(), throwsA(isA<ContentException>()));
  });

  test('T26 boundary: a chapter cannot start before page 1', () {
    expect(
      () => Chapter(id: 1, title: 'Bad', startPage: 0),
      throwsArgumentError,
    );
  });
}
