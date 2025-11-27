// lib/screens/summary_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/study_material.dart';
import '../models/attachment_payload.dart';
import '../services/ai_service.dart';
import '../services/gemini_file_service.dart';
import '../services/notes_service.dart';
import '../utils/smooth_page.dart';
import '../widgets/sylo_chat_overlay.dart';
import '../widgets/icon_badge.dart';
import '../widgets/sound_toggle_button.dart';
import '../widgets/attachment_upload_status.dart';
import 'home_page.dart';
import 'music_page.dart';
import 'profile_page.dart';
import 'settings_overlay.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({
    super.key,
    required this.material,
    this.initialPreparedMaterial,
  });

  final StudyMaterial material;
  final PreparedStudyMaterial? initialPreparedMaterial;

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  final AIService _aiService = AIService();
  final NotesService _notesService = NotesService.instance;
  PreparedStudyMaterial? _preparedMaterial;
  bool _isPreparingMaterial = false;

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

  StudySummary? _summary;
  String? _errorMessage;
  bool _isLoading = true;
  bool _isSavingNote = false;

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
    _notesService.ensureLoaded();
    _preparedMaterial = widget.initialPreparedMaterial;
    _loadSummary();
  }

  Future<PreparedStudyMaterial> _ensurePreparedMaterial() async {
    if (_preparedMaterial != null) {
      return _preparedMaterial!;
    }

    if (!widget.material.hasAttachments) {
      final PreparedStudyMaterial prepared = PreparedStudyMaterial(
        text: widget.material.text,
        attachments: const <GeminiFileAttachment>[],
      );
      _preparedMaterial = prepared;
      return prepared;
    }

    setState(() {
      _isPreparingMaterial = true;
    });

    try {
      final List<GeminiFileAttachment> uploadedAttachments =
          await GeminiFileService.instance
              .uploadAll(widget.material.attachments);

      final PreparedStudyMaterial prepared = PreparedStudyMaterial(
        text: widget.material.text,
        attachments: uploadedAttachments,
      );

      _preparedMaterial = prepared;
      return prepared;
    } finally {
      if (mounted) {
        setState(() {
          _isPreparingMaterial = false;
        });
      }
    }
  }

  Future<void> _loadSummary() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _summary = null;
    });

    try {
      final PreparedStudyMaterial prepared = await _ensurePreparedMaterial();
      final StudySummary summary = await _aiService.summarize(prepared);
      if (!mounted) return;
      setState(() {
        _summary = summary;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      final String message = error is StateError
          ? error.message
          : 'Unable to generate a study summary. Please try again.';
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
      bottomNavigationBar: ColoredBox(
        color: _colBackgroundBlue,
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            height: 80,
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
                      child: SizedBox(
                        height: 40,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Center(
                              child: Text(
                                'SUMMARY',
                                style: TextStyle(
                                  color: _colTitleRed,
                                  fontSize: 32,
                                  fontFamily: 'Bungee',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).maybePop(),
                                child: const Icon(
                                  Icons.close,
                                  color: _colIconGrey,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                        children: [
                          GestureDetector(
                            onTap: _isLoading ? null : _copySummaryToClipboard,
                            child: Icon(
                              Icons.content_paste,
                                color: _isLoading || _summary == null
                                  ? _colIconGrey.withValues(alpha: 0.35)
                                  : _colIconGrey,
                              size: 28,
                            ),
                          ),
                          GestureDetector(
                            onTap: (_isLoading || _summary == null || _isSavingNote)
                                ? null
                                : _saveSummaryToNotes,
                            child: _isSavingNote
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      valueColor: AlwaysStoppedAnimation<Color>(_colIconGrey),
                                    ),
                                  )
                                : Icon(
                                    Icons.note_add_outlined,
                                    color: _isLoading || _summary == null
                                      ? _colIconGrey.withValues(alpha: 0.35)
                                        : _colIconGrey,
                                    size: 28,
                                  ),
                          ),
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
              child: IconBadge(
                assetPath: 'assets/icons/settings.png',
                size: 30,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const SettingsOverlay(),
                  );
                },
              ),
            ),

            const Positioned(
              top: 50,
              right: 20,
              child: SoundToggleButton(size: 30),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryBody() {
    if (_isPreparingMaterial) {
      return _buildProgressBody('Uploading attachment...');
    }

    if (_isLoading) {
      return _buildProgressBody('Generating study brief...');
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
              style: _bodyTextStyle,
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

    return RawScrollbar(
      thumbColor: _colScrollbarRed,
      radius: const Radius.circular(4),
      thickness: 6,
      thumbVisibility: true,
      padding: const EdgeInsets.only(right: 8),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        children: _buildSummaryContent(_summary!),
      ),
    );
  }

  Widget _buildProgressBody(String message) {
    final bool showAttachmentProgress =
        _isPreparingMaterial && widget.material.hasAttachments;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showAttachmentProgress) ...[
            AttachmentUploadStatus(
              attachments: widget.material.attachments,
              showProgress: true,
            ),
            const SizedBox(height: 24),
          ],
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: _bodyTextStyle,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSummaryContent(StudySummary summary) {
    final List<Widget> children = <Widget>[
      Text(summary.title, style: _titleTextStyle),
    ];

    if (summary.overview.isNotEmpty) {
      children.addAll(const <Widget>[SizedBox(height: 16)]);
      children.add(const Text('Overview', style: _sectionHeadingStyle));
      children.addAll(const <Widget>[SizedBox(height: 8)]);
      children.add(Text(summary.overview, style: _bodyTextStyle));
    }

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

    addSection('Key Insights', summary.keyInsights);
    addSection('Supporting Details', summary.supportingDetails);
    addSection('Next Steps & Open Questions', summary.nextSteps);

    return children;
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

  Future<void> _copySummaryToClipboard() async {
    final StudySummary? summary = _summary;
    if (summary == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Generate a summary before copying.')),
      );
      return;
    }

    final StringBuffer buffer = StringBuffer()
      ..writeln(summary.title)
      ..writeln();

    if (summary.overview.isNotEmpty) {
      buffer
        ..writeln('Overview')
        ..writeln(summary.overview)
        ..writeln();
    }

    void appendSection(String heading, List<String> items) {
      if (items.isEmpty) {
        return;
      }
      buffer
        ..writeln(heading)
        ..writeAll(items.map((String item) => '- $item'), '\n')
        ..writeln()
        ..writeln();
    }

    appendSection('Key Insights', summary.keyInsights);
    appendSection('Supporting Details', summary.supportingDetails);
    appendSection('Next Steps & Open Questions', summary.nextSteps);

    await Clipboard.setData(ClipboardData(text: buffer.toString().trim()));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Summary copied to clipboard.')),
    );
  }

  Future<void> _saveSummaryToNotes() async {
    final StudySummary? summary = _summary;
    if (summary == null || _isSavingNote) {
      return;
    }

    setState(() => _isSavingNote = true);

    try {
      final StringBuffer buffer = StringBuffer()
        ..writeln('Overview')
        ..writeln(summary.overview)
        ..writeln();

      void appendSection(String heading, List<String> items) {
        if (items.isEmpty) {
          return;
        }
        buffer
          ..writeln(heading)
          ..writeAll(items.map((String item) => '- $item'), '\n')
          ..writeln()
          ..writeln();
      }

      appendSection('Key Insights', summary.keyInsights);
      appendSection('Supporting Details', summary.supportingDetails);
      appendSection('Next Steps & Open Questions', summary.nextSteps);

      await _notesService.addNote(
        title: summary.title,
        body: buffer.toString().trim(),
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Summary saved to notes.')),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to save summary: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSavingNote = false);
      }
    }
  }
}
