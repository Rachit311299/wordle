import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordle/providers/game_state_provider.dart';

class WordleKeyElement extends ConsumerWidget {
  final String letter;
  final String state;

  const WordleKeyElement({
    super.key,
    required this.letter,
    this.state = 'default',
  });

  Color getBgColor(BuildContext context) {
    switch (state) {
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orangeAccent;
      case 'grey':
        // Darker grey for attempted but incorrect letters
        return Theme.of(context).brightness == Brightness.dark 
            ? Colors.grey[900]! 
            : Colors.grey[700]!;
      default:
        // Lighter grey for non-attempted letters
        return Theme.of(context).brightness == Brightness.dark 
            ? Colors.grey[800]! 
            : const Color.fromARGB(44, 73, 73, 73);
    }
}
  Color getTextColor(BuildContext context) {
    if (state == 'default') {
      return Theme.of(context).colorScheme.onSurface; // Use theme-aware text color
    }
    return Colors.white; // Keep white for colored states
  }

  Color getIconColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white70 // Slightly dimmed white for dark mode
        : Colors.black87; // Slightly transparent black for light mode
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget keyCap;
    double width = 50;

    if (letter == "_") {
      keyCap = Icon(
        Icons.keyboard_return,
        size: 18,
        color: state == 'default' 
            ? getIconColor(context) 
            : Colors.white,
      );
    } else if (letter == "+") {
      keyCap = Icon(
        Icons.backspace_outlined,
        size: 18,
        color: state == 'default' 
            ? getIconColor(context) 
            : Colors.white,
      );
    } else {
      width = 32;
      keyCap = Text(
        letter.toUpperCase(),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: getTextColor(context),
        ),
      );
    }

    return InkWell(
      onTap: () {
        ref.read(gameStateProvider.notifier).updateCurrentAttempt(context, letter);
      },
      child: Container(
        width: width,
        height: 48,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: getBgColor(context),
          // Add subtle shadow for better visibility in dark mode
          boxShadow: Theme.of(context).brightness == Brightness.dark
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  )
                ]
              : null,
        ),
        child: keyCap,
      ),
    );
  }
}