import 'package:flutter/material.dart';

import '../services/sound_service.dart';
import 'icon_badge.dart';

class SoundToggleButton extends StatelessWidget {
  const SoundToggleButton({super.key, this.size = 30});

  final double size;

  @override
  Widget build(BuildContext context) {
    final SoundService service = SoundService.instance;

    return ValueListenableBuilder<bool>(
      valueListenable: service.isMuted,
      builder: (context, isMuted, _) {
        return IconBadge(
          assetPath: isMuted ? 'assets/icons/mute.png' : 'assets/icons/sound.png',
          size: size,
          onTap: () {
            service.toggleMute();
          },
        );
      },
    );
  }
}
