import 'package:flutter_test/flutter_test.dart';
import 'package:traffic_law/models/chapter.dart';
import 'package:traffic_law/models/road_sign.dart';
import 'package:traffic_law/models/sign_category.dart';
import 'package:traffic_law/service/law_service.dart';
import 'package:traffic_law/service/sign_service.dart';

void main() {
  test('T27 normal: chapters are returned in order of their ID', () {
    final service = LawService([
      Chapter(id: 2, title: 'Speed', startPage: 21),
      Chapter(id: 1, title: 'General', startPage: 1),
    ]);

    expect(service.chapters.map((c) => c.id), [1, 2]);
  });

  test('T28 normal: the start page of a chapter is found by ID', () {
    final service = LawService([Chapter(id: 2, title: 'Speed', startPage: 21)]);

    expect(service.startPageFor(2), 21);
  });

  test('T35 normal: a chapter is found from its linked quiz topic', () {
    final service = LawService([
      Chapter(id: 1, title: 'General', startPage: 1),
      Chapter(id: 2, title: 'Speed', startPage: 21, topicId: 'speed'),
    ]);

    expect(service.chapterForTopic('speed')?.id, 2);
  });

  test('T36 boundary: a chapter with no quiz topic is allowed, and no topic finds it', () {
    final service = LawService([Chapter(id: 1, title: 'General', startPage: 1)]);

    expect(service.chapterForTopic('speed'), isNull);
  });

  test('T29 invalid: an unknown chapter is rejected', () {
    final service = LawService([Chapter(id: 1, title: 'General', startPage: 1)]);

    expect(() => service.findChapter(99), throwsArgumentError);
  });

  test('T30 normal: signs are filtered by category', () {
    final service = SignService([
      SignCategory(id: 'warning', title: 'Warning', signs: [
        RoadSign(id: 'w01', category: 'warning', name: 'a', meaning: 'a', image: 'a.png'),
      ]),
      SignCategory(id: 'ban', title: 'Ban', signs: [
        RoadSign(id: 'b01', category: 'ban', name: 'b', meaning: 'b', image: 'b.png'),
      ]),
    ]);

    expect(service.signsIn('warning').map((s) => s.id), ['w01']);
  });

  test('T31 invalid: an unknown category is rejected', () {
    final service = SignService([SignCategory(id: 'warning', title: 'Warning', signs: const [])]);

    expect(() => service.signsIn('ban'), throwsArgumentError);
  });

  test('T32 invalid: a sign placed in the wrong category is rejected (R9)', () {
    expect(
      () => SignCategory(id: 'warning', title: 'Warning', signs: [
        RoadSign(id: 'x', category: 'ban', name: 'x', meaning: 'x', image: 'x.png'),
      ]),
      throwsArgumentError,
    );
  });
}
