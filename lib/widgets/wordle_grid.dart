import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordle/providers/game_settings_provider.dart';
import 'package:wordle/providers/game_state_provider.dart';
import 'package:wordle/widgets/wordle_row.dart';

class WordleGrid extends ConsumerWidget {
  const WordleGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final gameSettings = ref.watch(GameSettingsProvider.select((state) => 
      MapEntry(state.wordsize, state.attempts)));
    
    final gameState = ref.watch(gameStateProvider.select((state) => 
      MapEntry(state.attempted, state.attempts)));
    
    final correctWord = ref.watch(gameStateProvider.select((state) => state.correctWord));
    
    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(gameSettings.value, (i) {
          var word = "";
          if (gameState.value.length > i) {
            word = gameState.value[i];
          }
          var attempted = gameState.key > i;

          return WordleRow(
            key: ValueKey('row_${i}_${gameSettings.key}'),
            wordsize: gameSettings.key,
            correctWord: correctWord,
            word: word,
            attempted: attempted,
            rowIndex: i,
          );
        }),
      ),
    );
  }
}