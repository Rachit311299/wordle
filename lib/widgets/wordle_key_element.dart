import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordle/providers/game_state_provider.dart';

class WordleKeyElement extends ConsumerWidget {
  final String letter;
  final String state; // New parameter for the key state

  const WordleKeyElement({
    super.key,
    required this.letter,
    this.state = 'default', // Default value
  });

  Color getBgColor() {
    switch (state) {
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orangeAccent;
      case 'grey':
        return Colors.grey;
      default:
        return const Color.fromARGB(44, 44, 44, 44); // Default background color
    }
  }

  Color getTextColor() {
    return state == 'default' ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget keyCap;
    double width = 50;

    if (letter == "_") {
      keyCap = const Icon(Icons.keyboard_return, size: 18);
    } else if (letter == "+") {
      keyCap = const Icon(Icons.backspace_outlined, size: 18);
    } else {
      width = 32;
      keyCap = Text(
        letter.toUpperCase(),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: getTextColor(), // Use the text color based on state
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
          color: getBgColor(), // Use the background color based on state
        ),
        child: keyCap,
      ),
    );
  }
}
