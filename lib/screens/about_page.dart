// lib/screens/about_page.dart

import 'package:flutter/material.dart';
import '../utils/app_colors.dart'; // Make sure this path is correct

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // 🚨🚨🚨 THIS IS THE UPDATED 'ABOUT' TITLE 🚨🚨🚨
              // The old Stack was replaced with this new Text widget
              Text(
                'ABOUT',
                style: TextStyle(
                  color: const Color(0xFFF7DB9F), // Figma: color
                  fontFamily: 'Bungee', // Figma: font-family
                  fontSize: 32, // Figma: font-size
                  fontWeight: FontWeight.w400, // Figma: font-weight
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(
                        0.25,
                      ), // Figma: text-shadow
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),

              // 🚨🚨🚨 END OF UPDATE 🚨🚨🚨
              const SizedBox(height: 30),

              // --- Body Text ---
              const Text(
                'Lorem ipsum dolor sit amet. Est laborum voluptatem quo laudantium nisi et suscipit animi et laudantium amet eum omnis tenetur ut animi quia? Est recusandae obcaecati ab provident numquam eum impedit iusto aut rerum ducimus. Qui dolorum repellat et temporibus laboriosam cum laborum numquam 33 obcaecati itaque qui esse officia et aliquid eius ut voluptates animi. Est culpa ratione in modi voluptatem aut quia impedit et nihil modi et cumque nulla.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.4, // Line spacing
                ),
              ),
              const SizedBox(height: 30),

              // --- Back Button ---
              IconButton(
                icon: Image.asset(
                  'assets/images/backArrow.png', // Your asset
                  height: 40,
                ),
                onPressed: () {
                  // This takes the user back to the previous screen
                  Navigator.of(context).pop();
                },
              ),

              // --- Spacer (to push bottom icons down) ---
              const Spacer(),

              // --- Bottom Icons ---
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.headset, color: Colors.white, size: 30),
                  SizedBox(width: 40),
                  Icon(Icons.lightbulb_outline, color: Colors.white, size: 30),
                  SizedBox(width: 40),
                  Icon(Icons.assignment, color: Colors.white, size: 30),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
