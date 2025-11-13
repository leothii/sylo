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

  final double _cardTopMargin = 72;
  final double _cardHorizontalPadding = 28;
  final double _cardVerticalPadding = 52;
  final double _titleOffsetY = -60;
  final double _titleSpacingBelow = 12;

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
              padding: EdgeInsets.symmetric(
                horizontal: _cardHorizontalPadding,
                vertical: _cardVerticalPadding,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF6EDD7),
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 20,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF7C6C63)),
                      onPressed: () {},
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, _titleOffsetY),
                    child: Text(
                      'QUIZ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFAF3E37),
                        fontFamily: 'Bungee',
                        fontSize: 32,
                        shadows: [
                          Shadow(
                            color: const Color(0x338F1D1D),
                            offset: const Offset(0, 4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: _titleSpacingBelow),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(top: 16, bottom: 12),
                      itemCount: _questions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        final question = _questions[index];
                        final selectedIndex = _selectedOptions[index];
                        return _QuizQuestionCard(
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
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8F1D1D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 6,
                        shadowColor: const Color(0x338F1D1D),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'submit',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
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
          Positioned(
            top: _cardTopMargin + 40,
            right: 16,
            child: Container(
              width: 16,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF8F1D1D),
                borderRadius: BorderRadius.circular(12),
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
    required this.question,
    required this.selectedIndex,
    required this.onOptionSelected,
  });

  final _QuizQuestion question;
  final int? selectedIndex;
  final ValueChanged<int> onOptionSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.prompt,
            style: const TextStyle(
              color: Color(0xFF6F665F),
              fontFamily: 'Quicksand',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < question.options.length; i++)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: i == question.options.length - 1 ? 0 : 12,
                    ),
                    child: _QuizOption(
                      label: question.options[i],
                      isSelected: selectedIndex == i,
                      onTap: () => onOptionSelected(i),
                    ),
                  ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF8C8279), width: 2),
            ),
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: isSelected ? 16 : 0,
                height: isSelected ? 16 : 0,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF8C8279)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF8C8279),
              fontFamily: 'Quicksand',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
