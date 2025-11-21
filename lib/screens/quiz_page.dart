// lib/screens/quiz_page.dart

import 'package:flutter/material.dart';
import 'score_page.dart';
import 'settings_overlay.dart';
import '../widgets/sylo_chat_overlay.dart';

// --- NEW IMPORTS ---
import 'music_page.dart';
import 'notes_page.dart';
import 'profile_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // --- Layout Constants ---
  final double _owlHeight = 150;
  final double _cardTopPosition = 120;
  final double _owlVerticalOffset = -110;

  // --- Color Palette (From Figma) ---
  static const Color _colBackgroundBlue = Color(0xFF8AABC7);
  static const Color _colCardGold = Color(0xFFF7DB9F);
  static const Color _colQuestionBg = Color(0xFFF8EFDC);
  static const Color _colTitleRed = Color(0xFF882124);
  static const Color _colTextGrey = Color(0xFF676767);
  static const Color _colOptionGrey = Color(0xFF898989);
  static const Color _colBtnShadow = Color(0x3F000000);

  // Define the nav color here for consistency (same hex as your previous code)
  static const Color _colNavItem = Color(0xFFE1B964);

  // --- Data ---
  final List<_QuizQuestion> _questions = [
    _QuizQuestion(
      prompt:
          'Lorem ipsum dolor sit amet. Est laborum voluptatem quo laudantium nisi et suscipit animi et laudantium amet eum omnis tenetur ut animi quia? Est recusandae',
      options: const ['lorem', 'ipsum', 'dolor', 'amet'],
    ),
    _QuizQuestion(
      prompt:
          'Lorem ipsum dolor sit amet. Est laborum voluptatem quo laudantium nisi et suscipit animi et laudantium amet eum omnis tenetur ut animi quia? Est recusandae',
      options: const ['lorem', 'ipsum', 'dolor', 'amet'],
    ),
    _QuizQuestion(
      prompt:
          'Lorem ipsum dolor sit amet. Est laborum voluptatem quo laudantium nisi et suscipit animi et laudantium amet eum omnis tenetur ut animi quia? Est recusandae',
      options: const ['lorem', 'ipsum', 'dolor', 'amet'],
    ),
  ];

  final Map<int, int> _selectedOptions = {};

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
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
              },
              child: const Icon(Icons.person, color: _colNavItem, size: 32),
            ),

            // 2. Notes Icon -> Navigates to NotesPage
            GestureDetector(
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const NotesPage()));
              },
              child: const Icon(Icons.menu_book, color: _colNavItem, size: 32),
            ),

            // 3. Music Icon -> Navigates to MusicPage
            GestureDetector(
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const MusicPage()));
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
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // The Actual Card Container
                  Container(
                    decoration: BoxDecoration(
                      color: _colCardGold,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(width: 1, color: Colors.black12),
                    ),
                    child: Column(
                      children: [
                        // Header Section
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 50, 24, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              const Text(
                                'QUIZ',
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

                        // Scrollable Question List
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(
                              20,
                              10,
                              20,
                              80,
                            ), // Extra bottom padding for Submit button
                            itemCount: _questions.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              return _buildQuestionCard(index);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- DECORATION: Red "Bookmark" on the right ---
                  Positioned(
                    right: -4,
                    top: 40,
                    child: Container(
                      width: 10,
                      height: 30,
                      decoration: BoxDecoration(
                        color: _colTitleRed,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),

                  // --- SUBMIT BUTTON (Floating Bottom Right) ---
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ScorePage(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _colTitleRed,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: _colBtnShadow,
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Text(
                          'submit',
                          style: TextStyle(
                            color: Color(0xFFF6DA9F), // Gold Text
                            fontSize: 14,
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

            // --- 2. THE OWL IMAGE (MOVED LEFT) ---
            Positioned(
              top: _cardTopPosition + _owlVerticalOffset,
              left: 10,
              child: GestureDetector(
                // Opens the Sylo Chat Overlay when the owl is pressed
                onTap: () => showSyloChatOverlay(context),
                child: Image.asset(
                  'assets/images/sylo.png',
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

  Widget _buildQuestionCard(int index) {
    final question = _questions[index];
    final selectedOptionIndex = _selectedOptions[index];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _colQuestionBg, // Cream/White color
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          // Question Text
          Text(
            question.prompt,
            style: const TextStyle(
              color: _colTextGrey,
              fontSize: 12,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),

          // Options Row (Horizontal Radio Buttons)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(question.options.length, (optionIndex) {
              final isSelected = selectedOptionIndex == optionIndex;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedOptions[index] = optionIndex;
                  });
                },
                child: Column(
                  children: [
                    // Custom Radio Circle
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _colOptionGrey, width: 2),
                      ),
                      child: isSelected
                          ? Center(
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: _colTextGrey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 4),
                    // Label (lorem, ipsum, etc.)
                    Text(
                      question.options[optionIndex],
                      style: const TextStyle(
                        color: _colOptionGrey,
                        fontSize: 12,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// --- Data Models ---

class _QuizQuestion {
  const _QuizQuestion({required this.prompt, required this.options});

  final String prompt;
  final List<String> options;
}
