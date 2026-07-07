import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/water_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _ = context.watch<WaterProvider>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text("Hydration History"),
      ),
      body: Consumer<WaterProvider>(
        builder: (context, water, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildCard(
                        title: "Today",
                        value: "${water.todayTotal} ml",
                        icon: Icons.today,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: _buildCard(
                        title: "Week",
                        value: "${water.weeklyTotal} ml",
                        icon: Icons.calendar_view_week,
                        color: Colors.green,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: _buildCard(
                        title: "Month",
                        value: "${water.monthlyTotal} ml",
                        icon: Icons.calendar_month,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Daily Records",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: water.history.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.water_drop_outlined,
                                size: 70,
                                color: Colors.blueGrey,
                              ),
                              SizedBox(height: 15),
                              Text(
                                "No hydration history yet",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Start drinking water to build your history!",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: water.history.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            // Show latest records first
                            final item =
                                water.history[water.history.length - 1 - index];

                            final _ = DateTime.parse(item.date);

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),

                                leading: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.blue.shade100,
                                  child: const Icon(
                                    Icons.water_drop,
                                    color: Colors.blue,
                                  ),
                                ),

                                title: Text(
                                  "${item.total} ml",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),

                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(item.date),
                                ),

                                trailing: item.total >= water.dailyGoal
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade100,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: const Text(
                                          "Goal ✓",
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade100,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          "${water.dailyGoal - item.total} ml left",
                                          style: const TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withOpacity(0.15),
                child: Icon(icon, color: color, size: 28),
              ),

              const SizedBox(height: 14),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
