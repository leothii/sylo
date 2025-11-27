import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedNote {
  const SavedNote({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;

  factory SavedNote.create({required String title, required String body}) {
    final DateTime now = DateTime.now().toUtc();
    return SavedNote(
      id: now.microsecondsSinceEpoch.toString(),
      title: title.trim().isEmpty ? 'Untitled Note' : title.trim(),
      body: body.trim(),
      createdAt: now,
    );
  }

  SavedNote copyWith({String? title, String? body}) {
    return SavedNote(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SavedNote.fromJson(Map<String, dynamic> json) {
    return SavedNote(
      id: (json['id'] as String?) ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: (json['title'] as String?)?.trim() ?? 'Untitled Note',
      body: (json['body'] as String?)?.trim() ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now().toUtc(),
    );
  }
}

class NotesService {
  NotesService._();

  static final NotesService instance = NotesService._();
  static const String _prefsKey = 'notes.saved.v1';

  final ValueNotifier<List<SavedNote>> notes = ValueNotifier<List<SavedNote>>(<SavedNote>[]);

  bool _loaded = false;

  Future<void> ensureLoaded() async {
    if (_loaded) {
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_prefsKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final dynamic decoded = jsonDecode(raw);
        if (decoded is List) {
          final List<SavedNote> loaded = decoded
              .whereType<Map<String, dynamic>>()
              .map(SavedNote.fromJson)
              .toList();
          notes.value = loaded;
        }
      } catch (_) {
        await prefs.remove(_prefsKey);
      }
    }

    _loaded = true;
  }

  Future<void> addNote({required String title, required String body}) async {
    await ensureLoaded();
    final SavedNote note = SavedNote.create(title: title, body: body);
    final List<SavedNote> updated = <SavedNote>[note, ...notes.value];
    await _persist(updated);
  }

  Future<void> deleteNote(String id) async {
    await ensureLoaded();
    final List<SavedNote> updated = notes.value.where((SavedNote note) => note.id != id).toList();
    await _persist(updated);
  }

  Future<void> _persist(List<SavedNote> items) async {
    notes.value = List<SavedNote>.from(items);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String payload = jsonEncode(items.map((SavedNote note) => note.toJson()).toList());
    await prefs.setString(_prefsKey, payload);
  }
}
