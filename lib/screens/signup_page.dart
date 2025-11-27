// lib/screens/signup_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8AABC7),
      body: SafeArea(
        child: Stack(
          children: [
            // --- LOGO / OWL ---
            Positioned(
              left: 0,
              right: 0,
              top: 115,
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
              top: 159,
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
              top: 129,
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
              top: 223.62,
              child: Text(
                'Create\nyour\naccount:',
                style: const TextStyle(
                  color: Color(0xFFF7DB9F),
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
                textAlign: TextAlign.left,
              ),
            ),

            _buildPositionedField(
              top: 343,
              controller: _nameController,
              hintText: 'name',
            ),
            _buildPositionedField(
              top: 402,
              controller: _emailController,
              hintText: 'email',
              keyboardType: TextInputType.emailAddress,
            ),
            _buildPositionedField(
              top: 461,
              controller: _passwordController,
              hintText: 'password',
              obscureText: true,
            ),
            _buildPositionedField(
              top: 520,
              controller: _confirmPasswordController,
              hintText: 'confirm password',
              obscureText: true,
            ),

            Positioned(
              left: 126,
              top: 579,
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
                    onTap: _isSubmitting ? null : _handleSignUp,
                    borderRadius: BorderRadius.circular(10),
                    child: Center(
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF882124),
                                ),
                              ),
                            )
                          : const Text(
                              'sign up',
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
              top: 625,
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

            Positioned(
              left: 126,
              top: 653,
              child: Container(
                width: 116.85,
                height: 38,
                decoration: ShapeDecoration(
                  color: const Color(0xFF31A446),
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
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const LoginPage()),
                            );
                          },
                    borderRadius: BorderRadius.circular(10),
                    child: const Center(
                      child: Text(
                        'log in',
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

  Widget _buildPositionedField({
    required double top,
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Positioned(
      left: 108,
      top: top,
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
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
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
    );
  }

  Future<void> _handleSignUp() async {
    FocusScope.of(context).unfocus();

    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showMessage('Please fill in all fields.');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Passwords do not match.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await credential.user?.updateDisplayName(name);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } on FirebaseAuthException catch (error) {
      _showMessage(_mapAuthError(error));
    } catch (_) {
      _showMessage('Failed to sign up. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
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
      case 'email-already-in-use':
        return 'That email is already registered. Try logging in instead.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password should be at least 6 characters long.';
      case 'operation-not-allowed':
        return 'Email sign up is disabled for this project.';
      default:
        return error.message ?? 'Unable to create account. Please try again.';
    }
  }

}

