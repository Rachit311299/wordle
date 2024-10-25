import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameSettings{
   int wordsize=5;
   int attempts=6;

  GameSettings({required this.wordsize,required this.attempts});

  GameSettings clone({int? wordsize,int? attempts}){

    return GameSettings(
      wordsize: wordsize ?? this.wordsize, 
      attempts: attempts ?? this.attempts
      
    );

  }
}

class GameSettingsNotifier extends StateNotifier<GameSettings>{
  GameSettingsNotifier():super(GameSettings(wordsize: 5, attempts: 6));

  void UpdateAttempts(int attempts){
    state=state.clone(attempts: attempts);
  }
  void UpdateWordsize(int wordsize){
    state=state.clone(wordsize: wordsize);
  }

}

final GameSettingsProvider = StateNotifierProvider<
GameSettingsNotifier,
GameSettings>((ref){
  return GameSettingsNotifier();
});