import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordle/providers/game_settings_provider.dart';
import 'package:wordle/providers/game_state_provider.dart';
import 'package:wordle/widgets/wordle_row.dart';

class WordleGrid extends ConsumerStatefulWidget {
  const WordleGrid({super.key});

  @override
  ConsumerState<WordleGrid> createState() => _WordleGridState();
}

class _WordleGridState extends ConsumerState<WordleGrid> {
  late List<Widget> rows;
  int? lastAttempted;
  String? lastWord;
  int? lastWordSize;
  int? lastAttemptCount;

  @override
  void initState() {
    super.initState();
    _buildRows();
  }

  void _buildRows() {
    final gameSettings = ref.read(GameSettingsProvider);
    final gameState = ref.read(gameStateProvider);
    print("new words ${gameState.correctWord}");
    
    rows = List.generate(gameSettings.attempts, (i) {
      var word = "";
      if (gameState.attempts.length > i) {
        word = gameState.attempts[i];
      }
      var attempted = gameState.attempted > i;

      return WordleRow(
        key: ValueKey('row_${i}_${gameSettings.wordsize}'),
        wordsize: gameSettings.wordsize,
        correctWord: gameState.correctWord,
        word: word,
        attempted: attempted,
        rowIndex: i,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);
    final gameSettings = ref.watch(GameSettingsProvider);
    
    // Rebuild rows if attempts, current word, or grid size changes
    if (lastAttempted != gameState.attempted || 
        lastWord != (gameState.attempts.isNotEmpty ? gameState.attempts.last : null) ||
        lastWordSize != gameSettings.wordsize ||
        lastAttemptCount != gameSettings.attempts) {
      _buildRows();
      lastAttempted = gameState.attempted;
      lastWord = gameState.attempts.isNotEmpty ? gameState.attempts.last : null;
      lastWordSize = gameSettings.wordsize;
      lastAttemptCount = gameSettings.attempts;
    }

    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: rows,
      ),
    );
  }
}