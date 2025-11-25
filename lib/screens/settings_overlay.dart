// lib/widgets/settings_overlay.dart

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/smooth_page.dart';
import '../utils/streak_service.dart'; // <--- IMPORT THE LOGIC (SERVICE)
import '../widgets/streak_overlay.dart'; // <--- IMPORT THE UI (WIDGET)
import '../widgets/exit_overlay.dart';
import '../screens/about_page.dart';
import '../screens/notes_page.dart';

class SettingsOverlay extends StatelessWidget {
  const SettingsOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 217,
            height: 328,
            margin: const EdgeInsets.only(top: 60),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.primaryBackground,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 25.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(height: 5),

                  // --- NOTES BUTTON ---
                  _buildOverlayButton(
                    context,
                    'notes',
                    const Color(0xFFF7DB9F),
                    const Color(0xFF8B0000),
                    () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        SmoothPageRoute(
                          builder: (context) => const NotesPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),

                  // --- STREAK BUTTON (FIXED LOGIC) ---
                  _buildOverlayButton(
                    context,
                    'streak',
                    const Color(0xFFF7DB9F),
                    const Color(0xFF8B0000),
                    () async {
                      // 1. Close the Settings Overlay first
                      Navigator.of(context).pop();

                      // 2. Get the real streak count using the SERVICE (Logic)
                      final streakService = StreakService();
                      final int count = await streakService.getCurrentStreak();

                      if (context.mounted) {
                        // 3. Show the Streak OVERLAY (UI) with the real number
                        showDialog(
                          context: context,
                          barrierColor: Colors.black.withOpacity(0.6),
                          builder: (context) => StreakOverlay(
                            currentStreak: count == 0 ? 1 : count,
                            // If 0, we show 1 for motivation, or remove this check if you prefer 0.
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 15),

                  // --- ABOUT BUTTON ---
                  _buildOverlayButton(
                    context,
                    'about',
                    const Color(0xFFF7DB9F),
                    const Color(0xFF8B0000),
                    () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        SmoothPageRoute(
                          builder: (context) => const AboutPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),

                  // --- EXIT BUTTON ---
                  _buildOverlayButton(
                    context,
                    'exit',
                    const Color(0xFF882225),
                    Colors.white,
                    () {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (context) => const ExitOverlay(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -30,
            child: Image.asset('assets/images/sylo.png', height: 120),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayButton(
    BuildContext context,
    String text,
    Color backgroundColor,
    Color textColor,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.25),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
