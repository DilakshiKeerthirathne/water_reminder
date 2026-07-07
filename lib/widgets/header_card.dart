import 'package:flutter/material.dart';

class HeaderCard extends StatelessWidget {
  final int current;
  final int goal;

  const HeaderCard({super.key, required this.current, required this.goal});

  // Dynamic greeting
  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning ☀️";
    } else if (hour < 17) {
      return "Good Afternoon 🌤";
    } else {
      return "Good Evening 🌙";
    }
  }

  @override
  Widget build(BuildContext context) {
    final percentage = ((current / goal) * 100)
        .clamp(0, 100)
        .toStringAsFixed(0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E88E5), Color(0xFF64B5F6)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getGreeting(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            _getMessage(current, goal),
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.water_drop,
                  color: Colors.white,
                  size: 40,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$current ml",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Goal: $goal ml",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 10),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: current / goal,
                        minHeight: 8,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "$percentage% Completed",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getMessage(int current, int goal) {
    final progress = current / goal;

    if (progress >= 1) {
      return "Goal Achieved! 🎉";
    }

    if (progress >= 0.75) {
      return "Almost There 💪";
    }

    if (progress >= 0.5) {
      return "Keep Going 🚰";
    }

    if (progress >= 0.25) {
      return "Nice Progress 💧";
    }

    return "Stay Hydrated 👋";
  }
}
