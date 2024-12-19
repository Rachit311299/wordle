import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:wordle/providers/game_state_provider.dart';

class WordleKeyElement extends ConsumerStatefulWidget {
  final String letter;
  final String state;

  const WordleKeyElement({
    super.key,
    required this.letter,
    this.state = 'default',
  });

  @override
  ConsumerState<WordleKeyElement> createState() => _WordleKeyElementState();
}

class _WordleKeyElementState extends ConsumerState<WordleKeyElement> {
  bool _isPressed = false;

  Color getBgColor(BuildContext context) {
    switch (widget.state) {
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orangeAccent;
      case 'grey':
        return Theme.of(context).brightness == Brightness.dark 
            ? Colors.grey[900]! 
            : Colors.grey[700]!;
      default:
        return Theme.of(context).brightness == Brightness.dark 
            ? Colors.grey[800]! 
            : const Color.fromARGB(44, 73, 73, 73);
    }
  }

  Color getTextColor(BuildContext context) {
    if (widget.state == 'default') {
      return Theme.of(context).colorScheme.onSurface; 
    }
    return Colors.white; 
  }

  Color getIconColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white70 
        : Colors.black87; 
  }

  @override
  Widget build(BuildContext context) {
    Widget keyCap;
    double width = 48;

    if (widget.letter == "_") {
      keyCap = Icon(
        Icons.keyboard_return,
        size: 18,
        color: widget.state == 'default' 
            ? getIconColor(context) 
            : Colors.white,
      );
    } else if (widget.letter == "+") {
      keyCap = Icon(
        Icons.backspace_outlined,
        size: 18,
        color: widget.state == 'default' 
            ? getIconColor(context) 
            : Colors.white,
      );
    } else {
      width = 30;
      keyCap = Text(
        widget.letter.toUpperCase(),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: getTextColor(context),
        ),
      );
    }

    return Listener(
      onPointerDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onPointerUp: (_) {
        setState(() {
          _isPressed = false;
        });
      },
      onPointerCancel: (_) {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.85 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            ref.read(gameStateProvider.notifier).updateCurrentAttempt(context, widget.letter);
          },
          child: Container(
            width: width,
            height: 48,
            alignment: Alignment.center,
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: getBgColor(context),
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
        ),
      ),
    );
  }
}
