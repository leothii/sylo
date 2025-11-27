import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;

import '../utils/env.dart'; // <--- Back to your original Env class
import '../utils/streak_service.dart';
import '../utils/smooth_page.dart'; // <--- For Smooth Transition
import '../widgets/streak_overlay.dart';

// --- VISUAL CONSTANTS ---
const Offset kDefaultSyloOwlOffset = Offset(-0.2, -0.77);
const Offset kDefaultSyloBrandTextOffset = Offset(0.6, -0.52);
const double kDefaultCardVerticalFactor = 0.70;

// --- 1. Message Model ---
class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

// --- 2. Trigger Function (Using Smooth Dialog) ---
Future<void> showSyloChatOverlay(
  BuildContext context, {
  Offset? owlOffset,
  Offset? brandTextOffset,
  double? cardVerticalFactor,
}) {
  // APPLIED SMOOTH TRANSITION HERE
  return showSmoothDialog(
    context: context,
    builder: (_) => SyloChatOverlay(
      owlOffset: owlOffset,
      brandTextOffset: brandTextOffset,
      cardVerticalFactor: cardVerticalFactor,
    ),
  );
}

// --- 3. Main Chat Widget ---
class SyloChatOverlay extends StatefulWidget {
  const SyloChatOverlay({
    super.key,
    this.owlOffset,
    this.brandTextOffset,
    this.cardVerticalFactor,
  });

  final Offset? owlOffset;
  final Offset? brandTextOffset;
  final double? cardVerticalFactor;

  @override
  State<SyloChatOverlay> createState() => _SyloChatOverlayState();
}

