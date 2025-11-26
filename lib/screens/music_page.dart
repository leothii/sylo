// lib/screens/music_page.dart

import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';

import 'settings_overlay.dart';
import '../widgets/sylo_chat_overlay.dart';
import '../widgets/spotify_api.dart';
import '../utils/audio_player_service.dart';
import '../utils/smooth_page.dart'; // <--- Import SmoothPageRoute
import '../services/spotify_service.dart';
import '../utils/env.dart';
import 'profile_page.dart';
import 'home_page.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  // --- Layout Constants ---
  final double _owlHeight = 150;
  final double _cardTopPosition = 160;
  final double _owlVerticalOffset = -115;

  // --- Color Palette ---
  static const Color _colBackgroundBlue = Color(0xFF8AABC7);
  static const Color _colCardBlue = Color(0xFF7591A9); // Main player card
  static const Color _colBtnCream = Color(0xFFF7DB9F);
  static const Color _colBtnGold = Color(0xFFE1B964);
  static const Color _colIconCream = Color(0xFFF7DB9F);
  static const Color _colTextGrey = Color(0xFF898989);
  static const Color _colNavItem = Color(0xFFE1B964); // Inactive Icon
  static const Color _colNavActiveBg = Color(
    0xFF7591A9,
  ); // Active Blue Background
  static const Color _colShadow = Color(0x3F000000);

  late final AudioPlayerService _audioService;
  AudioPlayer get _player => _audioService.player;
  final SpotifyService _spotifyService = SpotifyService.instance;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<PlayerState>? _playerStateSub;
  VoidCallback? _fileNameListener;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isLoadingFile = false;
  bool _isConnectingSpotify = false;
  String? _selectedFileName;

  bool get _hasTrack => _duration > Duration.zero;
  bool get _isPlaying => _player.playing;

  double get _sliderProgress {
    if (!_hasTrack) {
      return 0;
    }
    final totalMs = _duration.inMilliseconds;
    if (totalMs == 0) {
      return 0;
    }
    final currentMs = _position.inMilliseconds.clamp(0, totalMs);
    return currentMs / totalMs;
  }

  @override
  void initState() {
    super.initState();
    _audioService = AudioPlayerService.instance;
    _initializeAudio();
    _initializeSpotify();
  }

  Future<void> _initializeAudio() async {
    await _audioService.initialize();
    if (!mounted) return;

    _fileNameListener = () {
      if (!mounted) return;
      setState(() {
        _selectedFileName = _audioService.fileName.value;
      });
    };
    _audioService.fileName.addListener(_fileNameListener!);

    setState(() {
      _selectedFileName = _audioService.fileName.value;
      _position = _player.position;
      final Duration? initialDuration = _player.duration;
      if (initialDuration != null) {
        _duration = initialDuration;
      }
    });

    _positionSub = _player.positionStream.listen((position) {
      if (!mounted) return;
      setState(() => _position = position);
    });
    _durationSub = _player.durationStream.listen((duration) {
      if (!mounted || duration == null) return;
      setState(() => _duration = duration);
    });
    _playerStateSub = _player.playerStateStream.listen((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  Future<void> _initializeSpotify() async {
    await _spotifyService.ensureInitialized();
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _playerStateSub?.cancel();
    if (_fileNameListener != null) {
      _audioService.fileName.removeListener(_fileNameListener!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colBackgroundBlue,
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        height: 80,
        color: _colBackgroundBlue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 1. Profile Icon -> Navigates to ProfilePage
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  SmoothPageRoute(
                    builder: (_) => const ProfilePage(),
                  ), // <--- Smooth
                );
              },
              child: const Icon(Icons.person, color: _colNavItem, size: 32),
            ),

            // 2. Home Icon -> Navigates back to HomePage
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

            // 3. Headphones Icon (ACTIVE) -> Has Blue Indicator
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _colNavActiveBg, // Blue background indicator
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.headphones, color: _colNavItem, size: 32),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // --- 1. THE MAIN MUSIC CARD ---
            Positioned(
              top: _cardTopPosition,
              bottom: 100,
              left: 24,
              right: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  color: _colCardBlue,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1F000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Close Button
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white70,
                          size: 28,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Playback Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.skip_previous,
                          color: const Color(0xFFF7DB9F).withValues(alpha: 0.5),
                          size: 34,
                        ),
                        const SizedBox(width: 24),
                        _buildPlayPauseButton(),
                        const SizedBox(width: 24),
                        Icon(
                          Icons.skip_next,
                          color: _colIconCream.withValues(alpha: 0.5),
                          size: 34,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    if (_selectedFileName != null) ...[
                      Text(
                        _selectedFileName!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                    ] else ...[
                      const Text(
                        'Upload an audio file to get started',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                    ],

                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 2,
                        activeTrackColor: _colIconCream,
                        inactiveTrackColor: Colors.white24,
                        thumbColor: _colIconCream,
                        overlayColor: Colors.transparent,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 8,
                        ),
                      ),
                      child: Slider(
                        min: 0,
                        max: 1,
                        value: _sliderProgress,
                        onChanged: (_hasTrack && !_isLoadingFile)
                            ? (value) => _onSeek(value)
                            : null,
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(_position),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _formatDuration(_duration),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    _buildActionButton(
                      text: 'upload an audio',
                      icon: Icons.file_upload_outlined,
                      bgColor: _colBtnCream,
                      textColor: _colTextGrey,
                      onTap: _pickAudio,
                      isBusy: _isLoadingFile,
                      enabled: !_isLoadingFile,
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'or',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // "Logged as user" Button
                    ValueListenableBuilder<SpotifySession?>(
                      valueListenable: _spotifyService.session,
                      builder: (BuildContext context, SpotifySession? session, _) {
                        final bool connected = session != null;
                        final String buttonLabel = connected ? 'open spotify player' : 'connect to spotify';
                        final IconData buttonIcon = connected ? Icons.play_circle_fill : Icons.wifi;
                        final VoidCallback action = connected ? _openSpotifyPlayer : _connectSpotify;
                        final bool enabled = connected || Env.hasSpotifyCredentials;

                        return Column(
                          children: [
                            _buildActionButton(
                              text: buttonLabel,
                              icon: buttonIcon,
                              bgColor: _colBtnGold,
                              textColor: _colTextGrey,
                              onTap: action,
                              isBusy: !connected && _isConnectingSpotify,
                              enabled: enabled && (!_isConnectingSpotify || connected),
                            ),
                            const SizedBox(height: 8),
                            if (connected)
                              Text(
                                'Connected as ${session.displayName ?? session.userId ?? 'Spotify user'}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            else if (!Env.hasSpotifyCredentials)
                              const Text(
                                'Spotify integration not configured.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // --- 2. THE OWL IMAGE ---
            Positioned(
              top: _cardTopPosition + _owlVerticalOffset,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: () => showSyloChatOverlay(context),
                  child: Image.asset(
                    'assets/images/music_owl.png',
                    height: _owlHeight,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // --- 3. FLOATING ICONS ---
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

  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onTap,
    bool isBusy = false,
    bool enabled = true,
  }) {
    final bool disabled = !enabled || isBusy;
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 46,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          color: disabled ? bgColor.withValues(alpha: 0.6) : bgColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(color: _colShadow, blurRadius: 4, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isBusy)
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            else
              Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayPauseButton() {
    final bool canControl = _hasTrack && !_isLoadingFile;
    return SizedBox(
      width: 48,
      height: 48,
      child: ElevatedButton(
        onPressed: canControl ? _togglePlayback : null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: _colBtnCream,
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
        ),
        child: _isLoadingFile
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF513430)),
                ),
              )
            : Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: const Color(0xFF513430),
                size: 24,
              ),
      ),
    );
  }

  Future<void> _pickAudio() async {
    try {
      setState(() => _isLoadingFile = true);
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
      );

      if (!mounted) return;

      if (result == null || result.files.isEmpty) {
        return;
      }

      final PlatformFile file = result.files.single;
      final String? path = file.path;

      if (path == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open selected file.')),
        );
        return;
      }

      await _audioService.loadFile(path: path, displayName: file.name);

      setState(() {
        _duration = _player.duration ?? Duration.zero;
        _position = Duration.zero;
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load audio: $error')));
    } finally {
      if (mounted) {
        setState(() => _isLoadingFile = false);
      }
    }
  }

  Future<void> _connectSpotify() async {
    if (_isConnectingSpotify) {
      return;
    }
    setState(() => _isConnectingSpotify = true);

    final bool? connected = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => const SpotifyApiOverlay(),
    );

    if (!mounted) {
      return;
    }

    setState(() => _isConnectingSpotify = false);

    if (connected == true) {
      final SpotifySession? session = _spotifyService.session.value;
      final String name = session?.displayName ?? session?.userId ?? 'Spotify';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connected to $name.')),
      );
    }
  }

  Future<void> _openSpotifyPlayer() async {
    await _spotifyService.ensureAccessToken();

    const String fallbackUrl = 'https://open.spotify.com/';
    final Uri spotifyUri = Uri.parse('spotify://');
    final Uri webUri = Uri.parse(fallbackUrl);

    try {
      final bool launchedNative = await launchUrl(
        spotifyUri,
        mode: LaunchMode.externalApplication,
      );
      if (launchedNative) {
        return;
      }
    } catch (_) {
      // Native Spotify scheme failed; fall back to web.
    }

    try {
      final bool launchedWeb = await launchUrl(
        webUri,
        mode: LaunchMode.externalApplication,
      );
      if (launchedWeb) {
        return;
      }
    } catch (_) {
      // Web launch failed; show fallback message.
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Open Spotify to start listening.'),
      ),
    );
  }

  Future<void> _togglePlayback() async {
    if (!_hasTrack) {
      return;
    }

    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  void _onSeek(double relative) {
    if (!_hasTrack) {
      return;
    }

    final int targetMs = (_duration.inMilliseconds * relative).round();
    _player.seek(Duration(milliseconds: targetMs));
  }

  String _formatDuration(Duration duration) {
    final int minutes = duration.inMinutes;
    final int seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
