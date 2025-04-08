import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordle/data/wordle_repo.dart';
import 'package:wordle/providers/game_settings_provider.dart';
import 'package:wordle/theme/theme_data.dart';
import 'package:wordle/widgets/correctword_overlay.dart';
import 'package:wordle/widgets/custom_toast.dart';
import 'package:flutter/services.dart';

class GameState {
  final GameSettings settings;
  final List<String> validWords;
  final List<String> wordBank;
  final String correctWord;
  final List<String> attempts;
  final int attempted;
  final bool gameOver;
  final Map<String, String> keyStates;
  final List<List<Color>> submittedColors;

  const GameState({
    required this.wordBank,
    required this.validWords,
    required this.correctWord,
    required this.settings,
    required this.attempts,
    required this.attempted,
    this.gameOver = false,
    this.keyStates = const {},
    this.submittedColors = const [],
  });

  GameState clone({
    List<String>? validWords,
    String? correctWord,
    List<String>? attempts,
    int? attempted,
    List<String>? wordBank,
    bool? gameOver,
    Map<String, String>? keyStates,
    List<List<Color>>? submittedColors,
  }) {
    return GameState(
      wordBank: wordBank ?? this.wordBank,
      validWords: validWords ?? this.validWords,
      correctWord: correctWord ?? this.correctWord,
      settings: this.settings,
      attempts: attempts ?? this.attempts,
      attempted: attempted ?? this.attempted,
      gameOver: gameOver ?? this.gameOver,
      keyStates: keyStates ?? this.keyStates,
      submittedColors: submittedColors ?? this.submittedColors,
    );
  }
}

class GameStateNotifier extends StateNotifier<GameState> {
  final Random rng = Random();

  GameStateNotifier(GameSettings settings)
      : super(GameState(
          validWords: [],
          correctWord: "begin",
          settings: settings,
          attempts: [],
          attempted: 0,
          wordBank: [],
        ));

  Future<void> updateWords() async {
    final wordData = await loadWords(state.settings.wordsize);

    final words = wordData["data"]!;
    final vword = wordData["vdata"]!;

    state = state.clone(
      validWords: words,
      wordBank: vword,
      correctWord: words[rng.nextInt(words.length - 1)],
    );
  }

  void newCorrectWord() {
    state = state.clone(
      correctWord: state.validWords[rng.nextInt(state.validWords.length - 1)],
    );
  }

  List<Color> calculateRowColors(
      String word, String correctWord, BuildContext context) {
    final int wordsize = state.settings.wordsize;

    // Initialize with theme-aware grey color
    final Color defaultGrey =
        AppTheme.gameColors.getDefaultGrey(Theme.of(context).brightness);

    final List<Color> colors = List.filled(wordsize, defaultGrey);
    final Map<String, int> remainingCounts = {};

    // Count occurrences of each letter in the correct word
    for (var char in correctWord.split('')) {
      remainingCounts[char] = (remainingCounts[char] ?? 0) + 1;
    }

    // Define semantic colors that work well in both themes
    final correctColor = AppTheme.gameColors.correctColor;
    final misplacedColor = AppTheme.gameColors.misplacedColor;

    // Mark green matches and reduce counts
    for (int i = 0; i < word.length; i++) {
      if (word[i] == correctWord[i]) {
        colors[i] = correctColor;
        remainingCounts[word[i]] = remainingCounts[word[i]]! - 1;
      }
    }

    // Mark orange matches for misplaced letters
    for (int i = 0; i < word.length; i++) {
      if (colors[i] == defaultGrey &&
          remainingCounts.containsKey(word[i]) &&
          remainingCounts[word[i]]! > 0) {
        colors[i] = misplacedColor;
        remainingCounts[word[i]] = remainingCounts[word[i]]! - 1;
      }
    }

    return colors;
  }

  Future<void> updateCurrentAttempt(BuildContext context, String key) async {
    if (state.gameOver) return;

    final attempts = state.attempts;
    if (attempts.length <= state.attempted) {
      attempts.add("");
    }
    var currentAttempt = attempts[state.attempted];

    if (key == "_") {
      // Enter Button
      if (currentAttempt.length < state.settings.wordsize) {
        print("Attempt word incomplete");
        return;
      }

      if (!state.wordBank.contains(currentAttempt)) {
        print("Enter Valid Word");
        CustomToast.show(context, "Not a valid word",
            backgroundColor: const Color(0xFF6B5645),
            shake: true,
            duration: Duration(seconds: 1));

        // HapticFeedback.vibrate();
        HapticFeedback.heavyImpact();

        return;
      }

      // Calculate colors for the submitted row
      final colors =
          calculateRowColors(currentAttempt, state.correctWord, context);
      final List<List<Color>> newSubmittedColors =
          List.from(state.submittedColors)..add(colors);

      // Update state in a single clone to ensure atomic update
      state = state.clone(
        attempted: state.attempted + 1,
        submittedColors: newSubmittedColors,
        attempts:
            List.from(attempts), // Ensure attempts list is properly cloned
      );

      _updateKeyStates(currentAttempt);

      if (currentAttempt == state.correctWord) {
        // Win condition
        state = state.clone(
          gameOver: true,
        );

        // ConfettiOverlay.show(context);
        HapticFeedback.heavyImpact();
        CustomToast.show(
          context,
          "Great! You've solved",
          backgroundColor: AppTheme.gameColors.correctColor,
        );
        return;
      }

      if (state.settings.attempts == state.attempted) {
        state = state.clone(
          gameOver: true,
        );
        final overlay = CorrectWordOverlay(
          correctWord: state.correctWord,
        );
        overlay.show(context);

        CustomToast.show(
          context,
          "Game Over",
          backgroundColor: AppTheme.gameColors.incorrectColor,
          shake: true,
        );
        HapticFeedback.heavyImpact();
        return;
      }
    } else if (key == "+") {
      // Backspace Button
      if (currentAttempt.isEmpty) {
        print("Cannot backspace");
        return;
      }
      currentAttempt = currentAttempt.substring(0, currentAttempt.length - 1);
      attempts[state.attempted] = currentAttempt;
      state = state.clone(
        attempts: attempts,
      );
    } else {
      // Regular Letter
      if (currentAttempt.length >= state.settings.wordsize) {
        print("Word is bigger than allowed size");
        return;
      }
      currentAttempt += key;
      print(currentAttempt);
      attempts[state.attempted] = currentAttempt;
      state = state.clone(
        attempts: attempts,
      );
    }
  }

  void _updateKeyStates(String attemptedWord) {
    final keyStates = Map<String, String>.from(state.keyStates);

    for (int i = 0; i < attemptedWord.length; i++) {
      final letter = attemptedWord[i];

      if (state.correctWord[i] == letter) {
        keyStates[letter] = 'green'; // Correct letter, correct position
      } else if (state.correctWord.contains(letter)) {
        // Only mark as orange if not already green
        if (keyStates[letter] != 'green') {
          keyStates[letter] = 'orange'; // Correct letter, wrong position
        }
      } else {
        // Only mark as grey if not already orange or green
        if (keyStates[letter] != 'green' && keyStates[letter] != 'orange') {
          keyStates[letter] = 'grey'; // Letter not in the word
        }
      }
    }

    state = state.clone(
      keyStates: keyStates,
    );
  }
}

final gameStateProvider =
    StateNotifierProvider<GameStateNotifier, GameState>((ref) {
  final settings = ref.watch(GameSettingsProvider);
  final gameStateNotifier = GameStateNotifier(settings);
  gameStateNotifier.updateWords();
  return gameStateNotifier;
});
