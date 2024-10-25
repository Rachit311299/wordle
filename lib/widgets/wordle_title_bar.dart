import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordle/providers/game_settings_provider.dart';


class WordleTitleBar extends StatelessWidget {
  const WordleTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child:const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        
        children: [
          
         WordAttemptToggle(),


          Text("WORDLE",
          style:TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,

            ),
          ),
          
        WordSizeToggle()
        ],
      ),
    );
  }
}

class WordSizeToggle extends ConsumerWidget{
  const WordSizeToggle({
    Key? Key,
  }) :super();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final gameSettings = ref.watch(GameSettingsProvider);
    final gameSettingsNotifier = ref.watch(GameSettingsProvider.notifier);

    void _updateWordSize(){
      var newWordSize=5;
      if(gameSettings.wordsize==4) newWordSize=5;
      if(gameSettings.wordsize==5) newWordSize=6;
      if(gameSettings.wordsize==6) newWordSize=4;
      gameSettingsNotifier.UpdateWordsize(newWordSize);
    }

    return Container(
            child: OutlinedButton(
              child: Text(gameSettings.wordsize.toString()),
              onPressed: _updateWordSize,),
            margin:const EdgeInsets.fromLTRB(40, 0, 0 , 0),
          );
  }
}

class WordAttemptToggle extends ConsumerWidget{
  const WordAttemptToggle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final gameSettings = ref.watch(GameSettingsProvider);
    final gameSettingsNotifier = ref.watch(GameSettingsProvider.notifier);

    void _updateAttempts(){
      var newAttempts=6;
      if(gameSettings.attempts==4) newAttempts=5;
      if(gameSettings.attempts==5) newAttempts=6;
      if(gameSettings.attempts==6) newAttempts=4;
      gameSettingsNotifier.UpdateAttempts(newAttempts);
    }
    String difftext;
    switch(gameSettings.attempts){
      case 4: difftext ="HIGH";break;
      case 5: difftext ="MED";break;
      case 6: default: difftext ="LOW";break;
    }


    return Container(
      child: OutlinedButton(
        child: Text(difftext),
        onPressed: _updateAttempts,
      ),
      margin: const EdgeInsets.fromLTRB(0, 0, 30, 0),
    );
  }
}