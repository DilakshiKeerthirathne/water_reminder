class ReminderSettings {
  bool enabled;
  int startHour;
  int startMinute;
  int endHour;
  int endMinute;
  int interval;

  ReminderSettings({
    required this.enabled,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.interval,
  });
}
