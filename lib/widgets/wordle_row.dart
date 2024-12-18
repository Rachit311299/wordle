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
    final List<Color?> colors = attempted ? _getColorsForRow(context) : List.filled(wordsize, null);

    final List<WordleGridElement> boxes = List.generate(wordsize, (j) {
      final letter = (word.length > j) ? word[j] : "";
      return WordleGridElement(
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

  List<Color?> _getColorsForRow(BuildContext context) {
    // Initialize with theme-aware grey color
    final Color defaultGrey = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[700]! // Darker grey for dark mode
        : const Color.fromARGB(255, 100, 100, 100); // Original grey for light mode

    final List<Color?> colors = List.filled(wordsize, defaultGrey);
    final Map<String, int> remainingCounts = {};

    // Count occurrences of each letter in the correct word
    for (var char in correctWord.split('')) {
      remainingCounts[char] = (remainingCounts[char] ?? 0) + 1;
    }

    // Define semantic colors that work well in both themes
    final correctColor = Colors.green[600]!; // Slightly darker green for better contrast
    final misplacedColor = Colors.orange[400]!; // Adjusted orange for better visibility

    // Mark green matches and reduce counts
    for (int i = 0; i < word.length; i++) {
      if (word[i] == correctWord[i]) {
        colors[i] = correctColor;
        remainingCounts[word[i]] = remainingCounts[word[i]]! - 1;
      }
    }

    // Mark orange matches for misplaced letters
    for (int i = 0; i < word.length; i++) {
      if (colors[i] == defaultGrey && // Not already marked green
          remainingCounts.containsKey(word[i]) &&
          remainingCounts[word[i]]! > 0) {
        colors[i] = misplacedColor;
        remainingCounts[word[i]] = remainingCounts[word[i]]! - 1;
      }
    }

    return colors;
  }
}