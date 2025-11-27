// lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/launch_screen.dart'; // Points to the "Bouncer" screen
import 'services/sound_service.dart';
import 'utils/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 2. System UI Settings
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

  // 3. Initialize Sound
  await SoundService.instance.initialize();

  runApp(const SyloApp());
}

class SyloApp extends StatelessWidget {
  const SyloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sylo: The Academic AI Companion',

      // Removes the "DEBUG" ribbon from the top right corner
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primaryColor: AppColors.primarySylo,
        scaffoldBackgroundColor: AppColors.primaryBackground,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primarySylo),
        useMaterial3: true,
      ),

      // 4. Start at LaunchScreen
      // It acts as the "Bouncer": Waits 3s -> Checks User -> Sends to Home or Login
      home: const LaunchScreen(),
    );
  }
}
