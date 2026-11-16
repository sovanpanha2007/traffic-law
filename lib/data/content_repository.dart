import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/chapter.dart';
import '../models/question.dart';
import '../models/road_sign.dart';
import '../models/topic.dart';

typedef AssetLoader = Future<String> Function(String path);

class ContentException implements Exception {
  ContentException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ContentRepository {
  ContentRepository({AssetLoader? loader})
      : _loader = loader ?? rootBundle.loadString;

  static const chaptersPath = 'assets/data/chapters.json';
  static const signsPath = 'assets/data/signs.json';
  static const questionsPath = 'assets/data/questions.json';

  final AssetLoader _loader;
  final Map<String, dynamic> _cache = {};

  Future<List<Chapter>> loadChapters() async {
    final json = await _readList(chaptersPath);
    try {
      final chapters = json.map((e) => Chapter.fromJson(e as Map<String, dynamic>)).toList();
      _checkUniqueIds(chapters.map((c) => c.id.toString()), chaptersPath);
      return chapters;
    } on ContentException {
      rethrow;
    } catch (e) {
      throw ContentException('Could not read $chaptersPath: $e');
    }
  }

  Future<Map<String, String>> loadSignCategories() async {
    final json = await _readMap(signsPath);
    final categories = json['categories'] as List;
    return {
      for (final c in categories)
        (c as Map<String, dynamic>)['id'] as String: c['title'] as String,
    };
  }

  Future<List<RoadSign>> loadSigns() async {
    final json = await _readMap(signsPath);
    final signs = (json['signs'] as List)
        .map((e) => RoadSign.fromJson(e as Map<String, dynamic>))
        .toList();
    _checkUniqueIds(signs.map((s) => s.id), signsPath);
    return signs;
  }

  Future<List<Topic>> loadTopics() async {
    final json = await _readMap(questionsPath);
    return (json['topics'] as List)
        .map((e) => Topic.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Question>> loadQuestions() async {
    final json = await _readMap(questionsPath);
    final questions = (json['questions'] as List)
        .map((e) => Question.fromJson(e as Map<String, dynamic>))
        .toList();
    _checkUniqueIds(questions.map((q) => q.id), questionsPath);
    for (final q in questions) {
      if (q.explanation.trim().isEmpty) {
        throw ContentException('Question ${q.id} has no explanation.');
      }
    }
    return questions;
  }

  Future<List<dynamic>> _readList(String path) async {
    final value = await _read(path);
    if (value is! List) {
      throw ContentException('$path must contain a JSON list.');
    }
    return value;
  }

  Future<Map<String, dynamic>> _readMap(String path) async {
    final value = await _read(path);
    if (value is! Map<String, dynamic>) {
      throw ContentException('$path must contain a JSON object.');
    }
    return value;
  }

  Future<dynamic> _read(String path) async {
    if (_cache.containsKey(path)) {
      return _cache[path];
    }
    final String text;
    try {
      text = await _loader(path);
    } catch (e) {
      throw ContentException('Could not load $path: $e');
    }
    final dynamic decoded;
    try {
      decoded = jsonDecode(text);
    } on FormatException catch (e) {
      throw ContentException('$path is not valid JSON: ${e.message}');
    }
    _cache[path] = decoded;
    return decoded;
  }

  void _checkUniqueIds(Iterable<String> ids, String path) {
    final seen = <String>{};
    for (final id in ids) {
      if (!seen.add(id)) {
        throw ContentException('Duplicate id "$id" in $path.');
      }
    }
  }
}
