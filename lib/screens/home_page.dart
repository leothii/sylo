// lib/screens/home_page.dart

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../widgets/audio_card.dart';
import '../widgets/sylo_chat_overlay.dart';
import 'settings_overlay.dart';
import 'summary_page.dart';
import 'notes_page.dart';
import 'quiz_page.dart';
import 'profile_page.dart'; // <--- Added Import for ProfilePage
import 'music_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _interestController = TextEditingController();
  String? _selectedFileName;

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
                      const SizedBox(height: 32),
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
    showDialog(context: context, builder: (context) => const SettingsOverlay());
  }

  Widget _buildTopBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            // --- UPDATED PROFILE ICON ---
            _IconBadge(
              assetPath: 'assets/icons/profile.png',
              size: 30,
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
              },
            ),
            const SizedBox(height: 18),
            _IconBadge(
              assetPath: 'assets/icons/note.png',
              size:30,
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const NotesPage()));
              },
            ),
          ],
        ),
        const Spacer(),
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

    return SizedBox(
      height: 320,
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
                  if (_selectedFileName != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Selected: $_selectedFileName',
                      style: const TextStyle(
                        color: Color(0xFF4D4D4D),
                        fontSize: 14,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ActionButton(
                        label: 'analyze',
                        icon: Icons.lightbulb_outline,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SummaryPage(),
                            ),
                          );
                        },
                      ),
                      _ActionButton(
                        label: 'try quiz',
                        icon: Icons.help_outline,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const QuizPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // --- OWL WITH CHAT OVERLAY TRIGGER ---
          Positioned(
            top: -42,
            left: -10,
            child: GestureDetector(
              onTap: () => showSyloChatOverlay(context),
              child: Image.asset(
                'assets/images/sylo.png',
                height: 160,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // -------------------------------------
        ],
      ),
    );
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
    return AudioCard(onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const MusicPage()),
      );
    });
  }

  Future<void> _openFilePicker() async {
    const int maxBytes = 10 * 1024 * 1024; // 10 MB

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
      );

      if (!mounted || result == null || result.files.isEmpty) {
        return;
      }

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

      setState(() {
        _selectedFileName = file.name;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Selected "${file.name}"')));
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

    if (onTap == null) {
      return buttonContent;
    }

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

