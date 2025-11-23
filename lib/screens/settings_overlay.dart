// lib/widgets/settings_overlay.dart

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/exit_overlay.dart';
import '../widgets/language_overlay.dart';
import '../screens/about_page.dart'; // <--- Import AboutPage

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
              boxShadow: const [
                BoxShadow(
                  color: Color(0x40000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
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
                  _buildOverlayButton(
                    context,
                    'home',
                    const Color(0xFFF7DB9F),
                    const Color(0xFF8B0000),
                    () {
                      // Navigate Home logic here
                      debugPrint('Home button pressed!');
                    },
                  ),
                  const SizedBox(height: 15),

                  // --- LANGUAGE BUTTON ---
                  _buildOverlayButton(
                    context,
                    'language',
                    const Color(0xFFF7DB9F),
                    const Color(0xFF8B0000),
                    () {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (context) => const LanguageOverlay(),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  // --- ABOUT BUTTON (UPDATED) ---
                  _buildOverlayButton(
                    context,
                    'about',
                    const Color(0xFFF7DB9F),
                    const Color(0xFF8B0000),
                    () {
                      // 1. Close the Settings Overlay
                      Navigator.of(context).pop();

                      // 2. Navigate to About Page
                      Navigator.of(context).push(
                        MaterialPageRoute(
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
          shadowColor: const Color(0x40000000),
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
