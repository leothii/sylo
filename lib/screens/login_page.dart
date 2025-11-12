// lib/screens/login_page.dart

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'home_page.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFF8AABC7),
      body: SafeArea(
        child: Stack(
          children: [
            // Settings Icon (Top Right)
            Positioned(
              right: 18,
              top: 28,
              child: IconButton(
                icon: Image.asset(
                  'assets/icons/settings.png',
                  height: 36,
                  width: 36,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const SettingsOverlay();
                    },
                  );
                },
              ),
            ),

            // Logo "sylo" at top
            Positioned(
              left: 0,
              right: 0,
              top: 215,
              child: Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'sy',
                        style: TextStyle(
                          color: const Color(0xFF882124),
                          fontSize: 42,
                          fontFamily: 'Bungee',
                          fontWeight: FontWeight.w400,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 4),
                              blurRadius: 4,
                              color: const Color(0xFF000000).withOpacity(0.25),
                            )
                          ],
                        ),
                      ),
                      TextSpan(
                        text: 'lo',
                        style: TextStyle(
                          color: const Color(0xFFF1F1F1),
                          fontSize: 42,
                          fontFamily: 'Bungee',
                          fontWeight: FontWeight.w400,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 4),
                              blurRadius: 4,
                              color: const Color(0xFF000000).withOpacity(0.25),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Quote mark
            Positioned(
              left: 100,
              top: 259,
              child: Text(
                '"',
                style: TextStyle(
                  color: const Color(0xFFF7DB9F),
                  fontSize: 96,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // "Please enter your:" text
            Positioned(
              left: 92,
              top: 323.62,
              child: Text(
                'Please enter your:',
                style: TextStyle(
                  color: const Color(0xFFF7DB9F),
                  fontSize: 22,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // Owl Image
            Positioned(
              left: 92,
              top: 229,
              child: SizedBox(
                width: 273,
                height: 273,
                child: Image.asset(
                  'assets/images/sylo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Name TextField
            Positioned(
              left: 108,
              top: 443,
              child: Container(
                width: 163,
                height: 33,
                decoration: ShapeDecoration(
                  color: const Color(0xFFF1F1F1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'name',
                    hintStyle: const TextStyle(
                      color: Color(0xFFB1B1B1),
                      fontSize: 16,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Role Dropdown
            Positioned(
              left: 108,
              top: 502,
              child: Container(
                width: 163,
                height: 33,
                decoration: ShapeDecoration(
                  color: const Color(0xFFF1F1F1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedRole,
                    isExpanded: true,
                    hint: const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'student',
                        style: TextStyle(
                          color: Color(0xFFB1B1B1),
                          fontSize: 16,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    dropdownColor: const Color(0xFFF1F1F1),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600,
                    ),
                    icon: const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFFB1B1B1),
                      ),
                    ),
                    items: ['student', 'teacher', 'professional']
                        .map(
                          (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(value),
                        ),
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

            // Continue Button
            Positioned(
              left: 126,
              top: 584,
              child: Container(
                width: 116.85,
                height: 38,
                decoration: ShapeDecoration(
                  color: const Color(0xFFF6DA9F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: const Center(
                      child: Text(
                        'continue',
                        style: TextStyle(
                          color: Color(0xFF882124),
                          fontSize: 22,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
            top: -30,
            child: Image.asset(
              'assets/images/sylo.png',
              height: 120,
            ),
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

//
// ----------------- YOUR LANGUAGE OVERLAY (UNCHANGED) -----------------
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

  Widget _buildBottomButton(String text, Color bgColor, Color textColor) {
    final double fontSize = (text == 'cancel') ? 14 : 16;

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
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          softWrap: false,
        ),
      ),
    );
  }
}