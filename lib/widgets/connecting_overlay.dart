import 'package:flutter/material.dart';

class ConnectOverlay extends StatelessWidget {
  const ConnectOverlay({super.key});

  // --- Colors based on your design ---
  static const Color _colBackground = Color(0xFFF7DB9F); // Gold/Cream
  static const Color _colTextGrey = Color(
    0xFF7A8A8C,
  ); // Muted Green/Grey from screenshot
  static const Color _colLinkRed = Color(
    0xFF8B3A3A,
  ); // Red/Brown for "click here"

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: Container(
          width: 208,
          height: 166,
          decoration: ShapeDecoration(
            color: _colBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
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
          child: Stack(
            children: [
              // --- 1. Close Button (Top Right) ---
              Positioned(
                right: 8,
                top: 8,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, size: 18, color: _colTextGrey),
                ),
              ),

              // --- 2. Main Content ---
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Header: Icon + "connect to spotify"
                    Row(
                      children: [
                        // Spotify-ish Icon (Circle with waves)
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: _colTextGrey, width: 1.5),
                          ),
                          child: const Icon(
                            Icons
                                .wifi, // Approximation of the signal icon in your image
                            size: 16,
                            color: _colTextGrey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'connect to spotify',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _colTextGrey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    // Center Text: "redirecting...."
                    const Text(
                      'redirecting....',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: _colTextGrey,
                      ),
                    ),

                    // Bottom Text: "If you're not redirected..."
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 10,
                          color: Color(
                            0xFF333333,
                          ), // Darker grey for legibility
                        ),
                        children: [
                          TextSpan(text: "If you're not redirected, "),
                          TextSpan(
                            text: "click here.",
                            style: TextStyle(
                              color: _colLinkRed,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            // You can add a recognizer here for the link tap if needed
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
