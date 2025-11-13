// lib/screens/summary_page.dart

import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../widgets/audio_card.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  final double _summaryCardTopMargin = 64;
  final double _summaryCardHorizontalPadding = 28;
  final double _summaryCardTopPadding = 56;
  final double _summaryCardBottomPadding = 28;
  final double _summaryTitleSpacingAbove = 6;
  final double _summaryTitleSpacingBelow = 6;
  final double _summaryListSpacing = 24;
  final double _owlHeight = 150;
  final double _owlVerticalOffset = -52;
  final double _summaryTitleOffsetX = 0;
  final double _summaryTitleOffsetY = -90;
  final double _leftTopIconContainerSize = 48;
  final double _leftTopIconImageSize = 28;
  final double _leftBottomIconContainerSize = 48;
  final double _leftBottomIconImageSize = 28;
  final double _rightTopIconContainerSize = 48;
  final double _rightTopIconImageSize = 28;
  final double _rightBottomIconContainerSize = 48;
  final double _rightBottomIconImageSize = 28;

  static const List<_SummaryItem> _items = [
    _SummaryItem(
      title: 'LOREM',
      description:
          'ipsum dolor sit amet. Est laborum voluptatem quo laudantium nisi et suscipit.',
    ),
    _SummaryItem(
      title: 'ANIMA',
      description:
          'et laudantium amet eum omnis tenetur ut animi quia? Est recusandae.',
    ),
    _SummaryItem(
      title: 'ABCAECATI',
      description:
          'ab provident numquam eum impedit iusto aut rerum ducimus. Qui dolorum repellat et temporibus.',
    ),
    _SummaryItem(
      title: 'LABORUM',
      description:
          'numquam obcaecati itaque qui esse officia et aliquid eius ut voluptates animi.',
    ),
    _SummaryItem(
      title: 'CULPA',
      description:
          'ratione in modi voluptatem aut quia impedit et nihil modi et cumque nulla.',
    ),
  ];

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
              _buildSummaryCard(context),
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
      children: [
        _TopBarIconColumn(
          topAsset: 'assets/icons/profile.png',
          bottomAsset: 'assets/icons/note.png',
          topContainerSize: _leftTopIconContainerSize,
          topImageSize: _leftTopIconImageSize,
          bottomContainerSize: _leftBottomIconContainerSize,
          bottomImageSize: _leftBottomIconImageSize,
        ),
        const Spacer(),
        _TopBarIconColumn(
          topAsset: 'assets/icons/settings.png',
          bottomAsset: 'assets/icons/sound.png',
          topContainerSize: _rightTopIconContainerSize,
          topImageSize: _rightTopIconImageSize,
          bottomContainerSize: _rightBottomIconContainerSize,
          bottomImageSize: _rightBottomIconImageSize,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Expanded(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: _summaryCardTopMargin),
              padding: EdgeInsets.fromLTRB(
                _summaryCardHorizontalPadding,
                _summaryCardTopPadding,
                _summaryCardHorizontalPadding,
                _summaryCardBottomPadding,
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
                  SizedBox(height: _summaryTitleSpacingAbove),
                  Transform.translate(
                    offset: Offset(_summaryTitleOffsetX, _summaryTitleOffsetY),
                    child: Text(
                      'SUMMARY',
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
                  SizedBox(height: _summaryTitleSpacingBelow),
                  Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      radius: const Radius.circular(12),
                      thickness: 6,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        itemCount: _items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          return RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Color(0xFF6F665F),
                                fontFamily: 'Quicksand',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                              children: [
                                TextSpan(
                                  text: '${item.title} - ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                TextSpan(text: item.description),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: _summaryListSpacing),
                  Row(
                    children: const [
                      _CardActionButton(asset: 'assets/icons/clipboard.png'),
                      Spacer(),
                      _CardActionButton(asset: 'assets/icons/export.png'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: _owlVerticalOffset,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/images/sylo.png',
                height: _owlHeight,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem {
  const _SummaryItem({required this.title, required this.description});

  final String title;
  final String description;
}

class _TopBarIconColumn extends StatelessWidget {
  const _TopBarIconColumn({
    required this.topAsset,
    required this.bottomAsset,
    required this.topContainerSize,
    required this.topImageSize,
    required this.bottomContainerSize,
    required this.bottomImageSize,
  });

  final String topAsset;
  final String bottomAsset;
  final double topContainerSize;
  final double topImageSize;
  final double bottomContainerSize;
  final double bottomImageSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RoundedIconButton(
          asset: topAsset,
          containerSize: topContainerSize,
          imageSize: topImageSize,
        ),
        const SizedBox(height: 18),
        _RoundedIconButton(
          asset: bottomAsset,
          containerSize: bottomContainerSize,
          imageSize: bottomImageSize,
        ),
      ],
    );
  }
}

class _RoundedIconButton extends StatelessWidget {
  const _RoundedIconButton({
    required this.asset,
    required this.containerSize,
    required this.imageSize,
  });

  final String asset;
  final double containerSize;
  final double imageSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: containerSize,
      width: containerSize,
      child: Center(
        child: Image.asset(asset, height: imageSize, fit: BoxFit.contain),
      ),
    );
  }
}

class _CardActionButton extends StatelessWidget {
  const _CardActionButton({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: 48,
      child: Center(
        child: Image.asset(asset, width: 26, height: 26, fit: BoxFit.contain),
      ),
    );
  }
}
