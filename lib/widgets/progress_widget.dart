import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProgressWidget extends StatelessWidget {
  final int current;
  final int goal;

  const ProgressWidget({super.key, required this.current, required this.goal});

  @override
  Widget build(BuildContext context) {
    final percent = (current / goal).clamp(0.0, 1.0);

    Color progressColor;

    if (percent >= 1.0) {
      progressColor = Colors.green;
    } else if (percent >= 0.75) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.blue;
    }

    return CircularPercentIndicator(
      radius: 95,
      lineWidth: 14,
      animation: true,
      animationDuration: 1000,
      percent: percent,
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: progressColor,
      backgroundColor: Colors.grey.shade200,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.water_drop, color: Colors.blue, size: 32),

          const SizedBox(height: 8),

          Text(
            "$current ml",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          Text("$goal ml Goal", style: const TextStyle(color: Colors.grey)),

          const SizedBox(height: 8),

          Text(
            "${(percent * 100).toInt()}%",
            style: TextStyle(
              color: progressColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