class _SyloChatOverlayState extends State<SyloChatOverlay> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // --- STREAK CHECKER (Using Smooth Dialog) ---
  Future<void> _checkStreak() async {
    final bool streakUpdated = await StreakService.updateStreak();

    if (!streakUpdated) {
      return;
    }

    if (!mounted) {
      return;
    }

    final int newCount = await StreakService.getStreakCount();

    if (!mounted) {
      return;
    }

    final Set<int> activeDays = await StreakService.getActiveWeekdays();

    if (!mounted) {
      return;
    }

    // APPLIED SMOOTH TRANSITION HERE TOO
    await showSmoothDialog(
      context: context,
      builder: (_) =>
          StreakOverlay(currentStreak: newCount, activeWeekdays: activeDays),
    );
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    _textController.clear();

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isTyping = true;
    });
    _scrollToBottom();

    // Trigger Streak Logic
    _checkStreak();

    // --- REVERTED TO ORIGINAL ENV LOGIC ---
    final String apiKey = Env.grokKey;

    if (apiKey.isEmpty) {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(
            ChatMessage(
              text:
                  'GROK_KEY is missing. Restart the app with --dart-define=GROK_KEY=your_grok_key.',
              isUser: false,
            ),
          );
        });
        _scrollToBottom();
      }
      return;
    }

    try {
      // --- OPENROUTER API LOGIC ---
      final response = await http.post(
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
          'HTTP-Referer': 'https://sylo.app',
          'X-Title': 'Sylo Chat',
        },
        body: jsonEncode({
          "model": "x-ai/grok-4.1-fast:free",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are Sylo, a friendly AI owl. Use Markdown (bold, italics, lists) to format your answers nicely.",
            },
            {"role": "user", "content": text},
          ],
          "max_tokens": 400,
          "temperature": 0.7,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String botReply = data['choices'][0]['message']['content'];

        setState(() {
          _messages.add(ChatMessage(text: botReply.trim(), isUser: false));
        });
      } else {
        debugPrint("OpenRouter Error: ${response.body}");
        setState(() {
          _messages.add(
            ChatMessage(
              text: "My feathers are ruffled! (Error: ${response.statusCode})",
              isUser: false,
            ),
          );
        });
      }
    } catch (e) {
      debugPrint("Sylo Exception: $e");
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(text: "I couldn't reach the cloud.", isUser: false),
          );
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isTyping = false);
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double cardWidth = math.min(320, constraints.maxWidth * 0.82);
            final double owlHeight = math.min(220, constraints.maxWidth * 0.6);
            final double layoutWidth = cardWidth + owlHeight * 0.4;
            final double cardTopFactor =
                widget.cardVerticalFactor ?? kDefaultCardVerticalFactor;
            final double cardTop = owlHeight * cardTopFactor;
            final double cardLeft = (layoutWidth - cardWidth) / 2;
            final Offset effectiveOwlOffset =
                widget.owlOffset ?? kDefaultSyloOwlOffset;
            final Offset effectiveBrandTextOffset =
                widget.brandTextOffset ?? kDefaultSyloBrandTextOffset;

            return SizedBox(
              width: layoutWidth,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Main Card
                  Positioned(
                    top: cardTop,
                    left: cardLeft,
                    child: Container(
                      width: cardWidth,
                      height: 450,
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8EFDC),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Close Button
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Color(0xFF776E67),
                              ),
                              splashRadius: 20,
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Chat Area
                          Expanded(
                            child: _messages.isEmpty
                                ? Center(
                                    child: Text(
                                      'start chatting with sylo!',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color(0xFF95A995),
                                        fontSize: 18,
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    controller: _scrollController,
                                    itemCount: _messages.length,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      final msg = _messages[index];
                                      final textColor = msg.isUser
                                          ? Colors.white
                                          : const Color(0xFF555555);

                                      return Align(
                                        alignment: msg.isUser
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          constraints: const BoxConstraints(
                                            maxWidth: 200,
                                          ),
                                          decoration: BoxDecoration(
                                            color: msg.isUser
                                                ? const Color(0xFF882124)
                                                : const Color(0xFFE6D5B8),
                                            borderRadius: BorderRadius.only(
                                              topLeft: const Radius.circular(
                                                12,
                                              ),
                                              topRight: const Radius.circular(
                                                12,
                                              ),
                                              bottomLeft: msg.isUser
                                                  ? const Radius.circular(12)
                                                  : Radius.zero,
                                              bottomRight: msg.isUser
                                                  ? Radius.zero
                                                  : const Radius.circular(12),
                                            ),
                                          ),
                                          // --- REPLACED TEXT WITH MARKDOWN ---
                                          child: MarkdownBody(
                                            data: msg.text,
                                            styleSheet: MarkdownStyleSheet(
                                              p: TextStyle(
                                                color: textColor,
                                                fontFamily: 'Quicksand',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              strong: TextStyle(
                                                color: textColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              em: TextStyle(
                                                color: textColor,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              code: TextStyle(
                                                color: msg.isUser
                                                    ? Colors
                                                          .white // White code on red
                                                    : Colors
                                                          .black87, // Dark code on beige
                                                backgroundColor: msg.isUser
                                                    ? Colors.white24
                                                    : Colors.black12,
                                                fontFamily: 'monospace',
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          // Typing Indicator
                          if (_isTyping)
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 8,
                                bottom: 8,
                                top: 4,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "sylo is thinking...",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 10),
                          // Input Field
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8EFDC),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x66000000),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 6,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _textController,
                                    autofocus: true,
                                    onSubmitted: _handleSubmitted,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'tap to chat...',
                                      hintStyle: TextStyle(
                                        color: Color(0xFF676767),
                                        fontSize: 14,
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Color(0xFF676767),
                                      fontSize: 14,
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Owl Image
                  Positioned(
                    top: cardTop + owlHeight * effectiveOwlOffset.dy,
                    left: cardLeft + owlHeight * effectiveOwlOffset.dx,
                    child: Image.asset(
                      'assets/images/sylo.png',
                      height: owlHeight,
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Brand Text
                  Positioned(
                    top: cardTop + owlHeight * effectiveBrandTextOffset.dy,
                    left: cardLeft + owlHeight * effectiveBrandTextOffset.dx,
                    child: SizedBox(
                      width: math.min(cardWidth * 0.7, 220),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'sy',
                                  style: TextStyle(
                                    color: const Color(0xFF882124),
                                    fontSize: 32,
                                    fontFamily: 'Bungee',
                                    fontWeight: FontWeight.w400,
                                    shadows: [
                                      Shadow(
                                        offset: const Offset(0, 4),
                                        blurRadius: 4,
                                        color: Colors.black
                                            .withValues(alpha: 0.25),
                                      ),
                                    ],
                                  ),
                                ),
                                TextSpan(
                                  text: 'lo',
                                  style: TextStyle(
                                    color: const Color(0xFFF1F1F1),
                                    fontSize: 32,
                                    fontFamily: 'Bungee',
                                    fontWeight: FontWeight.w400,
                                    shadows: [
                                      Shadow(
                                        offset: const Offset(0, 4),
                                        blurRadius: 4,
                                        color: Colors.black
                                            .withValues(alpha: 0.25),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'your AI companion \non the go',
                            style: TextStyle(
                              color: Color(0xFFF8EFDC),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
