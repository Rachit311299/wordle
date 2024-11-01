import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordle/data/wordle_repo.dart';
import 'package:wordle/providers/game_settings_provider.dart';
import 'package:wordle/widgets/custom_toast.dart';



class GameState {
  final GameSettings settings;
  final List<String> validWords;
  final List<String> wordBank;
  final String correctWord;
  final List<String> attempts;
  final int attempted;
  final bool gameOver; // New property to track if the game has ended

  const GameState({
    required this.wordBank,
    required this.validWords,
    required this.correctWord,
    required this.settings,
    required this.attempts,
    required this.attempted,
    this.gameOver = false,
  });

  GameState clone({
    List<String>? validWords,
    String? correctWord,
    List<String>? attempts,
    int? attempted,
    List<String>? wordBank,
    bool? gameOver,
  }) {
    return GameState(
      wordBank: wordBank ?? this.wordBank,
      validWords: validWords ?? this.validWords,
      correctWord: correctWord ?? this.correctWord,
      settings: this.settings,
      attempts: attempts ?? this.attempts,
      attempted: attempted ?? this.attempted,
      gameOver: gameOver ?? this.gameOver,
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

  void updateCurrentAttempt(BuildContext context,String key) {
    // If the game is over, ignore further input
    if (state.gameOver) return;

    final attempts = state.attempts;
    if (attempts.length <= state.attempted) {
      attempts.add("");
    }
    var currentAttempt = attempts[state.attempted];

    if (key == "_") { // Enter Button
      if (currentAttempt.length < state.settings.wordsize) {
        print("Attempt word incomplete");
        return;
      }

      if (!state.wordBank.contains(currentAttempt)) {
        print("Enter Valid Word");
        return;
      }

      

      state = state.clone(
        attempted: state.attempted + 1,
      );

      if (currentAttempt == state.correctWord) {
         // Win condition
            state = state.clone(
              gameOver: true, // Mark game as over
            );
            CustomToast.show(
              context,
              "Great! You've solved",
              backgroundColor: Colors.green,
            );
        return;
      }
      if(state.settings.attempts==state.attempted){
             state = state.clone(
              gameOver: true, // Mark game as over
            );
            CustomToast.show(
                context,
                "Game Over",
                backgroundColor: Colors.red,
            );
            return;
      }

    } else if (key == "+") { // Backspace Button
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
}


final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((ref) {
  final settings = ref.watch(GameSettingsProvider);
  final gameStateNotifier = GameStateNotifier(settings);
  gameStateNotifier.updateWords();
  return gameStateNotifier;
});
