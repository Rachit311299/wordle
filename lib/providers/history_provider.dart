import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _historyPrefsKey = 'game_history_v1';
const int _historyMaxEntries = 200; // keep memory/storage light

class GameResult {
  final DateTime playedAt;
  final int wordSize;
  final int attemptsAllowed;
  final int attemptsUsed;
  final bool won;
  final String correctWord;
  final List<String> guesses;
  final int durationMs;

  const GameResult({
    required this.playedAt,
    required this.wordSize,
    required this.attemptsAllowed,
    required this.attemptsUsed,
    required this.won,
    required this.correctWord,
    required this.guesses,
    required this.durationMs,
  });

  Map<String, dynamic> toJson() => {
        'playedAt': playedAt.toIso8601String(),
        'wordSize': wordSize,
        'attemptsAllowed': attemptsAllowed,
        'attemptsUsed': attemptsUsed,
        'won': won,
        'correctWord': correctWord,
        'guesses': guesses,
        'durationMs': durationMs,
      };

  factory GameResult.fromJson(Map<String, dynamic> json) => GameResult(
        playedAt: DateTime.parse(json['playedAt'] as String),
        wordSize: json['wordSize'] as int,
        attemptsAllowed: json['attemptsAllowed'] as int,
        attemptsUsed: json['attemptsUsed'] as int,
        won: json['won'] as bool,
        correctWord: json['correctWord'] as String,
        guesses: (json['guesses'] as List<dynamic>).cast<String>(),
        durationMs: json['durationMs'] as int,
      );
}

class HistoryNotifier extends StateNotifier<List<GameResult>> {
  HistoryNotifier() : super(const []) {
    _load();
  }

  DateTime? _currentGameStart;

  void markGameStart() {
    _currentGameStart = DateTime.now();
  }

  Future<void> addResult({
    required int wordSize,
    required int attemptsAllowed,
    required int attemptsUsed,
    required bool won,
    required String correctWord,
    required List<String> guesses,
  }) async {
    final int durationMs = _currentGameStart == null
        ? 0
        : DateTime.now().difference(_currentGameStart!).inMilliseconds;

    final result = GameResult(
      playedAt: DateTime.now(),
      wordSize: wordSize,
      attemptsAllowed: attemptsAllowed,
      attemptsUsed: attemptsUsed,
      won: won,
      correctWord: correctWord,
      guesses: List<String>.from(guesses),
      durationMs: durationMs,
    );

    final List<GameResult> next = [result, ...state];
    // Cap the list to keep it light
    final trimmed = next.length > _historyMaxEntries
        ? next.sublist(0, _historyMaxEntries)
        : next;

    state = trimmed;
    await _persist();
  }

  Future<void> clear() async {
    state = const [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyPrefsKey);
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_historyPrefsKey);
      if (raw == null) return;
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      state = list
          .map((e) => GameResult.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
    } catch (e) {
      debugPrint('Failed to load history: $e');
    }
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(state.map((e) => e.toJson()).toList());
      await prefs.setString(_historyPrefsKey, encoded);
    } catch (e) {
      debugPrint('Failed to persist history: $e');
    }
  }
}

final historyProvider =
    StateNotifierProvider<HistoryNotifier, List<GameResult>>((ref) {
  return HistoryNotifier();
});


