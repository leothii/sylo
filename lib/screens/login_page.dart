// lib/screens/login_page.dart

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'home_page.dart';
import 'settings_overlay.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _nameController;
  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
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
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'name',
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
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedRole,
                    isExpanded: true,
                    hint: const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'student',
                        style: TextStyle(
                          color: Color(0xFFB1B1B1),
                          fontSize: 16,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    dropdownColor: const Color(0xFFF1F1F1),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600,
                    ),
                    icon: const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFFB1B1B1),
                      ),
                    ),
                    items: ['student', 'teacher', 'professional']
                        .map(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(value),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRole = newValue;
                      });
                    },
                  ),
                ),
              ),
            ),
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
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: const Center(
                      child: Text(
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
          ],
        ),
      ),
    );
  }
}
