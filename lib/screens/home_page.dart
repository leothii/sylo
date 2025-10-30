// lib/screens/home_page.dart

import 'package:flutter/material.dart';
import '../utils/app_colors.dart'; // Make sure this path is correct

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    const Color inputFieldColor = Color(0xFFF0F0F0);
    const Color hintColor = Colors.grey;
    const Color inputTextColor = Colors.black;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          // 1. REMOVED the 'Center' widget
          child: Column(
            // 2. REMOVED 'mainAxisAlignment: MainAxisAlignment.center'
            children: [
              // 3. ADDED a Spacer at the top to push the content down
              const Spacer(flex: 2),

              Image.asset(
                'assets/images/logo.png',
                height: 50, // Adjust size to match Figma
              ),
              const SizedBox(height: 10),
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  // --- LAYER 1: The TextField ---
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _nameController,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        hintText: 'name',
                        hintStyle: const TextStyle(
                          color: hintColor,
                          fontSize: 18,
                        ),
                        filled: true,
                        fillColor: inputFieldColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 15,
                        ),
                      ),
                      style: const TextStyle(
                        color: inputTextColor,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  // --- LAYER 2: The Owl (on top) ---
                  IgnorePointer(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 0, left: 100),
                      child: Image.asset('assets/images/sylo.png', height: 230),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- The Dropdown ---
              SizedBox(
                width: 200, // Same width as the TextField
                child: Container(
                  // ... (your dropdown code) ...
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: inputFieldColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedRole,
                      isExpanded: true,
                      hint: const Text(
                        'student',
                        style: TextStyle(color: hintColor, fontSize: 18),
                      ),
                      dropdownColor: inputFieldColor,
                      style: const TextStyle(
                        color: inputTextColor,
                        fontSize: 18,
                      ),
                      icon: const Icon(Icons.arrow_drop_down, color: hintColor),
                      items: ['student', 'teacher', 'professional']
                          .map(
                            (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
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

              // 4. RENAMED your 'flex: 4' Spacer to 'flex: 3'
              // Now the top spacer (2) and this one (3) balance the layout
              const Spacer(
                flex: 3,
              ), // Pushes the bottom icons towards the bottom
              // --- 4. Bottom Icons ---
              const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center the row horizontally
                children: [
                  Icon(
                    Icons.headset,
                    color: Colors.white,
                    size: 30,
                  ), // Headset for audio
                  SizedBox(width: 40), // Spacing between icons
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.white,
                    size: 30,
                  ), // Lightbulb for ideas/notes
                  SizedBox(width: 40), // Spacing between icons
                  Icon(
                    Icons.assignment,
                    color: Colors.white,
                    size: 30,
                  ), // Assignment for quizzes/tasks
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
