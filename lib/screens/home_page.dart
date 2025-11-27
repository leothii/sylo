// lib/screens/home_page.dart

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For auth state listener

import '../utils/app_colors.dart';
import '../utils/streak_service.dart';
import '../models/attachment_payload.dart';
import '../models/study_material.dart';
import '../services/gemini_file_service.dart';
import '../utils/streak_service.dart'; // Streak Service
import '../utils/smooth_page.dart'; // Smooth Page Route
import '../widgets/audio_card.dart';
import '../widgets/sylo_chat_overlay.dart';
import '../widgets/streak_overlay.dart'; // Streak Overlay

import 'settings_overlay.dart';
import 'summary_page.dart';
import 'notes_page.dart';
import 'quiz_page.dart';
import 'profile_page.dart';
import 'music_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _interestController = TextEditingController();
  GeminiLocalAttachment? _selectedAttachment;
  GeminiFileAttachment? _uploadedAttachment;
  bool _isUploadingAttachment = false;
  String? _attachmentError;
  int _attachmentUploadToken = 0;

  // Streak State
  int _streakCount = 0;
  bool _hasChattedToday = false;

  @override
  void initState() {
    super.initState();

    // Listen for Auth changes to load correct user data
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null && mounted) {
        _loadStreakData();
      }
    });

    _loadStreakData(); // Initial load
  }

  Future<void> _loadStreakData() async {
    final count = await StreakService.getStreakCount();
    final hasChatted = await StreakService.hasChattedToday();

    if (mounted) {
      setState(() {
        _streakCount = count;
        _hasChattedToday = hasChatted;
      });
    }
  }

  // Helper to trigger streak update (e.g. when clicking Analyze)
  Future<void> _triggerStreakUpdate() async {
    bool streakUpdated = await StreakService.updateStreak();

    if (streakUpdated && mounted) {
      int newCount = await StreakService.getStreakCount();
      Set<int> activeDays = await StreakService.getActiveWeekdays();

      // Show the overlay smoothly
      await showSmoothDialog(
        context: context,
        builder: (_) =>
            StreakOverlay(currentStreak: newCount, activeWeekdays: activeDays),
      );

      // Refresh UI immediately
      _loadStreakData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTopBar(),
                      const SizedBox(height: 24),
                      _buildWelcomeCard(context),
                      SizedBox(
                        height: _selectedAttachment != null ? 72 : 32,
                      ),
                      _buildAudioCard(context),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _interestController.dispose();
    super.dispose();
  }

  void _openSettingsOverlay() {
    showDialog(
      context: context,
      builder: (context) => const SettingsOverlay(),
    ).then((_) => _loadStreakData()); // Refresh on return
  }

  Widget _buildTopBar() {
    final Color flameColor = _hasChattedToday
        ? const Color(0xFFFFA000) // Orange
        : const Color(0xFFAAAAAA); // Pale Grey

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            _IconBadge(
              assetPath: 'assets/icons/profile.png',
              size: 30,
              onTap: () {
                Navigator.of(
                  context,
                ).push(SmoothPageRoute(builder: (_) => const ProfilePage()));
              },
            ),
            const SizedBox(height: 18),
            _IconBadge(
              assetPath: 'assets/icons/note.png',
              size: 30,
              onTap: () {
                Navigator.of(
                  context,
                ).push(SmoothPageRoute(builder: (_) => const NotesPage()));
              },
            ),
          ],
        ),
        const Spacer(),

        // --- FLAME INDICATOR ---
        GestureDetector(
          onTap: _showStreakOverlay,
          child: Container(
            margin: const EdgeInsets.only(right: 12, top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.local_fire_department_rounded,
        Container(
          margin: const EdgeInsets.only(right: 12, top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_fire_department_rounded,
                color: flameColor,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '$_streakCount',
                style: TextStyle(
                  fontFamily: 'Bungee',
                  fontSize: 16,
                  color: flameColor,
                ),
              ),
            ],
          ),
        ),

        // -----------------------
        Column(
          children: [
            _IconBadge(
              assetPath: 'assets/icons/settings.png',
              size: 30,
              onTap: _openSettingsOverlay,
            ),
            const SizedBox(height: 18),
            _IconBadge(assetPath: 'assets/icons/sound.png', size: 30),
          ],
        ),
      ],
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    const Color cardColor = Color(0xFFF8EFDC);

    return AnimatedContainer(
      height: _welcomeCardHeight(),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 20,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(24, 90, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildSearchField(),
                  if (_selectedAttachment != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 18,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.insert_drive_file,
                                color: Color(0xFF787878),
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedAttachment!.displayName,
                                      style: const TextStyle(
                                        color: Color(0xFF4D4D4D),
                                        fontSize: 14,
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatAttachmentSize(
                                        _selectedAttachment!.sizeBytes,
                                      ),
                                      style: const TextStyle(
                                        color: Color(0xFF787878),
                                        fontSize: 12,
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                tooltip: 'Remove attachment',
                                iconSize: 20,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  setState(() {
                                    _attachmentUploadToken++;
                                    _selectedAttachment = null;
                                    _uploadedAttachment = null;
                                    _attachmentError = null;
                                    _isUploadingAttachment = false;
                                  });
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Color(0xFF676767),
                                ),
                              ),
                            ],
                          ),
                          if (_isUploadingAttachment) ...[
                            const SizedBox(height: 16),
                            const LinearProgressIndicator(minHeight: 6),
                            const SizedBox(height: 8),
                            const Text(
                              'Uploading to Sylo AI...',
                              style: TextStyle(
                                color: Color(0xFF898989),
                                fontSize: 12,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ] else if (_uploadedAttachment != null) ...[
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF3FA65C),
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    'Ready — synced with Sylo AI.',
                                    style: TextStyle(
                                      color: Color(0xFF3FA65C),
                                      fontSize: 12,
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (_attachmentError != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              _attachmentError!,
                              style: const TextStyle(
                                color: Color(0xFFD9534F),
                                fontSize: 12,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ActionButton(
                        label: 'analyze',
                        icon: Icons.lightbulb_outline,
                        onTap: _openSummary,
                      ),
                      _ActionButton(
                        label: 'try quiz',
                        icon: Icons.help_outline,
                        onTap: _openQuiz,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -42,
            left: -10,
            child: GestureDetector(
              onTap: () async {
                await showSyloChatOverlay(context);
                _loadStreakData(); // Refresh flame on return
              },
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

  double _welcomeCardHeight() {
    double height = 320;

    if (_selectedAttachment != null) {
      height += 160; // base expansion for attachment card

      if (_isUploadingAttachment || _uploadedAttachment != null) {
        height += 40; // room for progress or success state
      }

      if (_attachmentError != null) {
        height += 40; // room for error message
      }
    }

    return height;
  }

  // --- REFRESH FIX HERE ---
  // --- REFRESH & STREAK LOGIC ---
  void _openSummary() async {
    final String rawText = _interestController.text.trim();
    final StudyMaterial material = StudyMaterial(
      text: rawText.isNotEmpty ? rawText : null,
      attachments: _selectedAttachment == null
          ? const <GeminiLocalAttachment>[]
          : <GeminiLocalAttachment>[_selectedAttachment!],
    );

    if (material.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter some study material or attach a document.',
          ),
        ),
      );
      return;
    }

    if (_isUploadingAttachment) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hold on—Sylo is still preparing your attachment.'),
        ),
      );
      return;
    }

    if (_attachmentError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_attachmentError!)),
      );
      return;
    }

    // Trigger Streak Update Here!
    await _triggerStreakUpdate();

    if (!mounted) {
      return;
    }

    final PreparedStudyMaterial? initialPrepared =
        _buildInitialPreparedMaterial(rawText: rawText);

    Navigator.of(context)
        .push(
          SmoothPageRoute(
            builder: (_) => SummaryPage(
              material: material,
              initialPreparedMaterial: initialPrepared,
            ),
          ),
        )
        .then((_) => _loadStreakData()); // Refresh when returning
  }

  // --- REFRESH LOGIC ---
  void _openQuiz() {
    final String rawText = _interestController.text.trim();
    final StudyMaterial material = StudyMaterial(
      text: rawText.isNotEmpty ? rawText : null,
      attachments: _selectedAttachment == null
          ? const <GeminiLocalAttachment>[]
          : <GeminiLocalAttachment>[_selectedAttachment!],
    );

    if (material.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter some study material or attach a document.',
          ),
        ),
      );
      return;
    }

    if (_isUploadingAttachment) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hold on—Sylo is still preparing your attachment.'),
        ),
      );
      return;
    }

    if (_attachmentError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_attachmentError!)),
      );
      return;
    }

    final PreparedStudyMaterial? initialPrepared =
        _buildInitialPreparedMaterial(rawText: rawText);

    Navigator.of(context)
        .push(
          SmoothPageRoute(
            builder: (_) => QuizPage(
              material: material,
              initialPreparedMaterial: initialPrepared,
            ),
          ),
        )
        .then((_) => _loadStreakData()); // Refresh when returning
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _interestController,
              style: const TextStyle(
                color: Color(0xFF676767),
                fontSize: 16,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration.collapsed(
                hintText: 'what interest you?',
                hintStyle: TextStyle(
                  color: Color(0xFF676767),
                  fontSize: 16,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _openFilePicker,
            child: Image.asset(
              'assets/icons/attachment.png',
              width: 26,
              height: 26,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioCard(BuildContext context) {
    return AudioCard(
      onTap: () {
        Navigator.of(
          context,
        ).push(SmoothPageRoute(builder: (_) => const MusicPage()));
      },
    );
  }

  PreparedStudyMaterial? _buildInitialPreparedMaterial({
    required String rawText,
  }) {
    final String trimmed = rawText.trim();
    final String? text = trimmed.isEmpty ? null : trimmed;

    if (_uploadedAttachment == null) {
      if (text == null) {
        return null;
      }

      return PreparedStudyMaterial(
        text: text,
        attachments: const <GeminiFileAttachment>[],
      );
    }

    return PreparedStudyMaterial(
      text: text,
      attachments: <GeminiFileAttachment>[_uploadedAttachment!],
    );
  }

  Future<void> _beginAttachmentUpload(GeminiLocalAttachment attachment) async {
    final int token = ++_attachmentUploadToken;

    setState(() {
      _isUploadingAttachment = true;
      _attachmentError = null;
      _uploadedAttachment = null;
    });

    try {
      final GeminiFileAttachment uploaded =
          await GeminiFileService.instance.upload(attachment);

      if (!mounted || token != _attachmentUploadToken) {
        return;
      }

      setState(() {
        _uploadedAttachment = uploaded;
        _isUploadingAttachment = false;
      });
    } catch (error) {
      if (!mounted || token != _attachmentUploadToken) {
        return;
      }

      final String message =
          error is StateError && error.message.trim().isNotEmpty
              ? error.message.trim()
              : 'Unable to upload the attachment. Please try again.';

      setState(() {
        _attachmentError = message;
        _isUploadingAttachment = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  String _formatAttachmentSize(int bytes) {
    if (bytes <= 0) {
      return 'Unknown size';
    }

    const int kb = 1024;
    const int mb = kb * 1024;

    if (bytes >= mb) {
      return '${(bytes / mb).toStringAsFixed(2)} MB';
    }

    if (bytes >= kb) {
      return '${(bytes / kb).toStringAsFixed(1)} KB';
    }

    return '$bytes B';
  }

  Future<void> _openFilePicker() async {
    const int maxBytes = 10 * 1024 * 1024;
    final List<String> allowedExtensions = [
      'pdf',
      'doc',
      'docx',
      'txt',
      'jpg',
      'jpeg',
      'png',
      'mp3',
      'wav',
      'm4a',
      'ppt',
      'pptx',
    ];

    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
        withData: true,
        withReadStream: true,
      );

      if (!mounted || result == null || result.files.isEmpty) return;

      final PlatformFile file = result.files.single;
      final int size = file.size;

      if (size > maxBytes) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please choose a file smaller than 10 MB.'),
          ),
        );
        return;
      }

      Uint8List? bytes = file.bytes;

      if (bytes == null && file.readStream != null) {
        final List<int> collected = <int>[];
        await for (final List<int> chunk in file.readStream!) {
          collected.addAll(chunk);
          if (collected.length > maxBytes) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please choose a file smaller than 10 MB.'),
              ),
            );
            return;
          }
        }
        bytes = Uint8List.fromList(collected);
      }

      if (bytes == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to read the selected file. Please try again.'),
          ),
        );
        return;
      }

      if (bytes.lengthInBytes > maxBytes) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please choose a file smaller than 10 MB.'),
          ),
        );
        return;
      }

      final GeminiLocalAttachment attachment = GeminiLocalAttachment(
        bytes: bytes,
        displayName: file.name,
        mimeType: GeminiFileService.inferMimeType(file.extension),
      );

      setState(() {
        _selectedAttachment = attachment;
        _attachmentError = null;
      });

      _beginAttachmentUpload(attachment);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selected "${file.name}"')),
      );
    } catch (error) {
      debugPrint('File picker error: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open file picker. Please try again.'),
        ),
      );
    }
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.icon, this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final buttonContent = Container(
      height: 46,
      width: 130,
      decoration: BoxDecoration(
        color: const Color(0xFFF28974),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF4D4D4D)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF4D4D4D),
              fontSize: 16,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return buttonContent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: buttonContent,
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.assetPath, this.size = 44, this.onTap});
  final String assetPath;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
    if (onTap == null) {
      return SizedBox(
        height: size,
        width: size,
        child: Center(child: image),
      );
    }
    return SizedBox(
      height: size,
      width: size,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Center(child: image),
      ),
    );
  }
}
