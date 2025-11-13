// lib/widgets/audio_card.dart

import 'package:flutter/material.dart';

class AudioCard extends StatefulWidget {
  const AudioCard({
    super.key,
    this.backgroundColor = const Color(0xFF7D9BB7),
    this.borderRadius = 32,
    this.shadowBlur = 24,
    this.shadowOffset = const Offset(0, 18),
    this.padding = const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
    this.initialProgress = 0.3,
    this.playIconAsset = 'assets/icons/play.png',
    this.uploadIconAsset = 'assets/icons/upload.png',
    this.spotifyIconAsset = 'assets/icons/spotify.png',
    this.iconSpacing = 35,
    this.playIconVerticalOffset = 0,
    this.onProgressChanged,
    this.onUploadTap,
    this.onSpotifyTap,
  });

  final Color backgroundColor;
  final double borderRadius;
  final double shadowBlur;
  final Offset shadowOffset;
  final EdgeInsetsGeometry padding;
  final double initialProgress;
  final String playIconAsset;
  final String uploadIconAsset;
  final String spotifyIconAsset;
  final double iconSpacing;
  final double playIconVerticalOffset;
  final ValueChanged<double>? onProgressChanged;
  final VoidCallback? onUploadTap;
  final VoidCallback? onSpotifyTap;

  @override
  State<AudioCard> createState() => _AudioCardState();
}

class _AudioCardState extends State<AudioCard> {
  late double _progress;

  @override
  void initState() {
    super.initState();
    _progress = widget.initialProgress.clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: [
          BoxShadow(
            color: const Color(0x26000000),
            blurRadius: widget.shadowBlur,
            offset: widget.shadowOffset,
          ),
        ],
      ),
      padding: widget.padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSlider(context),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _InteractiveIcon(
                asset: widget.uploadIconAsset,
                onTap: widget.onUploadTap,
              ),
              SizedBox(width: widget.iconSpacing),
              const Text(
                'or',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: widget.iconSpacing),
              _InteractiveIcon(
                asset: widget.spotifyIconAsset,
                onTap: widget.onSpotifyTap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2,
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withValues(alpha: 0.25),
              thumbColor: const Color(0xFFF7DB9F),
              overlayColor: Colors.transparent,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
            ),
            child: Slider(
              value: _progress,
              onChanged: (value) {
                setState(() => _progress = value);
                widget.onProgressChanged?.call(value);
              },
            ),
          ),
          Positioned(
            top: widget.playIconVerticalOffset,
            child: Image.asset(widget.playIconAsset, width: 42, height: 42),
          ),
        ],
      ),
    );
  }
}

class _InteractiveIcon extends StatelessWidget {
  const _InteractiveIcon({required this.asset, this.onTap});

  final String asset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final icon = Image.asset(asset, width: 28, height: 28, fit: BoxFit.contain);

    if (onTap == null) {
      return icon;
    }

    return GestureDetector(onTap: onTap, child: icon);
  }
}
