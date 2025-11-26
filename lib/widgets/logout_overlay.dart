// lib/widgets/logout_overlay.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/login_page.dart'; // <--- Import your Login Page

class LogoutOverlay extends StatelessWidget {
  const LogoutOverlay({super.key});

  // --- Color Palette (Same as ExitOverlay) ---
  static const Color _colCardBackground = Color(0xFF7591A9);
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
                  'are you sure\nyou want to\nlog out?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _colTextCream,
                    fontSize: 24,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w700,
                    height: 1.2,
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
                    // Yes Button (Performs Logout)
                    _buildButton(
                      context,
                      label: 'yes',
                      bgColor: _colBtnRed,
                      textColor: _colTextCream,
                      onTap: () async {
                        // 1. Close the overlay
                        Navigator.of(context).pop();

                        // 2. Sign out from Firebase
                        try {
                          await FirebaseAuth.instance.signOut();
                        } catch (e) {
                          debugPrint("Error signing out: $e");
                        }

                        // 3. Go to Login Page
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- Sad Owl Image ---
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
