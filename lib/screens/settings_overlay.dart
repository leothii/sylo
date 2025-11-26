import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/smooth_page.dart';
import '../utils/streak_service.dart'; // Make sure this import exists
import '../widgets/streak_overlay.dart';
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

                  // --- STREAK BUTTON (UPDATED) ---
                  _buildOverlayButton(
                    context,
                    'streak',
                    const Color(0xFFF7DB9F),
                    const Color(0xFF8B0000),
                    () async {
                      // 1. Close settings overlay
                      Navigator.of(context).pop();

                      // 2. Fetch correct data
                      final int count = await StreakService.getStreakCount();
                      final Set<int> activeDays =
                          await StreakService.getActiveWeekdays();

                      if (context.mounted) {
                        // 3. Show Streak Overlay with correct params
                        showDialog(
                          context: context,
                          barrierColor: Colors.black.withOpacity(0.6),
                          builder: (context) => StreakOverlay(
                            currentStreak: count, // Pass exact count (0 if 0)
                            activeWeekdays: activeDays, // Pass the Set<int>
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
