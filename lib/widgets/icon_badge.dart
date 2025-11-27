import 'package:flutter/material.dart';

class IconBadge extends StatelessWidget {
  const IconBadge({
    super.key,
    required this.assetPath,
    this.size = 44,
    this.onTap,
  });

  final String assetPath;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget image = Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );

    if (onTap == null) {
      return SizedBox(
        height: size,
        width: size,
        child: Center(child: image),
      );
    }

    return SizedBox(
      height: size,
      width: size,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Center(child: image),
      ),
    );
  }
}
