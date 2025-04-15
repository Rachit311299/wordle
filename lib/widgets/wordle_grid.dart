import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordle/providers/game_settings_provider.dart';
import 'package:wordle/providers/game_state_provider.dart';
import 'package:wordle/widgets/wordle_row.dart';

class WordleGrid extends StatelessWidget {
  const WordleGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          6, 
          (i) => WordleRow(rowIndex: i, key: ValueKey('row_$i')), 
        ),
      ),
    );
  }
}