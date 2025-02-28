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

class _WordleRowState extends ConsumerState<WordleRow> with SingleTickerProviderStateMixin {
  late List<Color?> colors;
  late List<Widget> boxes;
  Brightness? _lastBrightness; // Track the last known brightness
  late AnimationController _waveController;
  late List<Animation<double>> _waveAnimations;
  bool _isCorrectWord = false;
  
  @override
  void initState() {
    super.initState();
    // Initialize animation controller
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _initializeRow();
    _setupWaveAnimations();
    
    // Check if we need to start animation immediately
    if (_isCorrectWord && ref.read(gameStateProvider).gameOver) {
      _waveController.repeat(reverse: false);
    }
  }

  void _setupWaveAnimations() {
    // Create staggered animations for each letter box
    _waveAnimations = List.generate(widget.wordsize, (index) {
      return TweenSequence<double>([
        // Initial position
        TweenSequenceItem(
          tween: ConstantTween<double>(0.0),
          weight: 1.0 + index * 10, // Staggered start time (larger for later letters)
        ),
        // Move up
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.0, end: -15.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 20.0,
        ),
        // Move down with bounce
        TweenSequenceItem(
          tween: Tween<double>(begin: -15.0, end: 0.0)
              .chain(CurveTween(curve: Curves.bounceOut)),
          weight: 20.0,
        ),
        // Hold position at the end
        TweenSequenceItem(
          tween: ConstantTween<double>(0.0),
          weight: 10.0,
        ),
      ]).animate(_waveController);
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentBrightness = Theme.of(context).brightness;
    // Initialize _lastBrightness if it's null
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
      
      // Check if this row has the correct word and needs animation
      if (widget.attempted && widget.word == widget.correctWord) {
        setState(() {
          _isCorrectWord = true;
        });
        // Trigger the wave animation
        _waveController.reset();
        _waveController.forward();
      }
    }
  }

  void _initializeRow() {
    if (widget.attempted) {
      colors = ref
          .read(gameStateProvider.notifier)
          .calculateRowColors(widget.word, widget.correctWord, context);
      
      // Check if this is the correct word
      _isCorrectWord = widget.word == widget.correctWord;
      
      // Check if game is over to trigger animation
      final gameState = ref.read(gameStateProvider);
      if (_isCorrectWord && gameState.gameOver && !_waveController.isAnimating) {
        _waveController.reset();
        _waveController.forward();
      }
    } else {
      colors = List.filled(widget.wordsize, null);
      _isCorrectWord = false;
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
    // Get the game state to check if game is over
    final gameState = ref.watch(gameStateProvider);
    final isGameOver = gameState.gameOver;
    
    // If game state changes to game over, and this is the correct row, start animation
    if (isGameOver && _isCorrectWord && !_waveController.isAnimating) {
      _waveController.forward();
    }
    
    return RepaintBoundary(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: _isCorrectWord && isGameOver
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              )
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.wordsize, (index) {
            return AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return Transform.translate(
                  offset: _isCorrectWord && isGameOver 
                      ? Offset(0, _waveAnimations[index].value)
                      : Offset.zero,
                  child: child,
                );
              },
              child: boxes[index],
            );
          }),
        ),
      ),
    );
  }
}