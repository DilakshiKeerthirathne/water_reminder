import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_reminder/services/history_service.dart';
import '../widgets/celebration_dialog.dart';
import '../widgets/floating_water_animation.dart';
import '../models/water_log.dart';
import '../services/storage_service.dart';
import '../models/daily_history.dart';
import 'package:intl/intl.dart';

class WaterProvider extends ChangeNotifier {
  int dailyGoal = 2000;

  int currentWater = 0;
  DateTime? lastOpenedDate;
  List<DailyHistory> history = [];

  final List<WaterLog> logs = [];

  WaterProvider() {
    loadData();
  }
  bool get isGoalReached {
    return currentWater >= dailyGoal;
  }

  double get progress => dailyGoal == 0 ? 0 : currentWater / dailyGoal;

  int get remaining {
    final remain = dailyGoal - currentWater;
    return remain < 0 ? 0 : remain;
  }

  int get todayTotal => currentWater;

  int get weeklyTotal {
    final now = DateTime.now();

    return history
        .where((item) {
          final date = DateTime.parse(item.date);
          return now.difference(date).inDays < 7;
        })
        .fold(0, (sum, item) => sum + item.total);
  }

  int get monthlyTotal {
    final now = DateTime.now();

    return history
        .where((item) {
          final date = DateTime.parse(item.date);

          return date.month == now.month && date.year == now.year;
        })
        .fold(0, (sum, item) => sum + item.total);
  }

  String get motivation {
    final p = progress;

    if (p == 0) {
      return "Start your hydration journey 💧";
    } else if (p < 0.5) {
      return "Keep going 💪";
    } else if (p < 0.8) {
      return "You're doing great 🔥";
    } else if (p < 1) {
      return "Almost there 🚀";
    } else {
      return "Goal completed 🎉";
    }
  }

  Future<void> loadData() async {
    currentWater = await StorageService.getWater();
    dailyGoal = await StorageService.getGoal();

    logs.clear();
    logs.addAll(await StorageService.getLogs());
    await _checkNewDay();
    history = await HistoryService.load();

    notifyListeners();
  }

  Future<void> updateDailyHistory() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final index = history.indexWhere((e) => e.date == today);

    if (index == -1) {
      history.add(DailyHistory(date: today, total: currentWater));
    } else {
      history[index].total = currentWater;
    }

    await HistoryService.save(history);
  }

  Future<void> _checkNewDay() async {
    final today = DateTime.now();

    final prefs = await SharedPreferences.getInstance();
    final lastDateString = prefs.getString("last_date");

    if (lastDateString != null) {
      final lastDate = DateTime.parse(lastDateString);

      if (lastDate.day != today.day ||
          lastDate.month != today.month ||
          lastDate.year != today.year) {
        // NEW DAY → reset daily progress
        currentWater = 0;

        await StorageService.saveWater(0);
      }
    }

    await prefs.setString("last_date", today.toIso8601String());
  }

  Future<void> _save() async {
    await StorageService.saveWater(currentWater);
    await StorageService.saveGoal(dailyGoal);
    await StorageService.saveLogs(logs);
  }

  Future<void> addWater(int amount, BuildContext context) async {
    await HapticFeedback.mediumImpact();
    currentWater += amount;
    await updateDailyHistory();

    logs.insert(0, WaterLog(amount: amount, time: DateTime.now()));

    await _save();

    notifyListeners();
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: Duration.zero,
      pageBuilder: (_, _, _) {
        return FloatingWaterAnimation(text: "💧 +$amount ml");
      },
    );

    if (isGoalReached) {
      CelebrationDialog.show(context);
    }
  }

  Future<void> updateGoal(int goal) async {
    dailyGoal = goal;

    await _save();

    notifyListeners();
  }

  Future<void> resetToday() async {
    currentWater = 0;

    logs.clear();
    await updateDailyHistory();

    await _save();

    notifyListeners();
  }
}
