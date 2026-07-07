import 'package:flutter/material.dart';

class FloatingWaterAnimation extends StatefulWidget {
  final String text;

  const FloatingWaterAnimation({super.key, required this.text});

  @override
  State<FloatingWaterAnimation> createState() => _FloatingWaterAnimationState();
}

class _FloatingWaterAnimationState extends State<FloatingWaterAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: TweenAnimationBuilder(
          tween: Tween(begin: 0.0, end: -80.0),
          duration: const Duration(milliseconds: 900),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, value),
              child: Opacity(opacity: 1 - (-value / 80), child: child),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
