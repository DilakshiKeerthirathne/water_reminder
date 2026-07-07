import 'package:flutter/material.dart';

class HydrationInsightCard extends StatelessWidget {
  final int current;
  final int goal;

  const HydrationInsightCard({
    super.key,
    required this.current,
    required this.goal,
  });

  String get message {
    final progress = current / goal;

    if (progress == 0) {
      return "Start your hydration journey 💧";
    }

    if (progress < .5) {
      return "Keep drinking water to stay healthy 💙";
    }

    if (progress < .8) {
      return "Great job! You're halfway there 👏";
    }

    if (progress < 1) {
      return "Almost there! One more glass 🚀";
    }

    return "Excellent! You reached today's goal 🎉";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.amber),
                SizedBox(width: 8),
                Text(
                  "Hydration Insight",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _item("Goal", "$goal ml"),

                _item("Consumed", "$current ml"),

                _item("Left", "${(goal - current).clamp(0, goal)} ml"),
              ],
            ),

            const SizedBox(height: 18),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.blueGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),

        const SizedBox(height: 5),

        Text(title),
      ],
    );
  }
}
