import 'package:flutter/material.dart';
// Ensure your AppColors path is correct
import '../utils/app_colors.dart';
// You can remove this import if you don't need to navigate anywhere yet,
// or keep it if you want to navigate to a placeholder.
// For now, let's keep a placeholder navigation for demonstration.
// import 'home_screen.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground, // Matches your Figma color #8AABC7
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Center items horizontally in the column
            children: [
              // --- 1. Version Number (Top Left) ---
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'v1.0.0',
                  style: TextStyle(
                    color: Colors.white, // White text for contrast on background
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
                // Add color or filter if your logo is not already red/brown and needs to match the design
                // color: AppColors.syloLogoRed, // Example if your logo needs coloring
              ),
              const SizedBox(height: 10), // Spacing between logo and owl

              // Mascot: Owl Illustration
              // Ensure your assets/images/sylo_owl.png exists and is declared in pubspec.yaml
              Image.asset(
                'assets/images/sylo.png',
                height: 200, // Adjust size to match Figma visually
              ),
              const SizedBox(height: 40), // Spacing above the button

              // --- 3. Start Button ---
              SizedBox(
                width: 120, // Specific width for the button
                child: ElevatedButton(
                  onPressed: () {
                    // Temporarily navigate to a simple placeholder screen
                    // until HomeScreen is ready or a different flow is decided.
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const PlaceholderScreen(), // Placeholder for now
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF1D79E), // Light brown/beige from Figma
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Rounded corners from Figma
                    ),
                    elevation: 5, // Adds a slight shadow
                  ),
                  child: const Text( // Use const for Text if possible
                    'start',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B0000), // A dark red/brown for the text, matching logo if needed
                    ),
                  ),
                ),
              ),

              // Spacer to push bottom icons down
              const Spacer(flex: 4), // Pushes the bottom icons towards the bottom

              // --- 4. Bottom Icons ---
              const Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the row horizontally
                children: [
                  Icon(Icons.headset, color: Colors.white, size: 30), // Headset for audio
                  SizedBox(width: 40), // Spacing between icons
                  Icon(Icons.lightbulb_outline, color: Colors.white, size: 30), // Lightbulb for ideas/notes
                  SizedBox(width: 40), // Spacing between icons
                  Icon(Icons.assignment, color: Colors.white, size: 30), // Assignment for quizzes/tasks
                ],
              ),
              const SizedBox(height: 20), // Padding from the very bottom of the screen
            ],
          ),
        ),
      ),
    );
  }
}

// A simple placeholder screen to navigate to for now
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Next Screen'),
        backgroundColor: AppColors.primaryBackground,
      ),
      body: const Center(
        child: Text(
          'This is a placeholder for your Home Screen.',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}