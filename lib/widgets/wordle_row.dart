import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordle/providers/game_state_provider.dart';
import 'package:wordle/widgets/wordle_grid_element.dart';

class WordleRow extends ConsumerStatefulWidget {
  final int wordsize;
  final String word;
  final String correctWord;
  final bool attempted;
  final int rowIndex;

  const WordleRow({
    super.key,
    required this.wordsize,
    required this.word,
    required this.attempted,
    required this.correctWord,
    required this.rowIndex,
  });

  @override
  ConsumerState<WordleRow> createState() => _WordleRowState();
}

class _WordleRowState extends ConsumerState<WordleRow> {
  late List<Color?> colors;
  late List<Widget> boxes;
  Brightness? _lastBrightness; // Track the last known brightness

  @override
  void initState() {
    super.initState();
    _initializeRow();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentBrightness = Theme.of(context).brightness;
    // Initialize _lastBrightness if it’s null
    if (_lastBrightness == null) {
      _lastBrightness = currentBrightness;
    } else if (_lastBrightness != currentBrightness) {
      // Theme (brightness) has changed!
      _lastBrightness = currentBrightness;
      setState(() {
        _initializeRow();
      });
    }
  }

  @override
  void didUpdateWidget(covariant WordleRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.attempted != oldWidget.attempted ||
        widget.word != oldWidget.word ||
        widget.correctWord != oldWidget.correctWord) {
      _initializeRow();
    }
  }

  void _initializeRow() {
    if (widget.attempted) {

      colors = ref
          .read(gameStateProvider.notifier)
          .calculateRowColors(widget.word, widget.correctWord, context);
    } else {
      colors = List.filled(widget.wordsize, null);
    }

    boxes = List.generate(widget.wordsize, (j) {
      final letter = (widget.word.length > j) ? widget.word[j] : "";
      return WordleGridElement(
        key: ValueKey('${widget.rowIndex}_${j}_${widget.attempted}'),
        pos: j,
        letter: letter,
        attempted: widget.attempted,
        color: colors[j],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: boxes,
      ),
    );
  }
}
