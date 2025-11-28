// lib/screens/profile_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'settings_overlay.dart';
import '../widgets/logout_overlay.dart';
import '../widgets/sylo_chat_overlay.dart';
import '../widgets/icon_badge.dart';
import '../widgets/sound_toggle_button.dart';
import 'music_page.dart';
import 'home_page.dart';
import '../utils/smooth_page.dart'; // <--- Import SmoothPageRoute

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;

  User? _user;
  bool _isSavingProfile = false;

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
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    final String initialName = _user?.displayName?.trim() ?? '';
    _nameController = TextEditingController(text: initialName);
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colBackgroundBlue,
      // Bottom Navigation Bar
      bottomNavigationBar: ColoredBox(
        color: _colBackgroundBlue,
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            height: 80,
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

                // 2. Home Icon -> Navigates back to HomePage
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      SmoothPageRoute(builder: (_) => const HomePage()),
                      (route) => false,
                    );
                  },
                  child: const Icon(Icons.home, color: _colNavItem, size: 32),
                ),

                // 3. Music Icon -> Navigates to MusicPage
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      SmoothPageRoute(builder: (_) => const MusicPage()),
                    );
                  },
                  child: const Icon(
                    Icons.headphones,
                    color: _colNavItem,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Spacer for owl overlap
                      const SizedBox(height: 40),

                      // "PROFILE" Title
                      const Center(
                        child: Text(
                          'PROFILE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _colTitleGold,
                            fontSize: 32,
                            fontFamily: 'Bungee',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Name input
                      _buildInputField(
                        controller: _nameController,
                        hintText: 'Full name',
                        icon: Icons.edit,
                      ),

                      const SizedBox(height: 20),

                      // Email display (read-only)
                      if (_user?.email != null && _user!.email!.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
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
                          child: Row(
                            children: [
                              const Icon(
                                Icons.email_outlined,
                                color: _colIconGrey,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _user!.email!,
                                  style: const TextStyle(
                                    color: _colTextGrey,
                                    fontSize: 16,
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      if (_user?.email != null && _user!.email!.isNotEmpty)
                        const SizedBox(height: 24),

                      _buildInputField(
                        controller: _newPasswordController,
                        hintText: 'New password',
                        icon: Icons.lock_outline,
                        obscureText: true,
                      ),

                      const SizedBox(height: 16),

                      _buildInputField(
                        controller: _confirmPasswordController,
                        hintText: 'Confirm new password',
                        icon: Icons.lock_reset,
                        obscureText: true,
                      ),

                      const SizedBox(height: 40),

                      // Save Button
                      GestureDetector(
                        onTap: _isSavingProfile ? null : _saveProfile,
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
                          child: Center(
                            child: _isSavingProfile
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        _colTitleGold,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'save changes',
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

                      const SizedBox(height: 32),

                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                const LogoutOverlay(),
                          );
                        },
                        child: Container(
                          width: 140,
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
                              'log out',
                              style: TextStyle(
                                color: Colors.white,
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
              child: IconBadge(
                assetPath: 'assets/icons/settings.png',
                size: 30,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const SettingsOverlay(),
                  );
                },
              ),
            ),

            // VOLUME ICON
            Positioned(
              top: 50,
              right: 20,
              child: const SoundToggleButton(size: 30),
            ),
          ],
        ),
      ),
    );
  }

  // Helper that returns a TextField
  Widget _buildInputField({
    required TextEditingController controller,
    String? hintText,
    required IconData icon,
    double iconSize = 24,
    bool obscureText = false,
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
        obscureText: obscureText,
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
          hintText: hintText,
          hintStyle: const TextStyle(
            color: _colTextGrey,
            fontSize: 16,
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w500,
          ),
          suffixIcon: Icon(icon, color: _colIconGrey, size: iconSize),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String newName = _nameController.text.trim();
    final String newPassword = _newPasswordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    if (user == null) {
      _showMessage('No authenticated user.');
      return;
    }

    if (newName.isEmpty) {
      _showMessage('Name cannot be empty.');
      return;
    }

    final bool wantsPasswordChange =
        newPassword.isNotEmpty || confirmPassword.isNotEmpty;
    if (wantsPasswordChange) {
      if (newPassword.isEmpty || confirmPassword.isEmpty) {
        _showMessage('Enter and confirm your new password.');
        return;
      }
      if (newPassword != confirmPassword) {
        _showMessage('Passwords do not match.');
        return;
      }
      if (newPassword.length < 6) {
        _showMessage('Password should be at least 6 characters long.');
        return;
      }
    }

    final String currentDisplayName = user.displayName?.trim() ?? '';
    final bool shouldUpdateName = newName != currentDisplayName;
    final bool shouldUpdatePassword = wantsPasswordChange;

    if (!shouldUpdateName && !shouldUpdatePassword) {
      _showMessage('Nothing to update.');
      return;
    }

    setState(() => _isSavingProfile = true);

    bool nameUpdated = false;
    bool passwordUpdated = false;

    try {
      if (shouldUpdateName) {
        await user.updateDisplayName(newName);
        nameUpdated = true;
      }
      if (shouldUpdatePassword) {
        await user.updatePassword(newPassword);
        passwordUpdated = true;
      }

      if (nameUpdated) {
        await user.reload();
        _user = FirebaseAuth.instance.currentUser;
      }
      if (passwordUpdated) {
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      }

      final List<String> updated = [];
      if (nameUpdated) {
        updated.add('name');
      }
      if (passwordUpdated) {
        updated.add('password');
      }
      _showMessage('Updated ${updated.join(' and ')} successfully.');
    } on FirebaseAuthException catch (error) {
      String message;
      switch (error.code) {
        case 'requires-recent-login':
          message = 'Please sign in again before changing your password.';
          break;
        case 'weak-password':
          message = 'Choose a stronger password.';
          break;
        default:
          message = error.message ?? 'Unable to save changes.';
      }
      if (nameUpdated || passwordUpdated) {
        message = '$message Some changes may have already been applied.';
      }
      _showMessage(message);
    } catch (error) {
      _showMessage('Unable to save changes: $error');
    } finally {
      if (mounted) {
        setState(() => _isSavingProfile = false);
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
