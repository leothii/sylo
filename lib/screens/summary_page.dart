// lib/screens/summary_page.dart

import 'package:flutter/material.dart';
import 'settings_overlay.dart';
import '../widgets/sylo_chat_overlay.dart';
import 'music_page.dart';
import 'notes_page.dart';
import 'profile_page.dart';
import 'home_page.dart';
import '../utils/smooth_page.dart'; // <--- Import SmoothPageRoute

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
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
                      child: RawScrollbar(
                        thumbColor: _colScrollbarRed,
                        radius: const Radius.circular(4),
                        thickness: 6,
                        thumbVisibility: true,
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

  Widget _buildSummaryTextItem(_SummaryItem item) {
    return Text.rich(
      TextSpan(
        style: const TextStyle(
          fontFamily: 'Quicksand',
          fontSize: 14,
          height: 1.4,
          color: _colTextGrey,
        ),
        children: [
          TextSpan(
            text: '${item.title} - ',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(
            text: item.description,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem {
  const _SummaryItem({required this.title, required this.description});
  final String title;
  final String description;
}
