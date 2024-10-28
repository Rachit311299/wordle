import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordle/data/wordle_repo.dart';
import 'package:wordle/providers/game_settings_provider.dart';

class GameState{
  final GameSettings settings;
  final List<String> validWords;
  final String correctWord;
  final List<String>attempts;
  final int attempted;


  const GameState(
      {required this.validWords,
      required this.correctWord,
      required this.settings,
      required this .attempts,
      required this.attempted});

  GameState clone({List<String>? validWords, String? correctWord,List<String>? attempts, int? attempted}){
    return GameState(
        validWords: validWords ?? this.validWords,
        correctWord: correctWord ?? this.correctWord,
        settings: this.settings,
        attempts: attempts ?? this.attempts,
        attempted: attempted ?? this.attempted);
  }
}




class GameStateNotifier extends StateNotifier<GameState>{
final Random rng=Random();

  GameStateNotifier(GameSettings settings): super(GameState(
    validWords: [],
    correctWord: "begin",
    settings: settings,
    attempts: [],
    attempted: 0
  ));
    Future<void> updateWords() async {
      final words= await loadWords(state.settings.wordsize);
      state=state.clone(validWords: words,
      correctWord: words[rng.nextInt(words.length -1)] 
      );
      

    }
    void newCorrectWord(){
      state=state.clone(
        correctWord: state.validWords[rng.nextInt(state.validWords.length - 1)]
      );
    }

    void updateCurrentAttempt(String key){
      if(key=="_"){

      }
      else if(key=="+"){

      }
      else{
        final attempts=state.attempts;
        if(attempts.length <=state.attempted){
          attempts.add("");
        }
        var currentAttempt=attempts[state.attempted];
        if(currentAttempt.length>state.settings.wordsize){
          print("bigger tahn size");
          return;
        }
        currentAttempt=currentAttempt += key;
        print(currentAttempt);
        attempts[state.attempted]=currentAttempt;
        state=state.clone(
          attempts: attempts
        );
      }
    }
    
}

final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((ref){

  final settings = ref.watch(GameSettingsProvider);
  final gameStateNotifer= GameStateNotifier(settings);
  gameStateNotifer.updateWords();
  return gameStateNotifer;
});