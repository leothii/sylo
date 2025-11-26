import 'package:flutter/material.dart';

// --- 1. Smooth Page Route (For Navigator.push) ---
class SmoothPageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;

  SmoothPageRoute({required this.builder})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var curve = Curves.easeInOut;
          var tween = Tween(
            begin: 0.0,
            end: 1.0,
          ).chain(CurveTween(curve: curve));

          return FadeTransition(opacity: animation.drive(tween), child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      );
}

// --- 2. Smooth Dialog Helper (For Popups like StreakOverlay) ---
Future<T?> showSmoothDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true, // Allows clicking outside to close
    barrierLabel: '',
    barrierColor: Colors.black.withOpacity(0.6), // Darken background
    // Match the duration from your SmoothPageRoute
    transitionDuration: const Duration(milliseconds: 400),

    // Build the dialog widget
    pageBuilder: (ctx, anim1, anim2) => builder(ctx),

    // Apply the exact same Fade Transition logic
    transitionBuilder: (ctx, anim1, anim2, child) {
      var curve = Curves.easeInOut;
      var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

      return FadeTransition(opacity: anim1.drive(tween), child: child);
    },
  );
}
