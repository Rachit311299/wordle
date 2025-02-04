import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordle/providers/game_state_provider.dart';
import 'package:wordle/widgets/wordle_key_element.dart';

class WordleKeyboard extends ConsumerStatefulWidget {
  const WordleKeyboard({Key? key}) : super(key: key);

  @override
  ConsumerState<WordleKeyboard> createState() => _WordleKeyboardState();
}

class _WordleKeyboardState extends ConsumerState<WordleKeyboard> {
  FocusNode? _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
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
      if (key.keyLabel.length == 1 && RegExp(r'[a-zA-Z]').hasMatch(key.keyLabel)) {
        ref
            .read(gameStateProvider.notifier)
            .updateCurrentAttempt(context, key.keyLabel.toLowerCase());
      } else if (key == LogicalKeyboardKey.enter) {
        ref.read(gameStateProvider.notifier).updateCurrentAttempt(context, '_');
      } else if (key == LogicalKeyboardKey.backspace ||
          key == LogicalKeyboardKey.delete) {
        ref.read(gameStateProvider.notifier).updateCurrentAttempt(context, '+');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              for (var letter in "qwertyuiop".split(""))
                WordleKeyElement(letter: letter),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var letter in "asdfghjkl".split(""))
                WordleKeyElement(letter: letter),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var letter in "_zxcvbnm+".split(""))
                WordleKeyElement(letter: letter),
            ],
          ),
        ],
      ),
    );
  }
}
