// lib/screens/notes_page.dart

import 'package:flutter/material.dart';
import 'settings_overlay.dart';
import '../services/notes_service.dart';
import '../widgets/sylo_chat_overlay.dart';
import '../widgets/icon_badge.dart';
import '../widgets/sound_toggle_button.dart';
import 'profile_page.dart';
import 'music_page.dart';
import 'home_page.dart';
import '../utils/smooth_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // --- Layout Constants ---
  final double _owlHeight = 150;
  final double _cardTopPosition = 130;
  final double _owlVerticalOffset = -115;

  // --- Color Palette ---
  static const Color _colBackgroundBlue = Color(0xFF8AABC7);
  static const Color _colCardCream = Color(0xFFF8EFDC);
  static const Color _colTitleRed = Color(0xFF882124);
  static const Color _colItemGold = Color(0xFFE1B964);
  static const Color _colTextWhite = Color(0xFFF1F1F1);
  static const Color _colTextGrey = Color(0xFF676767);
  static const Color _colIconGrey = Color(0xFF676767);
  static const Color _colNavItem = Color(0xFFE1B964); // Icon color

  final NotesService _notesService = NotesService.instance;
  String? _expandedNoteId;

  @override
  void initState() {
    super.initState();
    _notesService.ensureLoaded();
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

                // 3. Music Icon -> Navigates to MusicPage
                GestureDetector(
                  onTap: () {
                    Navigator.of(
                      context,
                    ).push(SmoothPageRoute(builder: (_) => const MusicPage()));
                  },
                  child: const Icon(
                    Icons.headphones,
                    color: _colNavItem,
                    size: 32,
                  ),
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 50, 24, 10),
                      child: SizedBox(
                        height: 44,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Center(
                              child: Text(
                                'MY NOTES',
                                style: TextStyle(
                                  color: _colTitleRed,
                                  fontSize: 32,
                                  fontFamily: 'Bungee',
                                  fontWeight: FontWeight.w400,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black12,
                                      offset: Offset(2, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
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
                                  size: 28,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: ValueListenableBuilder<List<SavedNote>>(
                        valueListenable: _notesService.notes,
                        builder: (BuildContext context, List<SavedNote> notes, _) {
                          if (notes.isEmpty) {
                            return const Center(
                              child: Text(
                                'Notes you save from summaries will appear here.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _colTextGrey,
                                  fontSize: 14,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }

                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            itemCount: notes.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 16),
                            itemBuilder: (BuildContext context, int index) {
                              final SavedNote note = notes[index];
                              return _buildNoteItem(
                                note,
                                isExpanded: note.id == _expandedNoteId,
                                onTap: () => _handleNoteTap(note.id),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: _cardTopPosition + _owlVerticalOffset,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: () => showSyloChatOverlay(context),
                  child: Image.asset(
                    'assets/images/sylo.png',
                    height: _owlHeight,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

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

  void _handleNoteTap(String noteId) {
    setState(() {
      _expandedNoteId = _expandedNoteId == noteId ? null : noteId;
    });
  }

  Widget _buildNoteItem(
    SavedNote note, {
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: _colItemGold,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    note.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _colTextWhite,
                      fontSize: 14,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _deleteNote(note),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: _colIconGrey,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 18,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Saved on ${_formatTimestamp(note.createdAt)}',
              style: const TextStyle(
                color: _colTextWhite,
                fontSize: 10,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            const Divider(color: _colIconGrey, thickness: 1, height: 8),
            const SizedBox(height: 4),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              firstCurve: Curves.easeInOut,
              secondCurve: Curves.easeInOut,
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: Text(
                note.body,
                style: const TextStyle(
                  color: _colTextGrey,
                  fontSize: 10,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              secondChild: Text(
                note.body,
                style: const TextStyle(
                  color: _colTextGrey,
                  fontSize: 12,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteNote(SavedNote note) async {
    await _notesService.deleteNote(note.id);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Removed "${note.title}" from notes.')),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final DateTime local = timestamp.toLocal();
    String two(int value) => value.toString().padLeft(2, '0');
    return '${local.year}-${two(local.month)}-${two(local.day)} ${two(local.hour)}:${two(local.minute)}';
  }
}
