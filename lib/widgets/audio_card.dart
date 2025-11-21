// lib/widgets/audio_card.dart

import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/audio_player_service.dart';

class AudioCard extends StatefulWidget {
  const AudioCard({
    super.key,
    this.backgroundColor = const Color(0xFF7D9BB7),
    this.shadowColor = const Color(0x26000000),
    this.borderRadius = 36,
    this.leadingIcon = Icons.music_note,
    this.leadingBackground = Colors.white,
    this.title,
    this.artist,
    this.isPlaying,
    this.bindToService = true,
    this.onPlayPause,
    this.onClose,
    this.onTap,
  });

  final Color backgroundColor;
  final Color shadowColor;
  final double borderRadius;
  final IconData leadingIcon;
  final Color leadingBackground;
  final String? title;
  final String? artist;
  final bool? isPlaying;
  final bool bindToService;
  final VoidCallback? onPlayPause;
  final VoidCallback? onClose;
  final VoidCallback? onTap;

  @override
  State<AudioCard> createState() => _AudioCardState();
}

class _AudioCardState extends State<AudioCard> {
  late final AudioPlayerService _service;
  StreamSubscription<bool>? _playingSub;
  String? _fileName;
  bool _isPlaying = false;

  bool get _bindsToService => widget.bindToService;
  bool get _hasTrack => _service.filePath != null;

  @override
  void initState() {
    super.initState();
    _service = AudioPlayerService.instance;

    if (_bindsToService) {
      _fileName = _service.fileName.value;
      _isPlaying = _service.player.playing;
      _service.fileName.addListener(_onFileNameChanged);
      _playingSub = _service.player.playingStream.listen((playing) {
        if (!mounted) return;
        setState(() => _isPlaying = playing);
      });
      _ensureInitialized();
    } else {
      _fileName = widget.title;
      _isPlaying = widget.isPlaying ?? false;
    }
  }

  Future<void> _ensureInitialized() async {
    await _service.initialize();
    if (!mounted || !_bindsToService) return;
    setState(() {
      _fileName = _service.fileName.value;
      _isPlaying = _service.player.playing;
    });
  }

  @override
  void didUpdateWidget(covariant AudioCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_bindsToService) {
      if (widget.title != oldWidget.title || widget.isPlaying != oldWidget.isPlaying) {
        setState(() {
          _fileName = widget.title;
          _isPlaying = widget.isPlaying ?? false;
        });
      }
    }
  }

  @override
  void dispose() {
    if (_bindsToService) {
      _service.fileName.removeListener(_onFileNameChanged);
      _playingSub?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String displayTitle = _bindsToService
        ? (_fileName ?? 'No audio selected')
        : (widget.title ?? 'Song Title');

    final String displayArtist = widget.artist ??
        (_bindsToService
            ? (_hasTrack ? 'Now playing' : 'Tap to open music page')
            : 'Artist Name');

    final bool displayIsPlaying = _bindsToService
        ? (_hasTrack && _isPlaying)
        : (widget.isPlaying ?? false);

    final VoidCallback? effectiveOnPlayPause = widget.onPlayPause ??
        (_bindsToService && _hasTrack
            ? () => _togglePlayback()
            : null);

    final VoidCallback? effectiveOnClose = widget.onClose ??
        (_bindsToService && _hasTrack
            ? () => _handleClose()
            : null);

    final cardContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: [
          BoxShadow(
            color: widget.shadowColor,
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LeadingIcon(icon: widget.leadingIcon, background: widget.leadingBackground),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayTitle,
                  style: const TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 16,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  displayArtist,
                  style: const TextStyle(
                    color: Color(0xFFDFE6ED),
                    fontSize: 14,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _PlayPauseButton(isPlaying: displayIsPlaying, onPressed: effectiveOnPlayPause),
          const SizedBox(width: 10),
          _CloseButton(onPressed: effectiveOnClose),
        ],
      ),
    );

    if (widget.onTap == null) {
      return cardContent;
    }

    return GestureDetector(onTap: widget.onTap, child: cardContent);
  }

  void _onFileNameChanged() {
    if (!_bindsToService || !mounted) {
      return;
    }
    final String? nextName = _service.fileName.value;
    if (nextName == _fileName) {
      return;
    }
    setState(() => _fileName = nextName);
  }

  Future<void> _togglePlayback() async {
    if (!_hasTrack) {
      return;
    }
    if (_service.player.playing) {
      await _service.player.pause();
    } else {
      await _service.player.play();
    }
  }

  Future<void> _handleClose() async {
    if (!_hasTrack) {
      return;
    }
    await _service.player.stop();
    await _service.clearSelection();
    if (!mounted) {
      return;
    }
    setState(() {
      _isPlaying = false;
      _fileName = null;
    });
  }
}

class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon({required this.icon, required this.background});

  final IconData icon;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: const Color(0xFF7D9BB7), size: 24),
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  const _PlayPauseButton({required this.isPlaying, this.onPressed});

  final bool isPlaying;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFFFFFFFF),
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
        ),
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
          color: const Color(0xFF7D9BB7),
          size: 22,
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.close, color: Colors.white, size: 22),
      splashRadius: 20,
    );
  }
}
