import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/water_log.dart';

class LogTile extends StatelessWidget {
  final WaterLog log;

  const LogTile({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.water_drop, color: Colors.white),
        ),
        title: Text("${log.amount} ml"),
        subtitle: Text(DateFormat('hh:mm a').format(log.time)),
      ),
    );
  }
}
