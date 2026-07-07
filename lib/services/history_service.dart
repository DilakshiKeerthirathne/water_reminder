import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/daily_history.dart';

class HistoryService {
  static const String key = "daily_history";

  static Future<List<DailyHistory>> load() async {
    final prefs = await SharedPreferences.getInstance();

    final list = prefs.getStringList(key) ?? [];

    return list.map((e) => DailyHistory.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> save(List<DailyHistory> history) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      key,
      history.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }
}
