import 'package:flutter/material.dart';

import '../screens/about_page.dart';
import '../utils/app_colors.dart';
import '../utils/smooth_page.dart';
import '../widgets/exit_overlay.dart';

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
            width: 200,
            height: 220,
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
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Transform.translate(
                      offset: const Offset(8, 0),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.close, color: Colors.white, size: 28),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildOverlayButton(
                    label: 'about',
                    backgroundColor: const Color(0xFFF7DB9F),
                    textColor: const Color(0xFF8B0000),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        SmoothPageRoute(
                          builder: (context) => const AboutPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildOverlayButton(
                    label: 'exit',
                    backgroundColor: const Color(0xFF882225),
                    textColor: Colors.white,
                    onPressed: () {
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

  Widget _buildOverlayButton({
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return Center(
      child: SizedBox(
        width: 148,
        height: 44,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.25),
            padding: EdgeInsets.zero,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
