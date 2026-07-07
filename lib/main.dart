import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:water_reminder/screens/splash_screen.dart';
import 'package:water_reminder/services/notification_service.dart';

import 'providers/water_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();

  await Permission.notification.request();
  runApp(const HydroTrack());
}

class HydroTrack extends StatelessWidget {
  const HydroTrack({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WaterProvider(),

      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        title: "HydroTrack",

        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFFF5F9FF),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          cardTheme: CardThemeData(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),

        home: const SplashScreen(),
      ),
    );
  }
}
