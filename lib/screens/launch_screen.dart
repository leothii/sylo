import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'home_page.dart';
// You can remove this import if you don't need to navigate anywhere yet,
// or keep it if you want to navigate to a placeholder.
// For now, let's keep a placeholder navigation for demonstration.
// import 'home_screen.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.primaryBackground, // Matches your Figma color #8AABC7
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .center, // Center items horizontally in the column
            children: [
              // --- 1. Version Number (Top Left) ---
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'v1.0.0',
                  style: TextStyle(
                    color:
                        Colors.white, // White text for contrast on background
                    fontSize: 14,
                    fontWeight: FontWeight.w400, // Added for clarity
                  ),
                ),
              ),

              // Spacer to push content down from the top
              const Spacer(flex: 3), // Pushes the logo/owl down
              // --- 2. Logo and Mascot (Center) ---
              // Logo/Text: SYLO
              // Ensure your assets/images/sylo_logo.png exists and is declared in pubspec.yaml
              Image.asset(
                'assets/images/logo.png',
                height: 50, // Adjust size to match Figma
              ),
              const SizedBox(height: 10), // Spacing between logo and owl
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF1D79E),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        'start',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B0000),
                        ),
                      ),
                    ),
                  ),
                  IgnorePointer(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Image.asset('assets/images/sylo.png', height: 190),
                    ),
                  ),
                ],
              ),

              // Spacer to push bottom icons down
              const Spacer(
                flex: 4,
              ), // Pushes the bottom icons towards the bottom
              // --- 4. Bottom Icons ---
              const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center the row horizontally
                children: [
                  Icon(
                    Icons.headset,
                    color: Colors.white,
                    size: 30,
                  ), // Headset for audio
                  SizedBox(width: 40), // Spacing between icons
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.white,
                    size: 30,
                  ), // Lightbulb for ideas/notes
                  SizedBox(width: 40), // Spacing between icons
                  Icon(
                    Icons.assignment,
                    color: Colors.white,
                    size: 30,
                  ), // Assignment for quizzes/tasks
                ],
              ),
              const SizedBox(
                height: 20,
              ), // Padding from the very bottom of the screen
            ],
          ),
        ),
      ),
    );
  }
}
