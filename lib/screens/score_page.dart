// lib/screens/score_page.dart

import 'package:flutter/material.dart';
import 'settings_overlay.dart';

// --- NEW IMPORTS ---
import 'music_page.dart';
import 'profile_page.dart';
import 'home_page.dart';
import '../utils/smooth_page.dart'; // <--- Import SmoothPageRoute

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  // --- Layout Constants ---
  final double _owlHeight = 150;
  final double _cardTopPosition = 140;
  final double _owlVerticalOffset = -115;

  // --- Color Palette ---
  static const Color _colBackgroundBlue = Color(0xFF8AABC7);
  static const Color _colCardGold = Color(0xFFF7DB9F); // Main Card
  static const Color _colInnerGold = Color(0xFFE1B964); // Quote Card
  static const Color _colTitleRed = Color(0xFF882124);
  static const Color _colScoreGreen = Color(0xFF95A995);
  static const Color _colTextGrey = Color(0xFF676767);
  static const Color _colButtonShadow = Color(0x3F000000);

  // Navigation Icon Color
  static const Color _colNavItem = Color(0xFFE1B964);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colBackgroundBlue,

      // --- UPDATED BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: Container(
        height: 80,
        color: _colBackgroundBlue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 1. Profile Icon -> Navigates to ProfilePage
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  SmoothPageRoute(builder: (_) => const ProfilePage()),
                ); // <--- Smooth
              },
              child: const Icon(Icons.person, color: _colNavItem, size: 32),
            ),

            // 2. Home Icon -> Navigates back to HomePage (Replaced Notes Icon)
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  SmoothPageRoute(
                    builder: (_) => const HomePage(),
                  ), // <--- Smooth
                  (route) => false,
                );
              },
              child: const Icon(Icons.home, color: _colNavItem, size: 32),
            ),

            // 3. Music Icon -> Navigates to MusicPage
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  SmoothPageRoute(builder: (_) => const MusicPage()),
                ); // <--- Smooth
              },
              child: const Icon(Icons.headphones, color: _colNavItem, size: 32),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // --- 1. THE MAIN GOLD CARD ---
            Positioned(
              top: _cardTopPosition,
              bottom: 20,
              left: 24,
              right: 24,
              child: Container(
                decoration: BoxDecoration(
                  color: _colCardGold,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 1, color: Colors.black12),
                ),
                child: Column(
                  children: [
                    // Header: "Score" Title + Close Button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 50, 24, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          const Text(
                            'Score',
                            style: TextStyle(
                              color: _colTitleRed,
                              fontSize: 32,
                              fontFamily: 'Bungee',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.of(context).maybePop(),
                            child: const Icon(
                              Icons.close,
                              color: _colTextGrey,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Score Text "10/10"
                    const SizedBox(height: 10),
                    const Text(
                      '10/10',
                      style: TextStyle(
                        color: _colScoreGreen,
                        fontSize: 64,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Quote Section (Stack used to overlap the Quote Mark)
                    Expanded(
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          // The Quote Box
                          Positioned(
                            top:
                                30, // Pushed down to make room for the quote mark
                            left: 20,
                            right: 20,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                40,
                                20,
                                20,
                              ),
                              decoration: BoxDecoration(
                                color: _colInnerGold,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'A journey of a thousand miles begins with a single step',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _colTextGrey,
                                      fontSize: 20,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // Author Line
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 1,
                                        color: _colTitleRed,
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'lao tzu',
                                        style: TextStyle(
                                          color: _colTextGrey,
                                          fontSize: 16,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // The Big Quote Mark "
                          const Positioned(
                            top: 0,
                            child: Text(
                              '“',
                              style: TextStyle(
                                color: _colTextGrey,
                                fontSize: 100,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w500,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Restart Button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Container(
                        width: 66,
                        height: 40, // Adjusted height for better touch target
                        decoration: BoxDecoration(
                          color: _colTitleRed,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: _colButtonShadow,
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/icons/refresh.png',
                            width: 24,
                            height: 24,
                            color: const Color(0xFFF6DA9F), // Icon Color
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- 2. THE OWL IMAGE (Centered) ---
            Positioned(
              top: _cardTopPosition + _owlVerticalOffset,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/images/happy_owl.png',
                  height: _owlHeight,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // --- 3. FLOATING ICONS (Top Right) ---

            // SETTINGS ICON (With Overlay Trigger)
            Positioned(
              top: 10,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const SettingsOverlay(),
                  );
                },
                child: const Icon(
                  Icons.settings,
                  color: Color(0xFFE1B964),
                  size: 30,
                ),
              ),
            ),

            // VOLUME ICON
            Positioned(
              top: 50,
              right: 20,
              child: const Icon(
                Icons.volume_up,
                color: Color(0xFFE1B964),
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
