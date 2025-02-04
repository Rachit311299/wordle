import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordle/widgets/wordle_key_element.dart';
import 'package:wordle/providers/game_state_provider.dart';

class WordleKeyboard extends ConsumerStatefulWidget {
  const WordleKeyboard({super.key});

  @override
  ConsumerState<WordleKeyboard> createState() => _WordleKeyboardState();
}

class _WordleKeyboardState extends ConsumerState<WordleKeyboard> {
  FocusNode? _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // Request focus when the widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode?.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final key = event.logicalKey;
      
      // Handle letter keys
      if (key.keyLabel.length == 1 && RegExp(r'[a-zA-Z]').hasMatch(key.keyLabel)) {
        ref.read(gameStateProvider.notifier).updateCurrentAttempt(context, key.keyLabel.toLowerCase());
      }
      // Handle enter key (maps to '_' in our virtual keyboard)
      else if (key == LogicalKeyboardKey.enter) {
        ref.read(gameStateProvider.notifier).updateCurrentAttempt(context, '_');
      }
      // Handle backspace key (maps to '+' in our virtual keyboard)
      else if (key == LogicalKeyboardKey.backspace || key == LogicalKeyboardKey.delete) {
        ref.read(gameStateProvider.notifier).updateCurrentAttempt(context, '+');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fetch the key states from the GameStateProvider
    final letterStates = ref.watch(gameStateProvider).keyStates;

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKey: (node, event) {
        _handleKeyEvent(event);
        return KeyEventResult.handled;
      },
      child: Column(
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
      ),
    );
  }
}
