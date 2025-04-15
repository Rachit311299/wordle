import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordle/providers/game_state_provider.dart';
import 'package:wordle/providers/game_settings_provider.dart';
import 'package:wordle/widgets/wordle_grid_element.dart';

class WordleRow extends ConsumerStatefulWidget {
  final int rowIndex;
  const WordleRow({super.key, required this.rowIndex});

  @override
  ConsumerState<WordleRow> createState() => _WordleRowState();
}

class _WordleRowState extends ConsumerState<WordleRow> with SingleTickerProviderStateMixin {
  late int wordsize;
  late String word;
  late String correctWord;
  late bool attempted;

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
    // We'll set up state in build()
  }

  void _setupWaveAnimations() {
    // Create staggered animations for each letter box
    _waveAnimations = List.generate(wordsize, (index) {
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


  void _initializeRow() {
    if (attempted) {
      colors = ref
          .read(gameStateProvider.notifier)
          .calculateRowColors(word, correctWord, context);
      
      // Check if this is the correct word
      _isCorrectWord = word == correctWord;
      
      // Check if game is over to trigger animation
      final gameState = ref.read(gameStateProvider);
      if (_isCorrectWord && gameState.gameOver && !_waveController.isAnimating) {
        _waveController.reset();
        _waveController.forward();
      }
    } else {
      colors = List.filled(wordsize, null);
      _isCorrectWord = false;
    }

    boxes = List.generate(wordsize, (j) {
      final letter = (word.length > j) ? word[j] : "";
      return WordleGridElement(
        key: ValueKey('${widget.rowIndex}_${j}_$attempted'),
        pos: j,
        letter: letter,
        attempted: attempted,
        color: colors[j],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Read relevant state from providers using .select
    wordsize = ref.watch(GameSettingsProvider.select((s) => s.wordsize));
    word = ref.watch(gameStateProvider.select((s) => s.attempts.length > widget.rowIndex ? s.attempts[widget.rowIndex] : ""));
    correctWord = ref.watch(gameStateProvider.select((s) => s.correctWord));
    attempted = ref.watch(gameStateProvider.select((s) => s.attempted > widget.rowIndex));

    // Setup wave animations and row state
    _setupWaveAnimations();
    _initializeRow();

    final isGameOver = ref.watch(gameStateProvider.select((s) => s.gameOver));
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
          children: List.generate(wordsize, (index) {
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