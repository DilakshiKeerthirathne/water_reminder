import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/water_log.dart';

class StorageService {
  static const String _waterKey = "current_water";
  static const String _goalKey = "daily_goal";
  static const String _logsKey = "water_logs";

  static Future<void> saveWater(int water) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_waterKey, water);
  }

  static Future<int> getWater() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_waterKey) ?? 0;
  }

  static Future<void> saveGoal(int goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_goalKey, goal);
  }

  static Future<int> getGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_goalKey) ?? 2000;
  }

  static Future<void> saveLogs(List<WaterLog> logs) async {
    final prefs = await SharedPreferences.getInstance();

    final list = logs.map((e) => jsonEncode(e.toJson())).toList();

    await prefs.setStringList(_logsKey, list);
  }

  static Future<List<WaterLog>> getLogs() async {
    final prefs = await SharedPreferences.getInstance();

    final list = prefs.getStringList(_logsKey) ?? [];

    return list.map((e) => WaterLog.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_waterKey);
    await prefs.remove(_goalKey);
    await prefs.remove(_logsKey);
  }
}
