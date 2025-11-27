import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Needed for Auth check
import 'login_page.dart';
import 'home_page.dart'; // Needed for navigation

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    // Start the check immediately
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    // 1. Wait 3 seconds for the animation/branding
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      // 2. Check if user is logged in
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // User is logged in -> Go Home (Streak will be preserved!)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // User is NOT logged in -> Go to Login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8AABC7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // Version Number (Top Left)
              const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 9.0),
                  child: Text(
                    'v1.0.0',
                    style: TextStyle(
                      color: Color(0xFFF1F1F1),
                      fontSize: 12,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Spacer to push content to center
              const Spacer(flex: 2),

              // Logo Text "sylo"
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'sy',
                      style: TextStyle(
                        color: const Color(0xFF882124),
                        fontSize: 42,
                        fontFamily: 'Bungee',
                        fontWeight: FontWeight.w400,
                        shadows: [
                          Shadow(
                            offset: const Offset(0, 4),
                            blurRadius: 4,
                            color: const Color(0xFF000000).withOpacity(0.25),
                          ),
                        ],
                      ),
                    ),
                    TextSpan(
                      text: 'lo',
                      style: TextStyle(
                        color: const Color(0xFFF1F1F1),
                        fontSize: 42,
                        fontFamily: 'Bungee',
                        fontWeight: FontWeight.w400,
                        shadows: [
                          Shadow(
                            offset: const Offset(0, 4),
                            blurRadius: 4,
                            color: const Color(0xFF000000).withOpacity(0.25),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 0),

              // Owl with Start Button Stack (Visual Only now, logic handled by Timer)
              SizedBox(
                height: 273,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // START BUTTON (Visual placeholder, since timer auto-navigates)
                    Positioned(
                      bottom: 40,
                      child: Container(
                        width: 98,
                        height: 38,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF6DA9F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'start',
                            style: TextStyle(
                              color: Color(0xFF882124),
                              fontSize: 22,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // OWL IMAGE
                    Positioned(
                      top: -20,
                      left: 0,
                      right: 0,
                      child: IgnorePointer(
                        ignoring: true,
                        child: SizedBox(
                          width: 273,
                          height: 273,
                          child: Image.asset(
                            'assets/images/sylo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Spacer to push bottom icons down
              const Spacer(flex: 3),

              // Bottom Icons
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.headset, color: Color(0xFFF1F1F1), size: 30),
                  SizedBox(width: 40),
                  Icon(
                    Icons.lightbulb_outline,
                    color: Color(0xFFF1F1F1),
                    size: 30,
                  ),
                  SizedBox(width: 40),
                  Icon(Icons.assignment, color: Color(0xFFF1F1F1), size: 30),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
