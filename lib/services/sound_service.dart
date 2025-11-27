import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/audio_player_service.dart';

class SoundService {
  SoundService._();

  static final SoundService instance = SoundService._();

  static const String _mutedKey = 'app_muted';

  final ValueNotifier<bool> isMuted = ValueNotifier<bool>(false);
  bool _initialized = false;
  Future<void>? _pendingInitialization;

  Future<void> initialize() {
    if (_initialized) {
      return Future.value();
    }
    if (_pendingInitialization != null) {
      return _pendingInitialization!;
    }
    _pendingInitialization = _initializeInternal();
    return _pendingInitialization!;
  }

  Future<void> toggleMute() async {
    await setMuted(!isMuted.value);
  }

  Future<void> setMuted(bool muted) async {
    if (!_initialized) {
      await initialize();
    }
    if (isMuted.value == muted) {
      return;
    }
    isMuted.value = muted;
    await _applyMuteState(persist: true);
  }

  Future<void> _initializeInternal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool storedState = prefs.getBool(_mutedKey) ?? false;
    isMuted.value = storedState;
    await _applyMuteState(persist: false);
    _initialized = true;
  }

  Future<void> _applyMuteState({required bool persist}) async {
    final double volume = isMuted.value ? 0 : 1;
    try {
      await AudioPlayerService.instance.player.setVolume(volume);
    } catch (_) {
      // Ignore errors when the underlying player is not ready yet.
    }

    if (persist) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_mutedKey, isMuted.value);
    }
  }
}
