import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordle/data/wordle_repo.dart';
import 'package:wordle/providers/game_settings_provider.dart';


class GameState{
  final GameSettings settings;
  final List<String> validWords;
  final List<String> wordBank;
  final String correctWord;
  final List<String>attempts;
  final int attempted;


  const GameState( 
      {required this.wordBank,
        required this.validWords,
      required this.correctWord,
      required this.settings,
      required this .attempts,
      required this.attempted});

  GameState clone({List<String>? validWords, String? correctWord,List<String>? attempts, int? attempted,  List<String>? wordBank}){
    return GameState(
        wordBank: wordBank ?? this.wordBank,
        validWords: validWords ?? this.validWords,
        correctWord: correctWord ?? this.correctWord,
        settings: this.settings,
        attempts: attempts ?? this.attempts,
        attempted: attempted ?? this.attempted);
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
      validWords: words, // Main word list for valid guesses
      wordBank: vword,   // Source for validation of attempted words
      correctWord: words[rng.nextInt(words.length - 1)],
    );
  }

  void newCorrectWord() {
    state = state.clone(
      correctWord: state.validWords[rng.nextInt(state.validWords.length - 1)],
    );
  }

  void updateCurrentAttempt(String key) {
    final attempts = state.attempts;
    if (attempts.length <= state.attempted) {
      attempts.add("");
    }
    var currentAttempt = attempts[state.attempted];

    if (key == "_") {
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
    } else if (key == "+") {
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
