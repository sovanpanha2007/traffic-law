import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/quiz_result.dart';

abstract class ProgressStorage {
  Future<List<QuizResult>> loadResults();

  Future<void> saveResult(QuizResult result);

  Future<List<String>> loadMistakeIds();

  Future<void> saveMistakeIds(List<String> ids);

  Future<void> resetAll();
}

class SharedPrefsProgressStorage implements ProgressStorage {
  static const resultsKey = 'quiz_results';
  static const mistakesKey = 'mistake_ids';

  @override
  Future<List<QuizResult>> loadResults() async {
    final prefs = await SharedPreferences.getInstance();
    final text = prefs.getString(resultsKey);
    if (text == null) {
      return [];
    }
    final list = jsonDecode(text) as List;
    return list.map((e) => QuizResult.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> saveResult(QuizResult result) async {
    final results = await loadResults();
    results.add(result);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      resultsKey,
      jsonEncode(results.map((r) => r.toJson()).toList()),
    );
  }

  @override
  Future<List<String>> loadMistakeIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(mistakesKey) ?? [];
  }

  @override
  Future<void> saveMistakeIds(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(mistakesKey, ids);
  }

  @override
  Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(resultsKey);
    await prefs.remove(mistakesKey);
  }
}
