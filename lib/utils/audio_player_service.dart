// lib/utils/audio_player_service.dart

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioPlayerService {
  AudioPlayerService._();

  static final AudioPlayerService instance = AudioPlayerService._();

  static const String _pathKey = 'last_audio_path';
  static const String _nameKey = 'last_audio_name';

  final AudioPlayer player = AudioPlayer();

  final ValueNotifier<String?> fileName = ValueNotifier<String?>(null);

  String? _filePath;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    _initialized = true;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? storedPath = prefs.getString(_pathKey);
    final String? storedName = prefs.getString(_nameKey);

    if (storedPath == null) {
      return;
    }

    final File storedFile = File(storedPath);
    final bool exists = await storedFile.exists();
    if (!exists) {
      await _clearStoredSelection(prefs);
      return;
    }

    try {
      await player.setFilePath(storedPath);
      _filePath = storedPath;
      fileName.value = storedName ?? storedFile.uri.pathSegments.last;
    } catch (_) {
      await _clearStoredSelection(prefs);
    }
  }

  Future<void> loadFile({
    required String path,
    required String displayName,
    bool autoPlay = true,
  }) async {
    await player.stop();
    await player.setFilePath(path);

    _filePath = path;
    fileName.value = displayName;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pathKey, path);
    await prefs.setString(_nameKey, displayName);

    if (autoPlay) {
      await player.play();
    }
  }

  Future<void> clearSelection() async {
    _filePath = null;
    fileName.value = null;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await _clearStoredSelection(prefs);
  }

  String? get filePath => _filePath;

  Future<void> _clearStoredSelection(SharedPreferences prefs) async {
    await prefs.remove(_pathKey);
    await prefs.remove(_nameKey);
  }
}
