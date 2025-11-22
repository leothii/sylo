// lib/screens/signup_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'login_page.dart';
import 'settings_overlay.dart';

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
            Positioned(
              right: 18,
              top: 28,
              child: IconButton(
                icon: Image.asset('assets/icons/settings.png', height: 36, width: 36),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const SettingsOverlay(),
                  );
                },
              ),
            ),
            Positioned(
              right: 18,
              top: 92,
              child: Image.asset('assets/icons/sound.png', height: 36, width: 36),
            ),
            Positioned(
              top: 170,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'SY',
                          style: TextStyle(
                            color: const Color(0xFF882124),
                            fontSize: 48,
                            fontFamily: 'Bungee',
                            fontWeight: FontWeight.w400,
                            shadows: [
                              Shadow(
                                offset: const Offset(0, 4),
                                blurRadius: 6,
                                color: const Color(0xFF000000).withValues(alpha: 0.25),
                              ),
                            ],
                          ),
                        ),
                        TextSpan(
                          text: 'LO',
                          style: TextStyle(
                            color: const Color(0xFFF1F1F1),
                            fontSize: 48,
                            fontFamily: 'Bungee',
                            fontWeight: FontWeight.w400,
                            shadows: [
                              Shadow(
                                offset: const Offset(0, 4),
                                blurRadius: 6,
                                color: const Color(0xFF000000).withValues(alpha: 0.25),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Please enter your:',
                    style: const TextStyle(
                      color: Color(0xFFF7DB9F),
                      fontSize: 22,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 200,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/sylo.png',
                  height: 260,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 430,
              child: Column(
                children: [
                  _buildInputField(controller: _nameController, hint: 'name'),
                  const SizedBox(height: 16),
                  _buildInputField(controller: _emailController, hint: 'email'),
                  const SizedBox(height: 16),
                  _buildInputField(
                    controller: _passwordController,
                    hint: 'password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    controller: _confirmPasswordController,
                    hint: 'confirm password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 28),
                  _buildPrimaryButton(
                    label: 'sign up',
                    onTap: _handleSignUp,
                    isLoading: _isSubmitting,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'or',
                    style: TextStyle(
                      color: Color(0xFFF1F1F1),
                      fontSize: 16,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFF1F1F1),
                      textStyle: const TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    child: const Text('back to login'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFFB1B1B1),
              fontSize: 16,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w600,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
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

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 76),
      child: SizedBox(
        height: 48,
        child: ElevatedButton(
          onPressed: isLoading ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF6DA9F),
            shadowColor: const Color(0x3F000000),
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF882124)),
                  ),
                )
              : Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF882124),
                    fontSize: 22,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}

