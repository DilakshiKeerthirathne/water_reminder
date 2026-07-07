import 'dart:async';

import 'package:flutter/material.dart';

import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _iconAnimation = Tween<double>(
      begin: 0.8,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _textAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.repeat(reverse: true);

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF42A5F5), Color(0xFF1565C0)],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 2),
                    ),
                    child: Transform.scale(
                      scale: _iconAnimation.value,
                      child: const Icon(
                        Icons.water_drop,
                        size: 120,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  FadeTransition(
                    opacity: _textAnimation,
                    child: const Text(
                      "HydroTrack",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  FadeTransition(
                    opacity: _textAnimation,
                    child: const Text(
                      "Stay Hydrated • Stay Healthy",

                      style: TextStyle(color: Colors.white70, fontSize: 17),
                    ),
                  ),

                  const SizedBox(height: 50),

                  const SizedBox(
                    width: 35,
                    height: 35,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
