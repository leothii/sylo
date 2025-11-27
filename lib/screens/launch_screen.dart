import 'package:flutter/material.dart';
import 'login_page.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

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
                            color: const Color(0xFF000000)
                                .withValues(alpha: 0.25),
                          )
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
                            color: const Color(0xFF000000)
                                .withValues(alpha: 0.25),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 0),

              // Owl with Start Button Stack
              SizedBox(
                height: 273,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
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
                            )
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            ),
                            borderRadius: BorderRadius.circular(10),
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
                      ),
                    ),
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
                  Icon(
                    Icons.headset,
                    color: Color(0xFFF1F1F1),
                    size: 30,
                  ),
                  SizedBox(width: 40),
                  Icon(
                    Icons.lightbulb_outline,
                    color: Color(0xFFF1F1F1),
                    size: 30,
                  ),
                  SizedBox(width: 40),
                  Icon(
                    Icons.assignment,
                    color: Color(0xFFF1F1F1),
                    size: 30,
                  ),
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