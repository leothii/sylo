// lib/screens/profile_page.dart

import 'package:flutter/material.dart';
import 'settings_overlay.dart';
import '../widgets/sylo_chat_overlay.dart';
import 'music_page.dart'; // <--- Import MusicPage
import 'notes_page.dart'; // <--- Import NotesPage

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // --- Controllers for Input Fields ---
  final TextEditingController _nameController = TextEditingController(
    text: 'name',
  );
  final TextEditingController _securityController = TextEditingController(
    text: 'security',
  );

  // --- Layout Constants ---
  final double _owlHeight = 150;
  final double _cardTopPosition = 160;
  final double _owlVerticalOffset = -115;

  // --- Color Palette ---
  static const Color _colBackgroundBlue = Color(0xFF8AABC7);
  static const Color _colCardOverlay = Color(
    0x26000000,
  ); // Black with ~15% opacity
  static const Color _colFieldCream = Color(0xFFF8EFDC);
  static const Color _colTitleGold = Color(0xFFF7DB9F);
  static const Color _colBtnRed = Color(0xFF882124);
  static const Color _colTextGrey = Color(0xFF676767);
  static const Color _colIconGrey = Color(0xFF676767);
  static const Color _colNavItem = Color(0xFFE1B964); // Inactive Icon
  static const Color _colNavActiveBg = Color(
    0xFF7591A9,
  ); // Active Blue Background

  @override
  void dispose() {
    _nameController.dispose();
    _securityController.dispose();
    super.dispose();
  }

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
            // 1. Profile Icon (ACTIVE) -> Has Blue Indicator
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _colNavActiveBg, // Blue background
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
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

            // 3. Music Icon -> Navigates to MusicPage
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const MusicPage()),
                );
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
            // --- 1. THE MAIN CARD ---
            Positioned(
              top: _cardTopPosition,
              bottom: 100,
              left: 35,
              right: 35,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: _colCardOverlay,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    // Spacer for Owl overlap
                    const SizedBox(height: 40),

                    // "PROFILE" Title
                    const Text(
                      'PROFILE',
                      style: TextStyle(
                        color: _colTitleGold,
                        fontSize: 32,
                        fontFamily: 'Bungee',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.5,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // "Name" Input Field
                    _buildInputField(
                      controller: _nameController,
                      icon: Icons.edit,
                    ),

                    const SizedBox(height: 20),

                    // "Security" Input Field
                    _buildInputField(
                      controller: _securityController,
                      icon: Icons.arrow_forward_ios_rounded,
                      iconSize: 20,
                    ),

                    const SizedBox(height: 40),

                    // Save Button
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profile Saved!')),
                        );
                      },
                      child: Container(
                        width: 120,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _colBtnRed,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'save',
                            style: TextStyle(
                              color: _colTitleGold,
                              fontSize: 20,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w700,
                            ),
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
                  color: Color(0xFFF7DB9F),
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
                color: Color(0xFFF7DB9F),
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper that returns a TextField
  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    double iconSize = 24,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _colFieldCream,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          color: _colTextGrey,
          fontSize: 18,
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          suffixIcon: Icon(icon, color: _colIconGrey, size: iconSize),
        ),
      ),
    );
  }
}
