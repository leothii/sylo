import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // --- Color Palette ---
  // Base background from your other pages
  static const Color _colBackgroundBlue = Color(0xFF8AABC7);
  // The cream/gold color for the Title (matches previous cards/text)
  static const Color _colTitleCream = Color(0xFFF7DB9F);
  // Overlay color from your Figma snippet (Rectangle 12)
  static const Color _colOverlay = Color(0x40000000); // Black with ~25% alpha

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colBackgroundBlue,
      body: Stack(
        children: [
          // 1. Dark Overlay (Rectangle 12 from Figma)
          // This darkens the blue background to match the specific About Page design
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
                      fontFamily: 'Bungee', // Consistent with other headers
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
                  // Transcribed from your image
                  const Text(
                    'Sylo is an innovative educational app designed to revolutionize the way you learn and study. Powered by advanced AI, Sylo helps you create concise summaries from any material, generate interactive quizzes to test your knowledge, and organize personalized notes for better retention.\n\n'
                    'Whether you\'re a student preparing for exams or a lifelong learner, Sylo adapts to your needs, making education engaging, efficient, and enjoyable.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Quicksand', // Consistent with body text
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
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        // Optional: subtle hit-test area or background if needed
                      ),
                      child: const Icon(
                        Icons.reply, // Looks like the curved arrow in design
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
