// lib/screens/quiz_page.dart

import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../widgets/audio_card.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<_QuizQuestion> _questions = [
    _QuizQuestion(
      prompt:
          'Lorem ipsum dolor sit amet. Est laborum voluptatem quo laudantium nisi et suscipit animi et laudantium amet eum omnis tenetur ut animi quia? Est recusandae.',
      options: const ['lorem', 'ipsum', 'dolor', 'amet'],
    ),
    _QuizQuestion(
      prompt:
          'Lorem ipsum dolor sit amet. Est laborum voluptatem quo laudantium nisi et suscipit animi et laudantium amet eum omnis tenetur ut animi quia? Est recusandae.',
      options: const ['lorem', 'ipsum', 'dolor', 'amet'],
    ),
    _QuizQuestion(
      prompt:
          'Lorem ipsum dolor sit amet. Est laborum voluptatem quo laudantium nisi et suscipit animi et laudantium amet eum omnis tenetur ut animi quia? Est recusandae.',
      options: const ['lorem', 'ipsum', 'dolor', 'amet'],
    ),
  ];

  final Map<int, int> _selectedOptions = {};
  final ScrollController _quizScrollController = ScrollController();

  final double _cardTopMargin = 72;
  final double _cardHorizontalPadding = 30;
  final double _cardHeaderHeight = 64;
  final double _titleLetterSpacing = 3.5;
  final double _titleSpacingBelow = 24;
  final double _cardContentBottomPadding = 36;

  @override
  void dispose() {
    _quizScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTopBar(),
              const SizedBox(height: 24),
              _buildQuizCard(context),
              const SizedBox(height: 32),
              const AudioCard(playIconVerticalOffset: -10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _TopBarIconColumn(
          topAsset: 'assets/icons/profile.png',
          bottomAsset: 'assets/icons/note.png',
        ),
        Spacer(),
        _TopBarIconColumn(
          topAsset: 'assets/icons/settings.png',
          bottomAsset: 'assets/icons/sound.png',
        ),
      ],
    );
  }

  Widget _buildQuizCard(BuildContext context) {
    return Expanded(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: _cardTopMargin),
              padding: EdgeInsets.symmetric(horizontal: _cardHorizontalPadding),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF1DF),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: const Color(0xFF2E2922), width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 22,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: _cardHeaderHeight,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Center(
                          child: Text(
                            'QUIZ',
                            style: TextStyle(
                              color: const Color(0xFF8F1D1D),
                              fontFamily: 'Bungee',
                              fontSize: 34,
                              letterSpacing: _titleLetterSpacing,
                              shadows: const [
                                Shadow(
                                  color: Color(0x338F1D1D),
                                  offset: Offset(0, 4),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Color(0xFF776E67),
                            ),
                            onPressed: () => Navigator.of(context).maybePop(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: _titleSpacingBelow),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: _cardContentBottomPadding,
                      ),
                      child: Scrollbar(
                        controller: _quizScrollController,
                        thumbVisibility: true,
                        thickness: 7,
                        radius: const Radius.circular(12),
                        child: ListView.separated(
                          controller: _quizScrollController,
                          padding: const EdgeInsets.only(bottom: 24),
                          itemCount: _questions.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 20),
                          itemBuilder: (context, index) {
                            final question = _questions[index];
                            final selectedIndex = _selectedOptions[index];
                            return _QuizQuestionCard(
                              questionNumber: index + 1,
                              question: question,
                              selectedIndex: selectedIndex,
                              onOptionSelected: (optionIndex) {
                                setState(() {
                                  if (selectedIndex == optionIndex) {
                                    _selectedOptions.remove(index);
                                  } else {
                                    _selectedOptions[index] = optionIndex;
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8F1D1D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 8,
                        shadowColor: const Color(0x338F1D1D),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'submit',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
          Positioned(
            top: -47,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/images/sylo.png',
                height: 160,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizQuestionCard extends StatelessWidget {
  const _QuizQuestionCard({
    required this.questionNumber,
    required this.question,
    required this.selectedIndex,
    required this.onOptionSelected,
  });

  final int questionNumber;
  final _QuizQuestion question;
  final int? selectedIndex;
  final ValueChanged<int> onOptionSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE1BA63),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(26, 22, 26, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Question ${_formatQuestionNumber(questionNumber)}',
                  style: const TextStyle(
                    color: Color(0xFFF7F1DE),
                    fontFamily: 'Quicksand',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Icon(
                Icons.help_outline,
                color: Color(0xFFF7F1DE),
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F1DE),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            question.prompt,
            style: const TextStyle(
              color: Color(0xFFF7F1DE),
              fontFamily: 'Quicksand',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (int i = 0; i < question.options.length; i++)
                _QuizOption(
                  label: question.options[i],
                  isSelected: selectedIndex == i,
                  onTap: () => onOptionSelected(i),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuizOption extends StatelessWidget {
  const _QuizOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8F1D1D) : const Color(0xFFF7F1DE),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFF7F1DE),
            width: isSelected ? 0 : 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF8F1D1D),
            fontFamily: 'Quicksand',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _TopBarIconColumn extends StatelessWidget {
  const _TopBarIconColumn({required this.topAsset, required this.bottomAsset});

  final String topAsset;
  final String bottomAsset;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RoundedIcon(asset: topAsset),
        const SizedBox(height: 18),
        _RoundedIcon(asset: bottomAsset),
      ],
    );
  }
}

class _RoundedIcon extends StatelessWidget {
  const _RoundedIcon({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: 48,
      child: Center(child: Image.asset(asset, height: 32, fit: BoxFit.contain)),
    );
  }
}

class _QuizQuestion {
  const _QuizQuestion({required this.prompt, required this.options});

  final String prompt;
  final List<String> options;
}

String _formatQuestionNumber(int value) => value.toString().padLeft(2, '0');
