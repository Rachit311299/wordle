import 'package:flutter/material.dart';
import 'package:wordle/widgets/wordle_grid_element.dart';

class WordleRow extends StatelessWidget {
  final int wordsize;
  final String word;
  final String correctWord;
  final bool attempted;

  const WordleRow({
    super.key,
    required this.wordsize,
    required this.word,
    required this.attempted,
    required this.correctWord,
  });

  @override
  Widget build(BuildContext context) {
    // Only calculate colors if the word has been submitted
    final List<Color?> colors = attempted ? _getColorsForRow() : List.filled(wordsize, null);

    final List<WordleGridElement> boxes = List.generate(wordsize, (j) {
      final letter = (word.length > j) ? word[j] : "";
      return WordleGridElement(
        pos: j,
        letter: letter,
        attempted: attempted,
        color: colors[j], // Pass the calculated color
      );
    });

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: boxes,
    );
  }

 List<Color?> _getColorsForRow() {
  final List<Color?> colors = List.filled(wordsize, Colors.grey); // Default to grey
  final Map<String, int> remainingCounts = {};

  // Step 1: Count occurrences of each letter in the correct word
  for (var char in correctWord.split('')) {
    remainingCounts[char] = (remainingCounts[char] ?? 0) + 1;
  }

  // Step 2: Mark green matches and reduce counts
  for (int i = 0; i < word.length; i++) {
    if (word[i] == correctWord[i]) {
      colors[i] = Colors.green;
      remainingCounts[word[i]] = remainingCounts[word[i]]! - 1;
    }
  }

  // Step 3: Mark orange matches for misplaced letters
  for (int i = 0; i < word.length; i++) {
    if (colors[i] == Colors.grey && // Not already marked green
        remainingCounts.containsKey(word[i]) &&
        remainingCounts[word[i]]! > 0) {
      colors[i] = Colors.orangeAccent;
      remainingCounts[word[i]] = remainingCounts[word[i]]! - 1; // Reduce count
    }
  }

  return colors;
}



}
