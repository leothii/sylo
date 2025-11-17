// lib/screens/score_page.dart

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/audio_card.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  // Layout constants from your other pages for consistency
  final double _cardTopMargin = 72;
  final double _cardHorizontalPadding = 30;
  final double _cardVerticalPaddingBottom = 36;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground, // #8AABC7
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTopBar(), // Re-used from other pages
              const SizedBox(height: 24),
              _buildScoreCard(context), // The main content
              const SizedBox(height: 32),
              const AudioCard(playIconVerticalOffset: -10), // Re-used
            ],
          ),
        ),
      ),
    );
  }

  // --- Top Bar (Identical to notes_page.dart) ---
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

  // --- Main Score Card Content ---
  Widget _buildScoreCard(BuildContext context) {
    return Expanded(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // --- Main Card Background ---
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: _cardTopMargin),
              padding: EdgeInsets.fromLTRB(
                _cardHorizontalPadding,
                0, // Padding is handled inside the column
                _cardHorizontalPadding,
                _cardVerticalPaddingBottom,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF8EFDC), // From assets
                borderRadius: BorderRadius.circular(32),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 22,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- Close Button ---
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF776E67)),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                  // --- "SCORE" Image ---
                  Image.asset(
                    'assets/images/Score.svg', // From your asset list
                    height: 38,
                  ),
                  const SizedBox(height: 24),
                  // --- "10/10" Text ---
                  Text(
                    '10/10',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w700,
                      fontSize: 72,
                      color: Color(0xFF95A995), // From assets
                    ),
                  ),
                  const SizedBox(height: 24),
                  // --- Quote Block ---
                  _buildQuoteBlock(),
                  const SizedBox(height: 32),
                  // --- Retry Button ---
                  _buildRetryButton(),
                  // Spacer pushes content up if the screen is tall
                  const Spacer(),
                ],
              ),
            ),
          ),
          // --- Happy Owl Image ---
          Positioned(
            top: -47, // Same as other pages
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                // This path is based on your Figma asset name
                'assets/images/happy_owl.png',
                height: 160,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper for the Quote Block ---
  Widget _buildQuoteBlock() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFE1B964), // From assets
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // --- Quote Icon ---
          Text(
            '“',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w900,
              fontSize: 48,
              color: Color(0xFFF8EFDC).withOpacity(0.6),
              height: 1.0,
            ),
          ),
          // --- Quote Text ---
          Text(
            'A journey of a thousand miles begins with a single step',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Color(0xFFF8EFDC),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          // --- Author Row ---
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 2,
                color: Color(0xFFF8EFDC).withOpacity(0.7),
              ),
              const SizedBox(width: 12),
              Text(
                'lao tzu',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Color(0xFFF8EFDC),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Helper for the Retry Button ---
  Widget _buildRetryButton() {
    return Material(
      color: const Color(0xFF882225), // From assets
      borderRadius: BorderRadius.circular(18),
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          // TODO: Add your retry logic here
          // e.g., Navigator.of(context).popAndPushNamed('/quiz');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Image.asset(
            // Assuming this path from your asset list
            'assets/icons/refresh.png',
            width: 32,
            height: 32,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// --- Re-used Helper Widgets (Identical to notes_page.dart) ---
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
