import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordle/widgets/wordle_key_element.dart';
import 'package:wordle/providers/game_state_provider.dart';

class WordleKeyboard extends ConsumerWidget {
  const WordleKeyboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch the key states from the GameStateProvider
    final letterStates = ref.watch(gameStateProvider).keyStates;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i in "qwertyuiop".split(""))
              WordleKeyElement(
                letter: i,
                state: letterStates[i] ?? 'default', 
              ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i in "asdfghjkl".split(""))
              WordleKeyElement(
                letter: i,
                state: letterStates[i] ?? 'default', 
              ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i in "_zxcvbnm+".split(""))
              WordleKeyElement(
                letter: i,
                state: letterStates[i] ?? 'default', 
              ),
          ],
        ),
      ],
    );
  }
}
