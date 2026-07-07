import 'package:flutter/material.dart';

class WaterButton extends StatefulWidget {
  final int amount;
  final VoidCallback onTap;

  const WaterButton({super.key, required this.amount, required this.onTap});

  @override
  State<WaterButton> createState() => _WaterButtonState();
}

class _WaterButtonState extends State<WaterButton> {
  double scale = 1.0;
  double iconScale = 1.0;

  void _animateTap() async {
    setState(() {
      scale = 0.92;
      iconScale = 0.8;
    });

    await Future.delayed(const Duration(milliseconds: 80));

    setState(() {
      scale = 1.05;
      iconScale = 1.2;
    });

    await Future.delayed(const Duration(milliseconds: 80));

    setState(() {
      scale = 1.0;
      iconScale = 1.0;
    });

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _animateTap,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutBack,
        child: Container(
          width: 95,
          height: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: iconScale,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOutBack,
                child: const Icon(
                  Icons.local_drink,
                  color: Colors.white,
                  size: 34,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "${widget.amount} ml",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
