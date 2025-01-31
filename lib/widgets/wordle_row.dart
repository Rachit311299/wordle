import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordle/providers/game_state_provider.dart';
import 'package:wordle/widgets/wordle_grid_element.dart';

class WordleRow extends ConsumerWidget {
  final int wordsize;
  final String word;
  final String correctWord;
  final bool attempted;
  final int rowIndex;

  const WordleRow({
    super.key,
    required this.wordsize,
    required this.word,
    required this.attempted,
    required this.correctWord,
    required this.rowIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Color?> colors;
    
    if (attempted) {
      // Use cached colors for submitted rows
      final gameState = ref.watch(gameStateProvider);
      colors = gameState.submittedColors[rowIndex];
    } else {
      // For current row, use null colors
      colors = List.filled(wordsize, null);
    }

    final List<Widget> boxes = List.generate(wordsize, (j) {
      final letter = (word.length > j) ? word[j] : "";
      // Use ValueKey to help Flutter identify which elements can be reused
      return WordleGridElement(
        key: ValueKey('${rowIndex}_$j'),
        pos: j,
        letter: letter,
        attempted: attempted,
        color: colors[j],
      );
    });

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: boxes,
    );
  }
}