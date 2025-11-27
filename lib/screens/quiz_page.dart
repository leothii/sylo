import 'package:flutter/material.dart';
import 'score_page.dart';
import 'settings_overlay.dart';
import '../widgets/sylo_chat_overlay.dart';
import '../widgets/icon_badge.dart';
import '../widgets/sound_toggle_button.dart';
import '../widgets/attachment_upload_status.dart';
import '../utils/smooth_page.dart'; // For showSmoothDialog & SmoothPageRoute
import '../models/attachment_payload.dart';
import '../models/study_material.dart';
import '../services/ai_service.dart';
import '../services/gemini_file_service.dart';

// --- NEW IMPORTS FOR STREAK ---
import '../utils/streak_service.dart';
import '../widgets/streak_overlay.dart';

import 'music_page.dart';
import 'profile_page.dart';
import 'home_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({
    super.key,
    required this.material,
    this.initialPreparedMaterial,
  });

  final StudyMaterial material;
  final PreparedStudyMaterial? initialPreparedMaterial;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // --- Layout Constants ---
  final double _owlHeight = 150;
  final double _cardTopPosition = 120;
  final double _owlVerticalOffset = -110;

  // --- Color Palette ---
  static const Color _colBackgroundBlue = Color(0xFF8AABC7);
  static const Color _colCardGold = Color(0xFFF7DB9F);
  static const Color _colQuestionBg = Color(0xFFF8EFDC);
  static const Color _colTitleRed = Color(0xFF882124);
  static const Color _colTextGrey = Color(0xFF676767);
  static const Color _colOptionGrey = Color(0xFF898989);
  static const Color _colBtnShadow = Color(0x3F000000);
  static const Color _colNavItem = Color(0xFFE1B964);

  final AIService _aiService = AIService();
  PreparedStudyMaterial? _preparedMaterial;
  bool _isPreparingMaterial = false;
  List<QuizQuestion> _questions = <QuizQuestion>[];
  String? _errorMessage;
  bool _isLoading = true;
  bool _isSubmitting = false;

  final Map<int, int> _selectedOptions = {};

  @override
  void initState() {
    super.initState();
    _preparedMaterial = widget.initialPreparedMaterial;
    _loadQuiz();
  }

  // --- STREAK HELPER ---
  Future<void> _triggerStreakUpdate() async {
    // 1. Update Streak
    final bool streakUpdated = await StreakService.updateStreak();

    // 2. If new day, show overlay
    if (!streakUpdated) {
      return;
    }

    if (!mounted) {
      return;
    }

    final int newCount = await StreakService.getStreakCount();

    if (!mounted) {
      return;
    }

    final Set<int> activeDays = await StreakService.getActiveWeekdays();

    if (!mounted) {
      return;
    }

    await showSmoothDialog(
      context: context,
      builder: (_) =>
          StreakOverlay(currentStreak: newCount, activeWeekdays: activeDays),
    );
  }

  Widget _buildQuizBody() {
    if (_isPreparingMaterial) {
      return _buildProgressBody('Uploading attachment...');
    }

    if (_isLoading) {
      return _buildProgressBody('Generating quiz questions...');
    }

    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _colTextGrey,
                fontSize: 14,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: _colTitleRed,
                foregroundColor: Colors.white,
              ),
              child: const Text('retry'),
            ),
          ],
        ),
      );
    }

    if (_questions.isEmpty) {
      return const Center(
        child: Text(
          'No quiz questions available right now.',
          style: TextStyle(
            color: _colTextGrey,
            fontSize: 14,
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 80),
      itemCount: _questions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (BuildContext context, int index) {
        return _buildQuestionCard(index);
      },
    );
  }

  Widget _buildProgressBody(String message) {
    final bool showAttachmentProgress =
        _isPreparingMaterial && widget.material.hasAttachments;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showAttachmentProgress) ...[
            AttachmentUploadStatus(
              attachments: widget.material.attachments,
              showProgress: true,
            ),
            const SizedBox(height: 24),
          ],
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _colTextGrey,
              fontSize: 14,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<PreparedStudyMaterial> _ensurePreparedMaterial() async {
    if (_preparedMaterial != null) {
      return _preparedMaterial!;
    }

    if (!widget.material.hasAttachments) {
      final PreparedStudyMaterial prepared = PreparedStudyMaterial(
        text: widget.material.text,
        attachments: const <GeminiFileAttachment>[],
      );
      _preparedMaterial = prepared;
      return prepared;
    }

    setState(() {
      _isPreparingMaterial = true;
    });

    try {
      final List<GeminiFileAttachment> uploadedAttachments =
          await GeminiFileService.instance
              .uploadAll(widget.material.attachments);

      final PreparedStudyMaterial prepared = PreparedStudyMaterial(
        text: widget.material.text,
        attachments: uploadedAttachments,
      );

      _preparedMaterial = prepared;
      return prepared;
    } finally {
      if (mounted) {
        setState(() {
          _isPreparingMaterial = false;
        });
      }
    }
  }

  Future<void> _loadQuiz() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _questions = <QuizQuestion>[];
      _selectedOptions.clear();
    });

    try {
      final PreparedStudyMaterial prepared = await _ensurePreparedMaterial();
      final List<QuizQuestion> questions =
          await _aiService.generateQuiz(prepared);
      if (!mounted) return;
      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      final String message = error is StateError
          ? error.message
          : 'Unable to generate quiz questions. Please try again.';
      setState(() {
        _errorMessage = message;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colBackgroundBlue,

      // --- BOTTOM NAV ---
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
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        SmoothPageRoute(builder: (_) => const ProfilePage()),
                      );
                    },
                    child: const Icon(Icons.person, color: _colNavItem, size: 32),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        SmoothPageRoute(
                          builder: (_) => const HomePage(),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Icon(Icons.home, color: _colNavItem, size: 32),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        SmoothPageRoute(builder: (_) => const MusicPage()),
                      );
                    },
                    child: const Icon(Icons.headphones, color: _colNavItem, size: 32),
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
            // --- MAIN CARD ---
            Positioned(
              top: _cardTopPosition,
              bottom: 20,
              left: 24,
              right: 24,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: _colCardGold,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(width: 1, color: Colors.black12),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 50, 24, 10),
                          child: SizedBox(
                            height: 44,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const Center(
                                  child: Text(
                                    'QUIZ',
                                    style: TextStyle(
                                      color: _colTitleRed,
                                      fontSize: 32,
                                      fontFamily: 'Bungee',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () => Navigator.of(context).maybePop(),
                                    child: const Icon(
                                      Icons.close,
                                      color: _colTextGrey,
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: _buildQuizBody()),
                      ],
                    ),
                  ),

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

                  // --- SUBMIT BUTTON ---
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Builder(
                      builder: (BuildContext context) {
                        final bool canSubmit =
                            !_isLoading &&
                            !_isSubmitting &&
                            _questions.isNotEmpty &&
                            _selectedOptions.length == _questions.length;

                        return GestureDetector(
                          onTap: canSubmit
                              ? () async {
                                  setState(() {
                                    _isSubmitting = true;
                                  });

                                  // ------------------------------------------
                                  // 1. TRIGGER STREAK (New Logic)
                                  // ------------------------------------------
                                  await _triggerStreakUpdate();

                                  // 2. Calculate Score
                                  final int total = _questions.length;
                                  final int correct = _questions
                                      .asMap()
                                      .entries
                                      .where((
                                        MapEntry<int, QuizQuestion> entry,
                                      ) {
                                        final int index = entry.key;
                                        final QuizQuestion question =
                                            entry.value;
                                        final int? selected =
                                            _selectedOptions[index];
                                        final int? expected =
                                            question.correctOptionIndex;
                                        return selected != null &&
                                            expected != null &&
                                            selected == expected;
                                      })
                                      .length;

                                  // 3. Get AI Summary & Navigate
                                  try {
                                    final PreparedStudyMaterial prepared =
                                        _preparedMaterial ??
                                            await _ensurePreparedMaterial();
                                    final QuizResultsSummary summary =
                                        await _aiService.buildQuizSummary(
                                          material: prepared,
                                          total: total,
                                          correct: correct,
                                        );

                                    if (!context.mounted) return;

                                    Navigator.of(context).push(
                                      SmoothPageRoute(
                                        builder: (BuildContext context) =>
                                            ScorePage(
                                              correct: correct,
                                              total: total,
                                              summary: summary,
                                              questions: _questions,
                                              selections: Map<int, int>.from(
                                                _selectedOptions,
                                              ),
                                            ),
                                      ),
                                    );
                                  } catch (error) {
                                    if (!context.mounted) return;
                                    // Fallback if AI fails
                                    final QuizResultsSummary
                                    fallback = QuizResultsSummary(
                                      quote:
                                          'Success is the sum of small efforts, repeated day in and day out.',
                                      author: 'Robert Collier',
                                      feedback:
                                          'Great work completing the quiz! Review the questions you missed and try again.',
                                    );

                                    Navigator.of(context).push(
                                      SmoothPageRoute(
                                        builder: (BuildContext context) =>
                                            ScorePage(
                                              correct: correct,
                                              total: total,
                                              summary: fallback,
                                              questions: _questions,
                                              selections: Map<int, int>.from(
                                                _selectedOptions,
                                              ),
                                            ),
                                      ),
                                    );
                                  } finally {
                                    if (mounted) {
                                      setState(() {
                                        _isSubmitting = false;
                                      });
                                    }
                                  }
                                }
                              : null,
                          child: Opacity(
                            opacity: canSubmit ? 1 : 0.4,
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
                                  color: Color(0xFFF6DA9F),
                                  fontSize: 14,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // --- OWL IMAGE ---
            Positioned(
              top: _cardTopPosition + _owlVerticalOffset,
              left: 10,
              child: GestureDetector(
                onTap: () => showSyloChatOverlay(context),
                child: Image.asset(
                  'assets/images/sylo.png',
                  height: _owlHeight,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // --- SETTINGS ICON ---
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

            // --- VOLUME ICON ---
            const Positioned(
              top: 50,
              right: 20,
              child: SoundToggleButton(size: 30),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(int index) {
    final QuizQuestion question = _questions[index];
    final int? selectedOptionIndex = _selectedOptions[index];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _colQuestionBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.prompt,
            style: const TextStyle(
              color: _colTextGrey,
              fontSize: 12,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: List<Widget>.generate(question.options.length, (
              int optionIndex,
            ) {
              final bool isSelected = selectedOptionIndex == optionIndex;
              final String label = question.options[optionIndex];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedOptions[index] = optionIndex;
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: _colOptionGrey,
                            fontSize: 13,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
