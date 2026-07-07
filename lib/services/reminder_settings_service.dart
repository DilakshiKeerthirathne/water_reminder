import 'package:shared_preferences/shared_preferences.dart';
import '../models/reminder_settings.dart';

class ReminderSettingsService {
  static Future<void> save(ReminderSettings settings) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool("enabled", settings.enabled);
    await prefs.setInt("startHour", settings.startHour);
    await prefs.setInt("startMinute", settings.startMinute);
    await prefs.setInt("endHour", settings.endHour);
    await prefs.setInt("endMinute", settings.endMinute);
    await prefs.setInt("interval", settings.interval);
  }

  static Future<ReminderSettings> load() async {
    final prefs = await SharedPreferences.getInstance();

    return ReminderSettings(
      enabled: prefs.getBool("enabled") ?? true,
      startHour: prefs.getInt("startHour") ?? 8,
      startMinute: prefs.getInt("startMinute") ?? 0,
      endHour: prefs.getInt("endHour") ?? 22,
      endMinute: prefs.getInt("endMinute") ?? 0,
      interval: prefs.getInt("interval") ?? 2,
    );
  }
}
