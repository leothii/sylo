import 'package:flutter/material.dart';

class StreakOverlay extends StatelessWidget {
  const StreakOverlay({
    super.key,
    this.currentStreak = 1,
    required this.activeWeekdays, // <--- Added this so we know which dots to fill
  });

  final int currentStreak;
  final Set<int> activeWeekdays;

  // --- Color Palette ---
  static const Color _colCardBg = Color(0xFFF7DB9F);
  static const Color _colInnerCard = Color(0xFFF8EFDC);
  static const Color _colWeeklyBox = Color(0xFFE1B964);
  static const Color _colTitleRed = Color(0xFF882124);
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

                  // 2. DYNAMIC STREAK TEXT
                  Text(
                    '$currentStreak DAYS',
                    style: const TextStyle(
                      fontFamily: 'Bungee',
                      fontSize: 48,
                      height: 1.0,
                      color: _colTitleRed,
                    ),
                  ),

                  // 3. "STREAK"
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

                        // Days Row - DYNAMICALLY FILLED
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _DayIndicator(
                              label: 'SUN',
                              isFilled: activeWeekdays.contains(7),
                            ),
                            _DayIndicator(
                              label: 'MON',
                              isFilled: activeWeekdays.contains(1),
                            ),
                            _DayIndicator(
                              label: 'TUE',
                              isFilled: activeWeekdays.contains(2),
                            ),
                            _DayIndicator(
                              label: 'WED',
                              isFilled: activeWeekdays.contains(3),
                            ),
                            _DayIndicator(
                              label: 'THU',
                              isFilled: activeWeekdays.contains(4),
                            ),
                            _DayIndicator(
                              label: 'FRI',
                              isFilled: activeWeekdays.contains(5),
                            ),
                            _DayIndicator(
                              label: 'SAT',
                              isFilled: activeWeekdays.contains(6),
                            ),
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

// --- Helper Widget for Simplified Circles (UNCHANGED) ---
class _DayIndicator extends StatelessWidget {
  final String label;
  final bool isFilled;

  const _DayIndicator({required this.label, this.isFilled = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
