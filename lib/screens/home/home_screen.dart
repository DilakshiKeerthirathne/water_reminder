import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/water_provider.dart';
import '../../widgets/log_tile.dart';
import '../../widgets/progress_widget.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/water_button.dart';
import '../../widgets/header_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final water = Provider.of<WaterProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text("💧 HydroTrack"),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              HeaderCard(current: water.currentWater, goal: water.dailyGoal),

              const SizedBox(height: 15),

              if (water.isGoalReached)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.green),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.emoji_events, color: Colors.green),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "🎉 Congratulations! You reached today's water goal!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 15),

              Center(
                child: ProgressWidget(
                  current: water.currentWater,
                  goal: water.dailyGoal,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                water.motivation,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 25),

              Row(
                children: [
                  StatCard(
                    title: "Consumed",
                    value: "${water.currentWater} ml",
                    icon: Icons.water_drop,
                    color: Colors.blue,
                  ),

                  const SizedBox(width: 10),

                  StatCard(
                    title: "Goal",
                    value: "${water.dailyGoal} ml",
                    icon: Icons.flag,
                    color: Colors.green,
                  ),

                  const SizedBox(width: 10),

                  StatCard(
                    title: "Left",
                    value: "${water.remaining} ml",
                    icon: Icons.hourglass_bottom,
                    color: Colors.orange,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Quick Add",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              Wrap(
                spacing: 15,
                runSpacing: 15,

                children: [
                  WaterButton(
                    amount: 250,
                    onTap: () => water.addWater(250, context),
                  ),

                  WaterButton(
                    amount: 500,
                    onTap: () => water.addWater(500, context),
                  ),

                  WaterButton(
                    amount: 750,
                    onTap: () => water.addWater(750, context),
                  ),

                  WaterButton(
                    amount: 1000,
                    onTap: () => water.addWater(1000, context),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Today's Intake",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              if (water.logs.isEmpty)
                Column(
                  children: [
                    const Icon(Icons.water_drop, size: 60, color: Colors.blue),
                    const SizedBox(height: 10),
                    const Text(
                      "No water logged yet",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 5),
                    const Text("Start drinking water 💧"),
                  ],
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),

                  itemCount: water.logs.length,

                  itemBuilder: (context, index) {
                    return LogTile(log: water.logs[index]);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showGoalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.celebration, color: Colors.orange),
            SizedBox(width: 8),
            Text("Congratulations!"),
          ],
        ),
        content: const Text(
          "🎉 You have reached your daily water intake goal!\n\nKeep staying hydrated!",
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Awesome!"),
          ),
        ],
      ),
    );
  }
}
