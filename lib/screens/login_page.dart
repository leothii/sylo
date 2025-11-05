// lib/screens/login_page.dart

import 'package:flutter/material.dart';
import '../utils/app_colors.dart'; // Make sure this path is correct

// Your LoginPage is unchanged
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _nameController;
  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color inputFieldColor = Color(0xFFF0F0F0);
    const Color hintColor = Colors.grey;
    const Color inputTextColor = Colors.black;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- Settings Icon (Top Right) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/images/settings.png',
                      height: 30,
                      width: 30,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // This opens the original SettingsOverlay
                          return const SettingsOverlay();
                        },
                      );
                    },
                  ),
                ],
              ),

              const Spacer(flex: 2),

              // --- Logo (Centered) ---
              Image.asset(
                'assets/images/logo.png',
                height: 50, // Adjust size to match Figma
              ),
              const SizedBox(height: 10),

              // --- Stack with TextField and Owl ---
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  // --- LAYER 1: The TextField ---
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _nameController,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        hintText: 'name',
                        hintStyle: const TextStyle(
                          color: hintColor,
                          fontSize: 18,
                        ),
                        filled: true,
                        fillColor: inputFieldColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 15,
                        ),
                      ),
                      style: const TextStyle(
                        color: inputTextColor,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  // --- LAYER 2: The Owl (on top) ---
                  IgnorePointer(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Image.asset('assets/images/sylo.png', height: 230),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- The Dropdown ---
              SizedBox(
                width: 200, // Same width as the TextField
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: inputFieldColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedRole,
                      isExpanded: true,
                      hint: const Text(
                        'student',
                        style: TextStyle(color: hintColor, fontSize: 18),
                      ),
                      dropdownColor: inputFieldColor,
                      style: const TextStyle(
                        color: inputTextColor,
                        fontSize: 18,
                      ),
                      icon: const Icon(Icons.arrow_drop_down, color: hintColor),
                      items: ['student', 'teacher', 'professional']
                          .map(
                            (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRole = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 3),

              // --- Bottom Icons ---
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.headset, color: Colors.white, size: 30),
                  SizedBox(width: 40),
                  Icon(Icons.lightbulb_outline, color: Colors.white, size: 30),
                  SizedBox(width: 40),
                  Icon(Icons.assignment, color: Colors.white, size: 30),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

//
// ----------------- YOUR SETTINGS OVERLAY (UNCHANGED) -----------------
//
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
                  _buildOverlayButton(
                    context,
                    'home',
                    const Color(0xFFF7DB9F),
                    const Color(0xFF8B0000),
                    () {
                      print('Home button pressed!');
                    },
                  ),
                  const SizedBox(height: 15),

                  // 🚨🚨🚨 THIS 'language' BUTTON IS NOW UPDATED 🚨🚨🚨
                  _buildOverlayButton(
                    context,
                    'language',
                    const Color(0xFFF7DB9F),
                    const Color(0xFF8B0000),
                    () {
                      // 1. Close the current settings overlay
                      Navigator.of(context).pop();
                      // 2. Show the new language overlay
                      showDialog(
                        context: context,
                        builder: (context) => const LanguageOverlay(),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildOverlayButton(
                    context,
                    'about',
                    const Color(0xFFF7DB9F),
                    const Color(0xFF8B0000),
                    () {
                      print('About button pressed!');
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildOverlayButton(
                    context,
                    'exit',
                    const Color(0xFF882225),
                    Colors.white,
                    () {
                      print('Exit button pressed!');
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -30, // Moves the owl up
            child: Image.asset(
              'assets/images/sylo.png', // Your owl image
              height: 120,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method (unchanged)
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

//
// ----------------- YOUR NEW LANGUAGE OVERLAY -----------------
//
class LanguageOverlay extends StatefulWidget {
  const LanguageOverlay({super.key});

  @override
  State<LanguageOverlay> createState() => _LanguageOverlayState();
}

class _LanguageOverlayState extends State<LanguageOverlay> {
  String _selectedLanguage = 'english';

  static const Color buttonColor = Color(0xFFF7DB9F);
  static const Color saveButtonColor = Color(0xFF882225);
  static const Color buttonTextColor = Color(0xFF8B0000);
  static const Color titleColor = Color(0xFFF7DB9F);

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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'LANGUAGE',
                    style: TextStyle(
                      fontFamily: 'Bungee',
                      fontSize: 24,
                      color: titleColor,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildLanguageButton('english'),
                  const SizedBox(height: 10),
                  _buildLanguageButton('tagalog'),
                  const SizedBox(height: 10),
                  _buildLanguageButton('hiligaynon'),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBottomButton(
                        'cancel',
                        buttonColor,
                        buttonTextColor,
                      ),
                      _buildBottomButton('save', saveButtonColor, Colors.white),
                    ],
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

  Widget _buildLanguageButton(String text) {
    final bool isSelected = _selectedLanguage == text;

    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedLanguage = text;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: isSelected
                ? const BorderSide(color: Colors.white, width: 3)
                : BorderSide.none,
          ),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.25),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: buttonTextColor,
          ),
        ),
      ),
    );
  }

  // Helper for the 'cancel' and 'save' buttons
  Widget _buildBottomButton(String text, Color bgColor, Color textColor) {
    // 🚨🚨🚨 THE FIX IS HERE 🚨🚨🚨
    // We check the text and set the font size accordingly
    final double fontSize = (text == 'cancel') ? 14 : 16;
    // 🚨🚨🚨 END OF FIX 🚨🚨🚨

    return SizedBox(
      width: 80,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          if (text == 'save') {
            print('Saving language: $_selectedLanguage');
          }
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.25),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize, // Use the new variable here
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          softWrap: false, // Prevents text from wrapping
        ),
      ),
    );
  }
}
