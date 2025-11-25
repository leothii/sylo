// lib/screens/score_page.dart

import 'package:flutter/material.dart';
import 'settings_overlay.dart';

// --- NEW IMPORTS ---
import 'music_page.dart';
import 'profile_page.dart';
import 'home_page.dart';
import '../utils/smooth_page.dart'; // <--- Import SmoothPageRoute
import '../services/ai_service.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({
    super.key,
    required this.correct,
    required this.total,
    required this.summary,
    required this.questions,
    required this.selections,
  });

  final int correct;
  final int total;
  final QuizResultsSummary summary;
  final List<QuizQuestion> questions;
  final Map<int, int> selections;

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  // --- Layout Constants ---
  final double _owlHeight = 150;
  final double _cardTopPosition = 140;
  final double _owlVerticalOffset = -115;

  // --- Color Palette ---
  static const Color _colBackgroundBlue = Color(0xFF8AABC7);
  static const Color _colCardGold = Color(0xFFF7DB9F); // Main Card
  static const Color _colInnerGold = Color(0xFFE1B964); // Quote Card
  static const Color _colTitleRed = Color(0xFF882124);
  static const Color _colScoreGreen = Color(0xFF95A995);
  static const Color _colTextGrey = Color(0xFF676767);
  static const Color _colButtonShadow = Color(0x3F000000);

  // Navigation Icon Color
  static const Color _colNavItem = Color(0xFFE1B964);

  late final List<QuizQuestion> _questions;
  late final Map<int, int> _selections;

  @override
  void initState() {
    super.initState();
    _questions = List<QuizQuestion>.unmodifiable(widget.questions);
    _selections = Map<int, int>.unmodifiable(widget.selections);
  }

  @override
  Widget build(BuildContext context) {
    final int total = widget.total.clamp(0, 999);
    final int correct = widget.correct.clamp(0, total);
    final String scoreText = '$correct/$total';
    final QuizResultsSummary summary = widget.summary;
    final String quote = summary.quote.isNotEmpty
        ? summary.quote
        : 'Keep learning and growing.';
    final String author = summary.author.isNotEmpty
        ? summary.author
        : 'Unknown';
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
                Navigator.of(context).push(
                  SmoothPageRoute(builder: (_) => const ProfilePage()),
                ); // <--- Smooth
              },
              child: const Icon(Icons.person, color: _colNavItem, size: 32),
            ),

            // 2. Home Icon -> Navigates back to HomePage (Replaced Notes Icon)
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  SmoothPageRoute(
                    builder: (_) => const HomePage(),
                  ), // <--- Smooth
                  (route) => false,
                );
              },
              child: const Icon(Icons.home, color: _colNavItem, size: 32),
            ),

            // 3. Music Icon -> Navigates to MusicPage
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  SmoothPageRoute(builder: (_) => const MusicPage()),
                ); // <--- Smooth
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
              child: Container(
                decoration: BoxDecoration(
                  color: _colCardGold,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 1, color: Colors.black12),
                ),
                child: Column(
                  children: [
                    // Header: "Score" Title + Close Button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 50, 24, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          const Text(
                            'Score',
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

                    // Score Text "10/10"
                    const SizedBox(height: 10),
                    Text(
                      scoreText,
                      style: const TextStyle(
                        color: _colScoreGreen,
                        fontSize: 64,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Quote Section (Stack used to overlap the Quote Mark)
                    Expanded(
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          // The Quote Box
                          Positioned(
                            top:
                                30, // Pushed down to make room for the quote mark
                            left: 20,
                            right: 20,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                40,
                                20,
                                20,
                              ),
                              decoration: BoxDecoration(
                                color: _colInnerGold,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    quote,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: _colTextGrey,
                                      fontSize: 20,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // Author Line
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 1,
                                        color: _colTitleRed,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        author,
                                        style: const TextStyle(
                                          color: _colTextGrey,
                                          fontSize: 16,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // The Big Quote Mark "
                          const Positioned(
                            top: 0,
                            child: Text(
                              '“',
                              style: TextStyle(
                                color: _colTextGrey,
                                fontSize: 100,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w500,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Restart Button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: _showResultsSheet,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x22000000),
                                blurRadius: 6,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.visibility, color: _colTitleRed),
                              SizedBox(width: 8),
                              Text(
                                'view results',
                                style: TextStyle(
                                  color: _colTitleRed,
                                  fontSize: 16,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        child: Container(
                          width: 66,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _colTitleRed,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: _colButtonShadow,
                                blurRadius: 4,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/icons/refresh.png',
                              width: 24,
                              height: 24,
                              color: const Color(0xFFF6DA9F),
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
                child: Image.asset(
                  'assets/images/happy_owl.png',
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

  void _showResultsSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: FractionallySizedBox(
              heightFactor: 0.8,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Quiz Results',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Bungee',
                      color: _colTitleRed,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      itemCount: _questions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (BuildContext context, int index) {
                        final QuizQuestion question = _questions[index];
                        final int? selectedIndex = _selections[index];
                        final int? correctIndex =
                            question.correctOptionIndex;
                        final bool isCorrect =
                            selectedIndex != null &&
                            correctIndex != null &&
                            selectedIndex == correctIndex;

                        String _optionLabel(int? optionIndex) {
                          if (optionIndex == null) {
                            return 'Not answered';
                          }
                          if (optionIndex < 0 ||
                              optionIndex >= question.options.length) {
                            return 'Not answered';
                          }
                          return question.options[optionIndex];
                        }

                        final String selectedLabel =
                            _optionLabel(selectedIndex);
                        final String correctLabel = _optionLabel(correctIndex);

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isCorrect
                                ? const Color(0xFFE5F6E8)
                                : const Color(0xFFFFEBEB),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isCorrect
                                  ? const Color(0xFF6DB37F)
                                  : const Color(0xFFE05C5C),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Question ${index + 1}',
                                style: const TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: _colTitleRed,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                question.prompt,
                                style: const TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: _colTextGrey,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Your answer: $selectedLabel',
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: isCorrect
                                      ? const Color(0xFF357A4A)
                                      : const Color(0xFFD14242),
                                ),
                              ),
                              const SizedBox(height: 6),
                              if (!isCorrect)
                                Text(
                                  'Correct answer: $correctLabel',
                                  style: const TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: _colTextGrey,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
