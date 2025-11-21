// lib/screens/music_page.dart

import 'package:flutter/material.dart';
import 'settings_overlay.dart';
import '../widgets/sylo_chat_overlay.dart';
import '../widgets/connecting_overlay.dart'; // <--- Import ConnectOverlay
import 'profile_page.dart';
import 'notes_page.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  // --- Layout Constants ---
  final double _owlHeight = 150;
  final double _cardTopPosition = 160;
  final double _owlVerticalOffset = -115;

  // --- Color Palette ---
  static const Color _colBackgroundBlue = Color(0xFF8AABC7);
  static const Color _colCardBlue = Color(0xFF7591A9); // Main player card
  static const Color _colBtnCream = Color(0xFFF7DB9F);
  static const Color _colBtnGold = Color(0xFFE1B964);
  static const Color _colIconCream = Color(0xFFF7DB9F);
  static const Color _colTextGrey = Color(0xFF898989);
  static const Color _colNavItem = Color(0xFFE1B964); // Inactive Icon
  static const Color _colNavActiveBg = Color(
    0xFF7591A9,
  ); // Active Blue Background
  static const Color _colShadow = Color(0x3F000000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colBackgroundBlue,
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        height: 80,
        color: _colBackgroundBlue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 1. Profile Icon -> Navigates to ProfilePage
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
              child: const Icon(Icons.person, color: _colNavItem, size: 32),
            ),

            // 2. Notes Icon -> Navigates to NotesPage
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const NotesPage()),
                );
              },
              child: const Icon(Icons.menu_book, color: _colNavItem, size: 32),
            ),

            // 3. Headphones Icon (ACTIVE) -> Has Blue Indicator
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _colNavActiveBg, // Blue background indicator
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.headphones, color: _colNavItem, size: 32),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // --- 1. THE MAIN MUSIC CARD ---
            Positioned(
              top: _cardTopPosition,
              bottom: 100,
              left: 24,
              right: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  color: _colCardBlue,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Close Button
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white70,
                          size: 28,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Playback Controls (Prev, Pause, Next)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.skip_previous,
                          color: _colIconCream,
                          size: 36,
                        ),
                        SizedBox(width: 24),
                        Icon(Icons.pause, color: _colIconCream, size: 36),
                        SizedBox(width: 24),
                        Icon(Icons.skip_next, color: _colIconCream, size: 36),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Custom Progress Bar
                    SizedBox(
                      height: 20,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          // Background Line
                          Container(
                            height: 2,
                            width: double.infinity,
                            color: Colors.white30,
                          ),
                          // Active Progress Line
                          Container(
                            height: 2,
                            width: 100,
                            color: _colIconCream,
                          ),
                          // Thumb Circle
                          Positioned(
                            left: 100,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: const BoxDecoration(
                                color: _colIconCream,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // "Upload an Audio" Button
                    _buildActionButton(
                      text: 'upload an audio',
                      icon: Icons.file_upload_outlined,
                      bgColor: _colBtnCream,
                      textColor: _colTextGrey,
                      onTap: () {
                        print("Upload audio tapped");
                      },
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'or',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // "Logged as user" Button -> Opens Connect Overlay
                    _buildActionButton(
                      text: 'logged as user*',
                      icon: Icons.wifi,
                      bgColor: _colBtnGold,
                      textColor: _colTextGrey,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const ConnectOverlay(),
                        );
                      },
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
                child: GestureDetector(
                  onTap: () => showSyloChatOverlay(context),
                  child: Image.asset(
                    'assets/images/sylo.png',
                    height: _owlHeight,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // --- 3. FLOATING ICONS (Top Right) ---
            // SETTINGS ICON
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

  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 46,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(color: _colShadow, blurRadius: 4, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
