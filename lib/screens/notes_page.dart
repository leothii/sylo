// lib/screens/notes_page.dart

import 'package:flutter/material.dart';
// Make sure to import your SettingsOverlay file here.
// Adjust the path based on where you saved the overlay code.
import 'settings_overlay.dart';

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

  // --- Data ---
  final List<_NoteItem> _notes = [
    _NoteItem(
      title: 'Lorem Ipsum',
      description:
          'Lorem ipsum dolor sit amet. Est laborum voluptatem quo laudantium nisi et suscipit animi et laudantium amet eum omnis tenetur ut animi quia? Est recusandae',
    ),
    _NoteItem(
      title: 'Lorem Ipsum',
      description:
          'Lorem ipsum dolor sit amet. Est laborum voluptatem quo laudantium nisi et suscipit animi et laudantium amet eum omnis tenetur ut animi quia? Est recusandae',
    ),
    _NoteItem(
      title: 'Lorem Ipsum',
      description:
          'Lorem ipsum dolor sit amet. Est laborum voluptatem quo laudantium nisi et suscipit animi et laudantium amet eum omnis tenetur ut animi quia? Est recusandae',
    ),
    _NoteItem(
      title: 'Lorem Ipsum',
      description:
          'Lorem ipsum dolor sit amet. Est laborum voluptatem quo laudantium nisi et suscipit animi et laudantium amet eum omnis tenetur ut animi quia? Est recusandae',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colBackgroundBlue,
      // Bottom Navigation Bar placeholder
      bottomNavigationBar: Container(
        height: 80,
        color: _colBackgroundBlue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Icon(Icons.person, color: Color(0xFFE1B964), size: 32),
            Icon(Icons.menu_book, color: Color(0xFFE1B964), size: 32),
            Icon(Icons.headphones, color: Color(0xFFE1B964), size: 32),
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
                    // Header: "MY NOTES" Title + Close Button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 50, 24, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          const Text(
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
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.of(context).maybePop(),
                            child: const Icon(
                              Icons.close,
                              color: _colIconGrey,
                              size: 28,
                            ),
                            onPressed: () => Navigator.of(context).maybePop(),
                          ),
                        ],
                      ),
                    ),

                    // Scrollable List of Notes
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        itemCount: _notes.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          return _buildNoteItem(_notes[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- 2. THE OWL IMAGE (Centered) ---
            Positioned(
              top: _cardTopPosition + _owlVerticalOffset,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/images/sylo.png',
                  height: _owlHeight,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // --- 3. FLOATING ICONS (Top Right) ---

            // SETTINGS ICON (Updated with GestureDetector)
            Positioned(
              top: 10,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  // Opens the Settings Overlay
                  showDialog(
                    context: context,
                    builder: (context) => const SettingsOverlay(),
                  );
                },
                child: const Icon(
                  Icons.settings,
                  color: _colItemGold,
                  size: 30,
                ),
              ),
            ),

            // VOLUME ICON
            Positioned(
              top: 50,
              right: 20,
              child: const Icon(Icons.volume_up, color: _colItemGold, size: 30),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build individual note cards
  Widget _buildNoteItem(_NoteItem note) {
    return Container(
      decoration: BoxDecoration(
        color: _colItemGold,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Trash Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                note.title,
                style: const TextStyle(
                  color: _colTextWhite,
                  fontSize: 14,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Icon(Icons.delete_outline, color: _colIconGrey, size: 20),
            ],
          ),
          const SizedBox(height: 4),
          // Divider Line
          const Divider(color: _colIconGrey, thickness: 1, height: 8),
          const SizedBox(height: 4),
          // Description
          Text(
            note.description,
            style: const TextStyle(
              color: _colTextGrey,
              fontSize: 10,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

// Data Model Class
class _NoteItem {
  const _NoteItem({required this.title, required this.description});

  final String title;
  final String description;
}
