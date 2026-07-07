import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/reminder_settings.dart';
import '../../services/reminder_settings_service.dart';
import '../../providers/water_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool remindersOn = true;

  TimeOfDay startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 22, minute: 0);

  int interval = 2;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await ReminderSettingsService.load();

    setState(() {
      remindersOn = settings.enabled;
      startTime = TimeOfDay(
        hour: settings.startHour,
        minute: settings.startMinute,
      );
      endTime = TimeOfDay(hour: settings.endHour, minute: settings.endMinute);
      interval = settings.interval;
    });
  }

  @override
  Widget build(BuildContext context) {
    final water = context.watch<WaterProvider>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text(
          "⚙ Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Personalize Your Hydration",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            const Text(
              "Customize your daily goal and reminder preferences.",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),

            const SizedBox(height: 25),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.flag, color: Colors.white),
                ),
                title: const Text("Daily Goal"),
                subtitle: Text("${water.dailyGoal} ml"),
                trailing: const Icon(Icons.edit),
                onTap: () => _editGoal(context, water),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: SwitchListTile(
                value: remindersOn,
                onChanged: (value) {
                  setState(() {
                    remindersOn = value;
                  });
                },
                secondary: const CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.notifications, color: Colors.white),
                ),
                title: const Text("Water Reminder"),
                subtitle: const Text("Enable reminder notifications"),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.amber,
                  child: Icon(Icons.wb_sunny, color: Colors.white),
                ),
                title: const Text("Start Time"),
                subtitle: Text(startTime.format(context)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: startTime,
                  );

                  if (picked != null) {
                    setState(() => startTime = picked);
                  }
                },
              ),
            ),

            const SizedBox(height: 15),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.indigo,
                  child: Icon(Icons.nightlight_round, color: Colors.white),
                ),
                title: const Text("End Time"),
                subtitle: Text(endTime.format(context)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: endTime,
                  );

                  if (picked != null) {
                    setState(() => endTime = picked);
                  }
                },
              ),
            ),

            const SizedBox(height: 15),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.timer, color: Colors.white),
                ),
                title: const Text("Reminder Interval"),
                subtitle: Text("Every $interval hour(s)"),
                trailing: DropdownButton<int>(
                  value: interval,
                  underline: const SizedBox(),
                  items: [1, 2, 3, 4]
                      .map(
                        (e) => DropdownMenuItem(value: e, child: Text("$e h")),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        interval = value;
                      });
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.refresh, color: Colors.white),
                ),
                title: const Text("Reset Today's Progress"),
                subtitle: const Text("Clear today's water intake"),
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Reset Progress"),
                      content: const Text(
                        "Are you sure you want to reset today's progress?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Reset"),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await water.resetToday();

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Today's progress has been reset."),
                        ),
                      );
                    }
                  }
                },
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text(
                  "Save Settings",
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () async {
                  await ReminderSettingsService.save(
                    ReminderSettings(
                      enabled: remindersOn,
                      startHour: startTime.hour,
                      startMinute: startTime.minute,
                      endHour: endTime.hour,
                      endMinute: endTime.minute,
                      interval: interval,
                    ),
                  );

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.green,
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 10),
                            Text("Settings saved successfully"),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 25),
            Center(
              child: Column(
                children: const [
                  Text(
                    "HydroTrack v1.0",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),

                  SizedBox(height: 6),

                  Text(
                    "Stay Hydrated • Stay Healthy 💙",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _editGoal(BuildContext context, WaterProvider water) {
    final controller = TextEditingController(text: water.dailyGoal.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Set Daily Goal (ml)"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "2000"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(controller.text);

              if (value != null && value > 0) {
                water.updateGoal(value);
              }

              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
