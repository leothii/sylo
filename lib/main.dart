// lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/launch_screen.dart'; // Import the new LaunchScreen
import 'services/sound_service.dart';
import 'utils/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
  await SoundService.instance.initialize();
  runApp(const SyloApp());
}

class SyloApp extends StatelessWidget {
  const SyloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sylo: The Academic AI Companion',

      theme: ThemeData(
        primaryColor:
            AppColors.primarySylo, // Assuming this is your brand's main color
        scaffoldBackgroundColor:
            AppColors.primaryBackground, // Use your Figma frame color
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primarySylo),
        useMaterial3: true,
      ),

      // THIS IS THE KEY CHANGE: Set LaunchScreen as the app's starting page
      home: const LaunchScreen(),
    );
  }
}
