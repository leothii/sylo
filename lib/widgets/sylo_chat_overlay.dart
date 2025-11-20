import 'dart:math' as math;

import 'package:flutter/material.dart';

const Offset kDefaultSyloOwlOffset = Offset(-0.2, -0.77);
const Offset kDefaultSyloBrandTextOffset = Offset(0.6, -0.52);
const double kDefaultCardVerticalFactor = 0.70;

Future<void> showSyloChatOverlay(
  BuildContext context, {
  Offset? owlOffset,
  Offset? brandTextOffset,
  double? cardVerticalFactor,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.75),
    builder: (_) => SyloChatOverlay(
      owlOffset: owlOffset,
      brandTextOffset: brandTextOffset,
      cardVerticalFactor: cardVerticalFactor,
    ),
  );
}

class SyloChatOverlay extends StatelessWidget {
  const SyloChatOverlay({
    super.key,
    this.owlOffset,
    this.brandTextOffset,
    this.cardVerticalFactor,
  });

  final Offset? owlOffset;
  final Offset? brandTextOffset;
  final double? cardVerticalFactor;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double cardWidth = math.min(320, constraints.maxWidth * 0.82);
            final double owlHeight = math.min(220, constraints.maxWidth * 0.6);
            final double layoutWidth = cardWidth + owlHeight * 0.4;
            final double cardTopFactor =
                cardVerticalFactor ?? kDefaultCardVerticalFactor;
            final double cardTop = owlHeight * cardTopFactor;
            final double cardLeft = (layoutWidth - cardWidth) / 2;
            final Offset effectiveOwlOffset =
                owlOffset ?? kDefaultSyloOwlOffset;
            final Offset effectiveBrandTextOffset =
                brandTextOffset ?? kDefaultSyloBrandTextOffset;

            return SizedBox(
              width: layoutWidth,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: cardTop,
                    left: cardLeft,
                    child: Container(
                      width: cardWidth,
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 30),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8EFDC),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          _OverlayCloseButton(),
                          SizedBox(height: 16),
                          _RecentInteractionPlaceholder(),
                          SizedBox(height: 20),
                          _ChatPromptField(),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: cardTop + owlHeight * effectiveOwlOffset.dy,
                    left: cardLeft + owlHeight * effectiveOwlOffset.dx,
                    child: _SyloOwlImage(height: owlHeight),
                  ),
                  Positioned(
                    top: cardTop + owlHeight * effectiveBrandTextOffset.dy,
                    left: cardLeft + owlHeight * effectiveBrandTextOffset.dx,
                    child: _SyloBrandingText(maxWidth: cardWidth),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SyloOwlImage extends StatelessWidget {
  const _SyloOwlImage({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/sylo.png',
      height: height,
      fit: BoxFit.contain,
    );
  }
}

class _SyloBrandingText extends StatelessWidget {
  const _SyloBrandingText({required this.maxWidth});

  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final double constrainedWidth = math.min(maxWidth * 0.7, 220);

    return SizedBox(
      width: constrainedWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'sy',
                  style: TextStyle(
                    color: const Color(0xFF882124),
                    fontSize: 32,
                    fontFamily: 'Bungee',
                    fontWeight: FontWeight.w400,
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.25),
                      ),
                    ],
                  ),
                ),
                TextSpan(
                  text: 'lo',
                  style: TextStyle(
                    color: const Color(0xFFF1F1F1),
                    fontSize: 32,
                    fontFamily: 'Bungee',
                    fontWeight: FontWeight.w400,
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.25),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'your AI companion \non the go',
            style: TextStyle(
              color: Color(0xFFF8EFDC),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _OverlayCloseButton extends StatelessWidget {
  const _OverlayCloseButton();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: const Icon(Icons.close, color: Color(0xFF776E67)),
        splashRadius: 20,
        onPressed: () => Navigator.of(context).maybePop(),
      ),
    );
  }
}

class _RecentInteractionPlaceholder extends StatelessWidget {
  const _RecentInteractionPlaceholder();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Center(
        child: Text(
          'no recent interaction',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF95A995),
            fontSize: 20,
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ChatPromptField extends StatelessWidget {
  const _ChatPromptField();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8EFDC),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'tap to chat...',
                hintStyle: TextStyle(
                  color: Color(0xFF676767),
                  fontSize: 14,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: TextStyle(
                color: Color(0xFF676767),
                fontSize: 14,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Image.asset('assets/icons/attachment.png', width: 22, height: 22),
        ],
      ),
    );
  }
}
