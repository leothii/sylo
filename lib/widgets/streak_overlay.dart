import 'package:flutter/material.dart';

class StreakOverlay extends StatelessWidget {
  const StreakOverlay({super.key, this.currentStreak = 1});

  final int currentStreak;

  // --- Color Palette ---
  static const Color _colCardBg = Color(0xFFF7DB9F);
  static const Color _colInnerCard = Color(0xFFF8EFDC);
  static const Color _colWeeklyBox = Color(0xFFE1B964); // Darker gold/brown
  static const Color _colTitleRed = Color(0xFF882124); // The dark red text
  static const Color _colTextGrey = Color(0xFF5A5A5A);
  static const Color _colFireOrange = Color(0xFFFFA000);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        // The Outer Beige Card
        decoration: BoxDecoration(
          color: _colCardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1.5, color: Colors.black87),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 30, 16, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // The Inner Creamy White Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: _colInnerCard,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),

                  // 1. FIRE ICON
                  const Icon(
                    Icons.local_fire_department_rounded,
                    size: 80,
                    color: _colFireOrange,
                  ),

                  const SizedBox(height: 10),

                  // 2. "1 DAYS" (Big Text)
                  Text(
                    '$currentStreak DAYS',
                    style: const TextStyle(
                      fontFamily: 'Bungee',
                      fontSize: 48,
                      height: 1.0,
                      color: _colTitleRed,
                    ),
                  ),

                  // 3. "STREAK" (Smaller Text, Below)
                  const Text(
                    'STREAK',
                    style: TextStyle(
                      fontFamily: 'Bungee',
                      fontSize: 28,
                      color: _colTitleRed,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 4. WEEKLY PROGRESS BOX
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      color: _colWeeklyBox,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'WEEKLY PROGRESS:',
                          style: TextStyle(
                            fontFamily: 'Bungee',
                            fontSize: 18,
                            color: _colTextGrey,
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Days Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            _DayIndicator(label: 'SUN', isFilled: true),
                            _DayIndicator(label: 'MON', isFilled: true),
                            _DayIndicator(label: 'TUE', isFilled: true),
                            _DayIndicator(label: 'WED', isFilled: true),
                            _DayIndicator(label: 'THU', isFilled: true),
                            _DayIndicator(label: 'FRI', isFilled: true),
                            _DayIndicator(label: 'SAT', isFilled: true),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 5. CONTINUE BUTTON
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 40,
                      ),
                      decoration: BoxDecoration(
                        color: _colTitleRed,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Helper Widget for Simplified Circles ---
class _DayIndicator extends StatelessWidget {
  final String label;
  final bool isFilled;

  const _DayIndicator({required this.label, this.isFilled = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Simplified Concentric Circle (Target style)
        Icon(
          isFilled ? Icons.radio_button_checked : Icons.radio_button_unchecked,
          color: const Color(0xFF5A5A5A),
          size: 28,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Bungee',
            fontSize: 10,
            color: Color(0xFF5A5A5A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
