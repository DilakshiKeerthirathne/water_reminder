import 'package:flutter/material.dart';

class CelebrationDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.celebration, size: 60, color: Colors.orange),
            SizedBox(height: 10),
            Text(
              "Great Job! 🎉",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("You reached your daily water goal!"),
          ],
        ),
      ),
    );
  }
}
