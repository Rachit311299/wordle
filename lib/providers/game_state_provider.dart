import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordle/data/wordle_repo.dart';
import 'package:wordle/providers/game_settings_provider.dart';
import 'package:wordle/widgets/confetti_overlay.dart';
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
  final bool gameOver; // Tracks if the game has ended
  final Map<String, String> keyStates; // Tracks keyboard letter states

  const GameState({
    required this.wordBank,
    required this.validWords,
    required this.correctWord,
    required this.settings,
    required this.attempts,
    required this.attempted,
    this.gameOver = false,
    this.keyStates = const {},
  });

  GameState clone({
    List<String>? validWords,
    String? correctWord,
    List<String>? attempts,
    int? attempted,
    List<String>? wordBank,
    bool? gameOver,
    Map<String, String>? keyStates,
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
        CustomToast.show(
          context,
          "Not a valid word",
          backgroundColor: const Color.fromARGB(255, 110, 110, 110),
        );

        // HapticFeedback.vibrate();
        HapticFeedback.heavyImpact();
       
        return;
      }

      // Update key states after the word is submitted
      _updateKeyStates(currentAttempt);

      state = state.clone(
        attempted: state.attempted + 1,
      );

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
          backgroundColor: Colors.green,
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
          backgroundColor: Colors.red,
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
