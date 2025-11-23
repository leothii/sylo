// lib/screens/summary_page.dart

import 'package:flutter/material.dart';
import 'settings_overlay.dart';
import '../widgets/sylo_chat_overlay.dart';
import '../services/ai_service.dart';
import 'music_page.dart'; // <--- Import MusicPage
import 'notes_page.dart'; // <--- Import NotesPage
import 'profile_page.dart'; // <--- Import ProfilePage
import 'music_page.dart';
import 'notes_page.dart';
import 'profile_page.dart';
import 'home_page.dart';
import '../utils/smooth_page.dart'; // <--- Import SmoothPageRoute

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key, required this.sourceText});

  final String sourceText;

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  AIService? _aiService;
  String? _initError;
  StudySummary? _summary;
  String? _errorMessage;
  bool _isLoading = true;

  // --- Layout Constants ---
  final double _owlHeight = 150;
  final double _cardTopPosition = 130;
  final double _owlVerticalOffset = -115;

  // --- Color Palette ---
  static const Color _colBackgroundBlue = Color(0xFF8AABC7);
  static const Color _colCardCream = Color(0xFFF8EFDC);
  static const Color _colTitleRed = Color(0xFF882124);
  static const Color _colTextGrey = Color(0xFF898989);
  static const Color _colScrollbarRed = Color(0xFF882124);
  static const Color _colIconGrey = Color(0xFF676767);
  static const Color _colNavItem = Color(0xFFE1B964);

  static const TextStyle _titleTextStyle = TextStyle(
    color: _colTitleRed,
    fontSize: 20,
    fontFamily: 'Bungee',
  );

  static const TextStyle _sectionHeadingStyle = TextStyle(
    color: _colTitleRed,
    fontSize: 16,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w700,
  );

  static const TextStyle _bodyTextStyle = TextStyle(
    fontFamily: 'Quicksand',
    fontSize: 14,
    height: 1.5,
    color: _colTextGrey,
    fontWeight: FontWeight.w600,
  );

  @override
  void initState() {
    super.initState();
    try {
      _aiService = AIService();
    } catch (error) {
      _initError = error is StateError ? error.message : '$error';
    }
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    if (_aiService == null) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            _initError ?? 'Gemini is not configured. Add your API key and try again.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _summary = null;
    });

    try {
      final StudySummary summary =
          await _aiService!.generateInsights(widget.sourceText);
      if (!mounted) return;

      setState(() {
        _summary = summary;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      final String message = error is StateError
          ? error.message
          : 'Unable to load summary. Please try again.\n$error';
      setState(() {
        _errorMessage = message;
        _summary = null;
        _isLoading = false;
      });
    }
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
                Navigator.of(context).push(
                  SmoothPageRoute(builder: (_) => const ProfilePage()),
                ); // <--- Smooth
              },
              child: const Icon(Icons.person, color: _colNavItem, size: 32),
            ),

            // 2. Home Icon -> Navigates back to HomePage (Replaced Notes Icon)
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

            // 3. Music Icon -> Navigates to MusicPage
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  SmoothPageRoute(builder: (_) => const MusicPage()),
                ); // <--- Smooth
              },
              child: const Icon(Icons.headphones, color: _colNavItem, size: 32),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // --- 1. THE MAIN CREAM CARD ---
            Positioned(
              top: _cardTopPosition,
              bottom: 20,
              left: 24,
              right: 24,
              child: Container(
                decoration: BoxDecoration(
                  color: _colCardCream,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 1, color: Colors.black12),
                ),
                child: Column(
                  children: [
                    // Header: "SUMMARY" Title + Close Button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 40, 24, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          const Text(
                            'SUMMARY',
                            style: TextStyle(
                              color: _colTitleRed,
                              fontSize: 32,
                              fontFamily: 'Bungee',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.of(context).maybePop(),
                            child: const Icon(
                              Icons.close,
                              color: _colIconGrey,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Scrollable Text Content
                    Expanded(
                      child: _buildSummaryBody(),
                    ),

                    // Bottom Icons
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(
                            Icons.content_paste,
                            color: _colIconGrey,
                            size: 28,
                          ),
                          Icon(Icons.ios_share, color: _colIconGrey, size: 28),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- 2. THE OWL IMAGE ---
            Positioned(
              top: _cardTopPosition + _owlVerticalOffset,
              left: 0,
              child: GestureDetector(
                onTap: () => showSyloChatOverlay(context),
                child: Image.asset(
                  'assets/images/sylo.png',
                  height: _owlHeight,
                  fit: BoxFit.contain,
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

  Widget _buildSummaryBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _colTextGrey,
                fontFamily: 'Quicksand',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadSummary,
              style: ElevatedButton.styleFrom(
                backgroundColor: _colTitleRed,
                foregroundColor: Colors.white,
              ),
              child: const Text('retry'),
            ),
          ],
        ),
      );
    }

    if (_summary == null) {
      return const SizedBox.shrink();
    }

    return _buildSummaryContent(_summary!);
  }

  Widget _buildSummaryContent(StudySummary summary) {
    final List<Widget> children = <Widget>[
      Text(summary.title, style: _titleTextStyle),
      const SizedBox(height: 16),
      Text(summary.overview, style: _bodyTextStyle),
    ];

    void addSection(String heading, List<String> items) {
      if (items.isEmpty) {
        return;
      }
      children.addAll(<Widget>[
        const SizedBox(height: 24),
        Text(heading, style: _sectionHeadingStyle),
        const SizedBox(height: 8),
        _buildBulletList(items),
      ]);
    }

    addSection('Key Points', summary.keyPoints);
    addSection('Study Tips', summary.studyTips);
    addSection('Suggested Follow-up', summary.followUp);

    return RawScrollbar(
      thumbColor: _colScrollbarRed,
      radius: const Radius.circular(4),
      thickness: 6,
      thumbVisibility: true,
      padding: const EdgeInsets.only(right: 8),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        children: children,
      ),
    );
  }

  Widget _buildBulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((String item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('•', style: _bodyTextStyle),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item,
                  style: _bodyTextStyle,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
