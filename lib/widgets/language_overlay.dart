import 'package:flutter/material.dart';

class LanguageOverlay extends StatefulWidget {
  const LanguageOverlay({super.key});

  @override
  State<LanguageOverlay> createState() => _LanguageOverlayState();
}

class _LanguageOverlayState extends State<LanguageOverlay> {
  // State to track selected language
  String _selectedLanguage = 'english';

  // --- Color Palette (From your Figma Code) ---
  static const Color _colCardBackground = Color(0xFF7591A9); // Blue-Grey
  static const Color _colTitleCream = Color(0xFFF6DA9F);
  static const Color _colBtnSelected = Color(0xFFE1B964); // Gold
  static const Color _colBtnUnselected = Color(0xFFF6DA9F); // Cream
  static const Color _colBtnTextRed = Color(0xFF882124);
  static const Color _colActionBtnRed = Color(0xFF882124);
  static const Color _colActionBtnCream = Color(0xFFF6DA9F);
  static const Color _colActionTextGrey = Color(0xFF898989);
  static const Color _colActionTextCream = Color(0xFFF7DB9F);
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
            width: 250, // Fixed width to match design proportions
            margin: const EdgeInsets.only(top: 60), // Space for the owl
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 25),
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
                Text(
                  'LANGUAGE',
                  style: TextStyle(
                    color: _colTitleCream,
                    fontSize: 28,
                    fontFamily: 'Bungee', // Using the specific font
                    fontWeight: FontWeight.w400,
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Language Selection Buttons
                _buildLanguageOption('english'),
                const SizedBox(height: 15),
                _buildLanguageOption('tagalog'),
                const SizedBox(height: 15),
                _buildLanguageOption('hiligaynon'),

                const SizedBox(height: 35),

                // Action Buttons (Cancel / Save)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Cancel
                    _buildActionButton(
                      label: 'cancel',
                      bgColor: _colActionBtnCream,
                      textColor: _colActionTextGrey,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    // Save
                    _buildActionButton(
                      label: 'save',
                      bgColor: _colActionBtnRed,
                      textColor: _colActionTextCream,
                      onTap: () {
                        // Add save logic here
                        print("Language saved: $_selectedLanguage");
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- Owl Image (Top Center) ---
          Positioned(
            top: -25, // Positioned on top of the card
            child: Image.asset(
              'assets/images/sylo.png', // Using the standard owl
              height: 110,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    final bool isSelected = _selectedLanguage == language;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
      },
      child: Container(
        width: double.infinity,
        height: 38,
        decoration: BoxDecoration(
          color: isSelected ? _colBtnSelected : _colBtnUnselected,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: _colShadow, blurRadius: 4, offset: Offset(0, 4)),
          ],
        ),
        child: Center(
          child: Text(
            language,
            style: const TextStyle(
              color: _colBtnTextRed,
              fontSize: 20,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 35,
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
              fontSize: 15,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
