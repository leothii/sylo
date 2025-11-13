// lib/screens/notes_page.dart

import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../widgets/audio_card.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
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
  ];

  final double _cardTopMargin = 72;
  final double _cardHorizontalPadding = 30;
  final double _cardVerticalPaddingTop = 64;
  final double _cardVerticalPaddingBottom = 36;
  final double _titleSpacingBelow = 24;
  final double _titleLetterSpacing = 3.5;

  final ScrollController _notesScrollController = ScrollController();

  @override
  void dispose() {
    _notesScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTopBar(),
              const SizedBox(height: 24),
              _buildNotesCard(context),
              const SizedBox(height: 32),
              const AudioCard(playIconVerticalOffset: -10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _TopBarIconColumn(
          topAsset: 'assets/icons/profile.png',
          bottomAsset: 'assets/icons/note.png',
        ),
        Spacer(),
        _TopBarIconColumn(
          topAsset: 'assets/icons/settings.png',
          bottomAsset: 'assets/icons/sound.png',
        ),
      ],
    );
  }

  Widget _buildNotesCard(BuildContext context) {
    return Expanded(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: _cardTopMargin),
              padding: EdgeInsets.symmetric(
                horizontal: _cardHorizontalPadding,
                vertical: 0,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF1DF),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: const Color(0xFF2E2922), width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 22,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: _cardVerticalPaddingTop,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Center(
                          child: Text(
                            'MY NOTES',
                            style: TextStyle(
                              color: const Color(0xFF8F1D1D),
                              fontFamily: 'Bungee',
                              fontSize: 34,
                              letterSpacing: _titleLetterSpacing,
                              shadows: const [
                                Shadow(
                                  color: Color(0x338F1D1D),
                                  offset: Offset(0, 4),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Color(0xFF776E67),
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: _titleSpacingBelow),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: _cardVerticalPaddingBottom,
                      ),
                      child: Scrollbar(
                        controller: _notesScrollController,
                        thumbVisibility: true,
                        thickness: 7,
                        radius: const Radius.circular(12),
                        child: ListView.separated(
                          controller: _notesScrollController,
                          padding: const EdgeInsets.only(bottom: 24),
                          itemCount: _notes.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 20),
                          itemBuilder: (context, index) {
                            final note = _notes[index];
                            return _NoteCard(note: note);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -47,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
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
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.note});

  final _NoteItem note;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE1BA63),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(26, 22, 26, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  note.title,
                  style: const TextStyle(
                    color: Color(0xFFF7F1DE),
                    fontFamily: 'Quicksand',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Image.asset(
                  'assets/icons/delete.png',
                  width: 26,
                  height: 26,
                  color: const Color(0xFFF7F1DE),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F1DE),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            note.description,
            style: const TextStyle(
              color: Color(0xFFF7F1DE),
              fontFamily: 'Quicksand',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBarIconColumn extends StatelessWidget {
  const _TopBarIconColumn({required this.topAsset, required this.bottomAsset});

  final String topAsset;
  final String bottomAsset;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RoundedIcon(asset: topAsset),
        const SizedBox(height: 18),
        _RoundedIcon(asset: bottomAsset),
      ],
    );
  }
}

class _RoundedIcon extends StatelessWidget {
  const _RoundedIcon({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: 48,
      child: Center(child: Image.asset(asset, height: 32, fit: BoxFit.contain)),
    );
  }
}

class _NoteItem {
  const _NoteItem({required this.title, required this.description});

  final String title;
  final String description;
}
