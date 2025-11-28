import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  //Color Palette

  static const Color _colBackgroundBlue = Color(0xFF8AABC7);
  static const Color _colTitleCream = Color(0xFFF7DB9F);
  static const Color _colOverlay = Color(0x40000000); // Black with ~25% alpha

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colBackgroundBlue,
      body: Stack(
        children: [
          // 1. Overlay
          Container(
            color: _colOverlay,
            width: double.infinity,
            height: double.infinity,
          ),

          // 2. Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),

                  // TITLE: "ABOUT"
                  const Text(
                    'ABOUT',
                    style: TextStyle(
                      color: _colTitleCream,
                      fontSize: 36,
                      fontFamily: 'Bungee',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 4),
                          blurRadius: 4.0,
                          color: Color(0x40000000),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // BODY TEXT
                  const Text(
                    'Lorem ipsum dolor sit amet. Est laborum voluptatem quo laudantium nisi et suscipit animi et laudantium amet eum omnis tenetur ut animi quia? Est recusandae obcaecati ab provident numquam eum impedit iusto aut rerum ducimus. Qui dolorum repellat et temporibus laboriosam cum laborum numquam 33 obcaecati itaque qui esse officia et aliquid eius ut voluptates animi. Est culpa ratione in modi voluptatem aut quia impedit et nihil modi et cumque nulla.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Quicksand',
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const Spacer(flex: 2),

                  // BACK ICON
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: const Icon(
                        Icons.reply,
                        color: _colTitleCream,
                        size: 48,
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
