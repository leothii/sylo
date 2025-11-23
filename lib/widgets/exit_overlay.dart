// lib/widgets/exit_overlay.dart

import 'dart:io'; // Required for exit(0)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExitOverlay extends StatelessWidget {
  const ExitOverlay({super.key});

  // --- Color Palette ---
  static const Color _colCardBackground = Color(0xFF7591A9); // Blue-Grey
  static const Color _colTextCream = Color(0xFFF6DA9F);
  static const Color _colBtnRed = Color(0xFF882124);
  static const Color _colBtnCream = Color(0xFFF6DA9F);
  static const Color _colTextGrey = Color(0xFF898989);
  static const Color _colShadow = Color(0x3F000000);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // --- Main Card ---
          Container(
            width: 300,
            margin: const EdgeInsets.only(top: 60),
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
            decoration: BoxDecoration(
              color: _colCardBackground,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title Text
                const Text(
                  'continue to exit?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _colTextCream,
                    fontSize: 28,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 30),

                // Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Cancel Button
                    _buildButton(
                      context,
                      label: 'cancel',
                      bgColor: _colBtnCream,
                      textColor: _colTextGrey,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    // Yes Button
                    _buildButton(
                      context,
                      label: 'yes',
                      bgColor: _colBtnRed,
                      textColor: _colTextCream,
                      onTap: () {
                        // Add your specific exit logic here (e.g., exit app)
                        debugPrint('User confirmed exit');
                        Navigator.of(context).pop();
                        debugPrint(
                          "Exit button pressed - attempting to close app",
                        );

                        // 1. Try the standard way (Android)
                        SystemNavigator.pop();

                        // 2. Force Exit (Works on iOS/Android if standard way fails)
                        // We use a tiny delay to let the UI register the tap effect first
                        Future.delayed(const Duration(milliseconds: 100), () {
                          exit(0);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- Crying Owl Image (Top Center) ---
          Positioned(
            top: -26,
            child: Image.asset(
              'assets/images/sad_owl.png',
              height: 110,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String label,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          width: 92,
          height: 36,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(color: _colShadow, blurRadius: 4, offset: Offset(0, 4)),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
