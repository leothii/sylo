import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeBubble extends StatefulWidget {
  final VoidCallback onClose;

  const WelcomeBubble({super.key, required this.onClose});

  @override
  State<WelcomeBubble> createState() => _WelcomeBubbleState();
}

class _WelcomeBubbleState extends State<WelcomeBubble> {
  bool _dontShowAgain = false;
  String _userName = 'Friend';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  void _loadUserName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? name = user.displayName;
      if (name == null || name.isEmpty) {
        name = user.email?.split('@')[0];
      }
      if (name != null && name.isNotEmpty) {
        // Capitalize first letter
        name = name[0].toUpperCase() + name.substring(1);
        if (mounted) {
          setState(() {
            _userName = name!;
          });
        }
      }
    }
  }

  Future<void> _handleClose() async {
    // 1. Save the preference if checked
    if (_dontShowAgain) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hide_welcome_bubble', true);
    }
    // 2. Close the bubble immediately
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: 230, // Slightly wider
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // --- Main Bubble Body ---
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              decoration: BoxDecoration(
                color: const Color(0xFFB1B1B1), // Grey
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 10.0,
                    ), // Space for X button
                    child: Text(
                      'Hi, $_userName!',
                      style: const TextStyle(
                        color: Color(0xFFF6DA9F), // Gold
                        fontSize: 18,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'if you want company just tap me anytime',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // --- Checkbox Row ---
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _dontShowAgain = !_dontShowAgain;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: Checkbox(
                            value: _dontShowAgain,
                            activeColor: const Color(0xFF882124), // Red
                            side: const BorderSide(
                              color: Colors.white,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (val) {
                              setState(() => _dontShowAgain = val ?? false);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "don't show again",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- Decorative Tail ---
            Positioned(
              bottom: -6,
              left: 20,
              child: Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: Color(0xFFB1B1B1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -14,
              left: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFB1B1B1),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // --- FIXED CLOSE BUTTON ---
            // Moved slightly and made the hit area larger
            Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
                onTap: _handleClose,
                behavior: HitTestBehavior.translucent, // Ensures tap is caught
                child: Container(
                  padding: const EdgeInsets.all(8), // Increases clickable area
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(
                      0.1,
                    ), // Slight dim to see button area better
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
