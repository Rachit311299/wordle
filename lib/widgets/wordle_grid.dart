import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordle/providers/game_settings_provider.dart';
import 'package:wordle/providers/game_state_provider.dart';
import 'package:wordle/widgets/wordle_row.dart';

class WordleGrid extends ConsumerWidget {
  const WordleGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameSettings = ref.watch(GameSettingsProvider);
    final gameState = ref.watch(gameStateProvider);
    print("new words ${gameState.correctWord}");
    final wordSize = gameSettings.wordsize;
    final List<Widget> rows = List.generate(gameSettings.attempts, (i) {
      var word = "";
      if (gameState.attempts.length > i) {
        word = gameState.attempts[i];
      }
      var attempted = gameState.attempted > i;

      return WordleRow(
        key: ValueKey('row_$i'), // Add key for better widget reuse
        wordsize: wordSize,
        correctWord: gameState.correctWord,
        word: word,
        attempted: attempted,
        rowIndex: i,
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: rows,
    );
  }
}