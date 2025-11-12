// lib/screens/home_page.dart

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _progressValue = 0.3;
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTopBar(),
                      const SizedBox(height: 24),
                      _buildWelcomeCard(context),
                      const SizedBox(height: 36),
                      _buildBottomShortcutRow(),
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

  Widget _buildTopBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            _IconBadge(
              assetPath: 'assets/icons/profile.png',
              size: 44,
            ),
            const SizedBox(height: 18),
            _IconBadge(
              assetPath: 'assets/icons/note.png',
              size: 44,
            ),
          ],
        ),
        const Spacer(),
        Column(
          children: [
            _IconBadge(
              assetPath: 'assets/icons/settings.png',
              size: 44,
            ),
            const SizedBox(height: 18),
            _IconBadge(
              assetPath: 'assets/icons/sound.png',
              size: 44,
            ),
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
                    children: const [
                      _ActionButton(
                        label: 'analyze',
                        icon: Icons.lightbulb_outline,
                      ),
                      _ActionButton(
                        label: 'try quiz',
                        icon: Icons.help_outline,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -58,
            left: 0,
            child: Image.asset(
              'assets/images/sylo.png',
              height: 180,
              fit: BoxFit.contain,
            ),
          ),
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

  Widget _buildBottomShortcutRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _ShortcutIcon(icon: Icons.headset),
        SizedBox(width: 32),
        _ShortcutIcon(icon: Icons.lightbulb_outline),
        SizedBox(width: 32),
        _ShortcutIcon(icon: Icons.menu_book_outlined),
      ],
    );
  }

  Widget _buildAudioCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF708DA6),
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProgressSlider(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.ios_share_outlined, color: Colors.white, size: 28),
              SizedBox(width: 16),
              Text(
                'or',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 16),
              Icon(Icons.music_note, color: Colors.white, size: 28),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSlider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 4,
        activeTrackColor: const Color(0xFFF7DB9F),
  inactiveTrackColor: Colors.white.withValues(alpha: 0.6),
        thumbColor: const Color(0xFFF7DB9F),
        overlayColor: const Color(0x33F7DB9F),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Slider(
              value: _progressValue,
              onChanged: (value) {
                setState(() {
                  _progressValue = value;
                });
              },
            ),
          ),
          const SizedBox(width: 16),
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF7DB9F),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Color(0xFF4D4D4D),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openFilePicker() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: [
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
        ],
      );

      if (!mounted || result == null || result.files.isEmpty) {
        return;
      }

      final file = result.files.first;
      const int maxBytes = 10 * 1024 * 1024; // 10 MB

      if (file.size > maxBytes) {
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selected "${file.name}"')),
      );
    } catch (error) {
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
  const _ActionButton({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
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
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.assetPath,
    this.size = 44,
  });

  final String assetPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Center(
        child: Image.asset(
          assetPath,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _ShortcutIcon extends StatelessWidget {
  const _ShortcutIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: const Color(0xFFF7DB9F),
      size: 32,
    );
  }
}


//// ----------------- YOUR SETTINGS OVERLAY (UNCHANGED) -----------------
//
class SettingsOverlay extends StatelessWidget {
  const SettingsOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 217,
            height: 328,
            margin: const EdgeInsets.only(top: 60),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.primaryBackground,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 25.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(height: 5),
                  _buildOverlayButton(
                    context,
                    'home',
                    const Color(0xFFF7DB9F),
                    const Color(0xFF8B0000),
                        () {
                      print('Home button pressed!');
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildOverlayButton(
                    context,
                    'language',
                    const Color(0xFFF7DB9F),
                    const Color(0xFF8B0000),
                        () {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (context) => const LanguageOverlay(),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildOverlayButton(
                    context,
                    'about',
                    const Color(0xFFF7DB9F),
                    const Color(0xFF8B0000),
                        () {
                      print('About button pressed!');
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildOverlayButton(
                    context,
                    'exit',
                    const Color(0xFF882225),
                    Colors.white,
                        () {
                      print('Exit button pressed!');
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -30,
            child: Image.asset(
              'assets/images/sylo.png',
              height: 120,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayButton(
      BuildContext context,
      String text,
      Color backgroundColor,
      Color textColor,
      VoidCallback onPressed,
      ) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.25),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

//
// ----------------- YOUR LANGUAGE OVERLAY (UNCHANGED) -----------------
//
class LanguageOverlay extends StatefulWidget {
  const LanguageOverlay({super.key});

  @override
  State<LanguageOverlay> createState() => _LanguageOverlayState();
}

class _LanguageOverlayState extends State<LanguageOverlay> {
  String _selectedLanguage = 'english';

  static const Color buttonColor = Color(0xFFF7DB9F);
  static const Color saveButtonColor = Color(0xFF882225);
  static const Color buttonTextColor = Color(0xFF8B0000);
  static const Color titleColor = Color(0xFFF7DB9F);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 217,
            height: 328,
            margin: const EdgeInsets.only(top: 60),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.primaryBackground,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'LANGUAGE',
                    style: TextStyle(
                      fontFamily: 'Bungee',
                      fontSize: 24,
                      color: titleColor,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildLanguageButton('english'),
                  const SizedBox(height: 10),
                  _buildLanguageButton('tagalog'),
                  const SizedBox(height: 10),
                  _buildLanguageButton('hiligaynon'),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBottomButton(
                        'cancel',
                        buttonColor,
                        buttonTextColor,
                      ),
                      _buildBottomButton('save', saveButtonColor, Colors.white),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -30,
            child: Image.asset('assets/images/sylo.png', height: 120),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(String text) {
    final bool isSelected = _selectedLanguage == text;

    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedLanguage = text;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: isSelected
                ? const BorderSide(color: Colors.white, width: 3)
                : BorderSide.none,
          ),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.25),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: buttonTextColor,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(String text, Color bgColor, Color textColor) {
    final double fontSize = (text == 'cancel') ? 14 : 16;

    return SizedBox(
      width: 80,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          if (text == 'save') {
            print('Saving language: $_selectedLanguage');
          }
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.25),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          softWrap: false,
        ),
      ),
    );
  }
}
