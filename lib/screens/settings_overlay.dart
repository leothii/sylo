import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

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
