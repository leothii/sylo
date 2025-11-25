// lib/screens/login_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'settings_overlay.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isSubmitting = false;
  bool _isSendingReset = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8AABC7),
      body: SafeArea(
        child: Stack(
          children: [
            // --- TOP ICONS (Unchanged) ---
            Positioned(
              right: 18,
              top: 28,
              child: IconButton(
                icon: Image.asset(
                  'assets/icons/settings.png',
                  height: 36,
                  width: 36,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const SettingsOverlay();
                    },
                  );
                },
              ),
            ),
            Positioned(
              right: 18,
              top: 92,
              child: Image.asset(
                'assets/icons/sound.png',
                height: 36,
                width: 36,
              ),
            ),
            // --- LOGO / OWL (Unchanged) ---
            Positioned(
              left: 0,
              right: 0,
              top: 215,
              child: Center(
                child: Text.rich(
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
                              color: const Color(0xFF000000).withValues(alpha: 0.25),
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
                              color: const Color(0xFF000000).withValues(alpha: 0.25),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 100,
              top: 259,
              child: Text(
                '"',
                style: TextStyle(
                  color: const Color(0xFFF7DB9F),
                  fontSize: 96,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Positioned(
              left: 92,
              top: 229,
              child: SizedBox(
                width: 273,
                height: 273,
                child: Image.asset(
                  'assets/images/sylo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              left: 92,
              top: 323.62,
              child: Text(
                'Please \nenter\nyour:',
                style: TextStyle(
                  color: const Color(0xFFF7DB9F),
                  fontSize: 22,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
                textAlign: TextAlign.left,
              ),
            ),

            // --- NAME FIELD (Unchanged) ---
            Positioned(
              left: 108,
              top: 443,
              child: Container(
                width: 163,
                height: 33,
                decoration: ShapeDecoration(
                  color: const Color(0xFFF1F1F1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'email',
                    hintStyle: const TextStyle(
                      color: Color(0xFFB1B1B1),
                      fontSize: 16,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w600,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
            ),

            // --- PASSWORD FIELD (Unchanged) ---
            Positioned(
              left: 108,
              top: 502,
              child: Container(
                width: 163,
                height: 33,
                decoration: ShapeDecoration(
                  color: const Color(0xFFF1F1F1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'password',
                    hintStyle: const TextStyle(
                      color: Color(0xFFB1B1B1),
                      fontSize: 16,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // --- *** MODIFIED: FORGOT PASSWORD TEXT *** ---
            Positioned(
              left: 108,
              top: 535,
              width: 163,
              child: Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _isSendingReset ? null : _handleForgotPassword,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(50, 20),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    _isSendingReset ? 'sending...' : 'forgot password',
                    style: const TextStyle(
                      color: Color(0xFFF1F1F1),
                      fontFamily: 'Quicksand',
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFFF1F1F1),
                    ),
                  ),
                ),
              ),
            ),

            // --- CONTINUE BUTTON (Unchanged) ---
            Positioned(
              left: 126,
              top: 584,
              child: Container(
                width: 116.85,
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
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _isSubmitting ? null : _handleLogin,
                    borderRadius: BorderRadius.circular(10),
                    child: Center(
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF882124)),
                              ),
                            )
                          : const Text(
                              'continue',
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

            // --- "OR" TEXT (Unchanged) ---
            Positioned(
              top: 630,
              left: 126,
              width: 116.85,
              child: const Center(
                child: Text(
                  'OR',
                  style: TextStyle(
                    color: Color(0xFFF1F1F1),
                    fontSize: 16,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // --- "SIGN UP" BUTTON (Unchanged) ---
            Positioned(
              left: 126,
              top: 658,
              child: Container(
                width: 116.85,
                height: 38,
                decoration: ShapeDecoration(
                  color: const Color(0xFF31a446),
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
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _isSubmitting
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const SignUpPage()),
                            );
                          },
                    borderRadius: BorderRadius.circular(10),
                    child: const Center(
                      child: Text(
                        'sign up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please enter both email and password.');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } on FirebaseAuthException catch (error) {
      _showMessage(_mapAuthError(error));
    } catch (_) {
      _showMessage('Failed to sign in. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _handleForgotPassword() async {
    FocusScope.of(context).unfocus();

    final String email = _emailController.text.trim();
    if (email.isEmpty) {
      _showMessage('Enter your email address to reset your password.');
      return;
    }

    setState(() => _isSendingReset = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showMessage('Password reset link sent to $email. Check your inbox.');
    } on FirebaseAuthException catch (error) {
      _showMessage(_mapResetError(error));
    } catch (_) {
      _showMessage('Unable to send password reset email. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isSendingReset = false);
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _mapAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled. Contact support.';
      case 'user-not-found':
        return 'No user found for that email. Try signing up.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait and try again.';
      default:
        return error.message ?? 'Unable to sign in. Please try again.';
    }
  }

  String _mapResetError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-not-found':
        return 'No user found for that email. Try signing up.';
      case 'missing-android-pkg-name':
      case 'missing-continue-uri':
      case 'missing-ios-bundle-id':
      case 'invalid-continue-uri':
      case 'unauthorized-continue-uri':
        return 'Password reset is not available for this app configuration.';
      default:
        return error.message ?? 'Unable to send password reset email.';
    }
  }
}
