// lib/screens/summary_page.dart

import 'package:flutter/material.dart';
import 'settings_overlay.dart'; // <--- Updated Import

import '../utils/app_colors.dart';
import '../widgets/audio_card.dart';
import '../widgets/sylo_chat_overlay.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  // --- Layout Constants ---
  final double _owlHeight = 150;
  final double _cardTopPosition = 130; // Push card down slightly to fit title
  final double _owlVerticalOffset = -115; // Adjusts owl height relative to card

  // --- Color Palette ---
  static const Color _colBackgroundBlue = Color(0xFF8AABC7);
  static const Color _colCardCream = Color(0xFFF8EFDC); // Main card color
  static const Color _colTitleRed = Color(0xFF882124);
  static const Color _colTextGrey = Color(0xFF898989); // Body text color
  static const Color _colScrollbarRed = Color(0xFF882124); // Scrollbar color
  static const Color _colIconGrey = Color(0xFF676767);

  // --- Data ---
  static const List<_SummaryItem> _items = [
    _SummaryItem(
      title: 'LOREM',
      description:
          'ipsum dolor sit amet. Est laborum voluptatem quo laudantium nisi et suscipit.',
    ),
    _SummaryItem(
      title: 'ANIMA',
      description:
          'et laudantium amet eum omnis tenetur ut animi quia? Est recusandae',
    ),
    _SummaryItem(
      title: 'ABCAECATI',
      description:
          'ab provident numquam eum impedit iusto aut rerum ducimus. Qui dolorum repellat et temporibus',
    ),
    _SummaryItem(
      title: 'LABORUM',
      description:
          'numquam 33 obcaecati itaque qui esse officia et aliquid eius ut voluptates animi',
    ),
    _SummaryItem(
      title: 'CULPA',
      description:
          'ratione in modi voluptatem aut quia impedit et nihil modi et cumque nulla.',
    ),
    _SummaryItem(
      title: 'LABORUM',
      description:
          'numquam 33 obcaecati itaque qui esse officia et aliquid eius ut voluptates animi',
    ),
    _SummaryItem(
      title: 'ABCAECATI',
      description:
          'ab provident numquam eum impedit iusto aut rerum ducimus. Qui dolorum repellat et temporibus',
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
    );
  }

  Widget _buildTopBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TopBarIconColumn(
          topAsset: 'assets/icons/profile.png',
          bottomAsset: 'assets/icons/note.png',
          topContainerSize: _leftTopIconContainerSize,
          topImageSize: _leftTopIconImageSize,
          bottomContainerSize: _leftBottomIconContainerSize,
          bottomImageSize: _leftBottomIconImageSize,
        ),
        const Spacer(),
        _TopBarIconColumn(
          topAsset: 'assets/icons/settings.png',
          bottomAsset: 'assets/icons/sound.png',
          topContainerSize: _rightTopIconContainerSize,
          topImageSize: _rightTopIconImageSize,
          bottomContainerSize: _rightBottomIconContainerSize,
          bottomImageSize: _rightBottomIconImageSize,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Expanded(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: _summaryCardTopMargin),
              padding: EdgeInsets.fromLTRB(
                _summaryCardHorizontalPadding,
                _summaryCardTopPadding,
                _summaryCardHorizontalPadding,
                _summaryCardBottomPadding,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF6EDD7),
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 20,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF7C6C63)),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                  SizedBox(height: _summaryTitleSpacingAbove),
                  Transform.translate(
                    offset: Offset(_summaryTitleOffsetX, _summaryTitleOffsetY),
                    child: Text(
                      'SUMMARY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFAF3E37),
                        fontFamily: 'Bungee',
                        fontSize: 32,
                        shadows: [
                          Shadow(
                            color: const Color(0x338F1D1D),
                            offset: const Offset(0, 4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),

                    // Scrollable Text Content
                    Expanded(
                      child: RawScrollbar(
                        thumbColor: _colScrollbarRed,
                        radius: const Radius.circular(4),
                        thickness: 6,
                        thumbVisibility: true, // Always show scrollbar
                        padding: const EdgeInsets.only(right: 8),
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 10,
                          ),
                          itemCount: _items.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 20),
                          itemBuilder: (context, index) {
                            return _buildSummaryTextItem(_items[index]);
                          },
                        ),
                      ),
                    ),

                    // Bottom Icons (Clipboard & Export)
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

            // --- 2. THE OWL IMAGE (Top Left) ---
            Positioned(
              top: _cardTopPosition + _owlVerticalOffset,
              left: 0, // Aligned to left edge of screen
              child: Image.asset(
                'assets/images/sylo.png',
                height: _owlHeight,
                fit: BoxFit.contain,
          ),
          Positioned(
            top: _owlVerticalOffset,
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

            // --- 3. FLOATING ICONS (Top Right) ---

            // SETTINGS ICON (With Overlay Trigger)
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

            // VOLUME ICON
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

  // Helper to build the Rich Text Paragraphs
  Widget _buildSummaryTextItem(_SummaryItem item) {
    return Text.rich(
      TextSpan(
        style: const TextStyle(
          fontFamily: 'Quicksand',
          fontSize: 14,
          height: 1.4, // Line height for readability
          color: _colTextGrey,
        ),
        children: [
          // Bold Uppercase Title (e.g., "LOREM")
          TextSpan(
            text: '${item.title} - ',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          // Regular Body Text
          TextSpan(
            text: item.description,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// Data Model
class _SummaryItem {
  const _SummaryItem({required this.title, required this.description});
  final String title;
  final String description;
}
