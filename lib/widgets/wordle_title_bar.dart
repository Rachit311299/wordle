import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordle/providers/game_settings_provider.dart';
import 'package:wordle/providers/theme_provider.dart';
import 'package:wordle/theme/theme_data.dart';
import 'package:wordle/providers/game_state_provider.dart';

class WordleTitleBar extends ConsumerWidget {
  const WordleTitleBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              // Reset the game with the current word size
              ref.read(gameStateProvider.notifier).resetGame();
            },
            child: Text(
              "wordscape",
              style: TextStyle(
                  fontSize: 26,
                  fontFamily: "Cocogoose",
                  fontStyle: FontStyle.italic,
                  color: AppTheme.gameColors
                      .getTextColor(Theme.of(context).brightness)),
            ),
          ),
          Row(
            children: const [
              WordSizeToggle(),
              SizedBox(width: 5),
              WordAttemptToggle(),
              SizedBox(width: 5),
              ThemeToggleButton(),
            ],
          ),
        ],
      ),
    );
  }
}

class WordSizeToggle extends ConsumerStatefulWidget {
  const WordSizeToggle({Key? key}) : super(key: key);

  @override
  ConsumerState<WordSizeToggle> createState() => _WordSizeToggleState();
}

class _WordSizeToggleState extends ConsumerState<WordSizeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _positionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, -1.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateWordSize() {
    final gameSettings = ref.read(GameSettingsProvider);
    final gameSettingsNotifier = ref.read(GameSettingsProvider.notifier);

    setState(() {});

    var newWordSize = 5;
    if (gameSettings.wordsize == 4) newWordSize = 5;
    if (gameSettings.wordsize == 5) newWordSize = 6;
    if (gameSettings.wordsize == 6) newWordSize = 4;

    _animationController.forward().then((_) {
      gameSettingsNotifier.UpdateWordsize(newWordSize);
      _animationController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameSettings = ref.watch(GameSettingsProvider);
    final currentWordSize = gameSettings.wordsize;

    return SizedBox(
      width: 50,
      height: 30,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface,
          side: BorderSide(color: Theme.of(context).colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: _updateWordSize,
        child: ClipRect(
          child: Stack(
            children: [
              // Current number - slides up
              SlideTransition(
                position: _positionAnimation,
                child: Center(
                  child: Text(
                    currentWordSize.toString(),
                    style: TextStyle(
                      color: AppTheme.gameColors
                          .getTextColor(Theme.of(context).brightness),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // New number - slides in from bottom
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: const Offset(0.0, 0.0),
                ).animate(CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.easeInOut,
                )),
                child: Center(
                  child: Text(
                    _getNextWordSize(currentWordSize).toString(),
                    style: TextStyle(
                      color: AppTheme.gameColors
                          .getTextColor(Theme.of(context).brightness),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getNextWordSize(int currentSize) {
    if (currentSize == 4) return 5;
    if (currentSize == 5) return 6;
    if (currentSize == 6) return 4;
    return 5; // Default
  }
}

class WordAttemptToggle extends ConsumerStatefulWidget {
  const WordAttemptToggle({Key? key}) : super(key: key);

  @override
  ConsumerState<WordAttemptToggle> createState() => _WordAttemptToggleState();
}

class _WordAttemptToggleState extends ConsumerState<WordAttemptToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _positionAnimation;
// Initial value

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _positionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, -1.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateAttempts() {
    final gameSettings = ref.read(GameSettingsProvider);
    final gameSettingsNotifier = ref.read(GameSettingsProvider.notifier);

    setState(() {});

    var newAttempts = 6;
    if (gameSettings.attempts == 4) newAttempts = 5;
    if (gameSettings.attempts == 5) newAttempts = 6;
    if (gameSettings.attempts == 6) newAttempts = 4;

    // Start the animation
    _animationController.forward().then((_) {
      // Update the actual value
      gameSettingsNotifier.UpdateAttempts(newAttempts);

      // Reset animation for next use
      _animationController.reset();
    });
  }

  String _getAttemptText(int attempts) {
    switch (attempts) {
      case 4:
        return "HIGH";
      case 5:
        return "MED";
      case 6:
      default:
        return "LOW";
    }
  }

  String _getNextAttemptText(int currentAttempts) {
    if (currentAttempts == 4) return "MED";
    if (currentAttempts == 5) return "LOW";
    if (currentAttempts == 6) return "HIGH";
    return "LOW"; // Default
  }

  @override
  Widget build(BuildContext context) {
    final gameSettings = ref.watch(GameSettingsProvider);
    final currentAttempts = gameSettings.attempts;
    final currentText = _getAttemptText(currentAttempts);

    return SizedBox(
      width: 50,
      height: 30,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface,
          side: BorderSide(color: Theme.of(context).colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: _updateAttempts,
        child: ClipRect(
          child: Stack(
            children: [
              // Current text - slides up
              SlideTransition(
                position: _positionAnimation,
                child: Center(
                  child: Text(
                    currentText,
                    style: TextStyle(
                      color: AppTheme.gameColors
                          .getTextColor(Theme.of(context).brightness),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),

              // New text - slides in from bottom
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: const Offset(0.0, 0.0),
                ).animate(CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.easeInOut,
                )),
                child: Center(
                  child: Text(
                    _getNextAttemptText(currentAttempts),
                    style: TextStyle(
                      color: AppTheme.gameColors
                          .getTextColor(Theme.of(context).brightness),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return SizedBox(
      width: 50,
      height: 30,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface,
          side: BorderSide(color: Theme.of(context).colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: () {
          ref.read(themeProvider.notifier).toggleTheme();
        },
        child: Icon(
          isDarkMode ? Icons.light_mode : Icons.dark_mode,
          size: 20,
          color: AppTheme.gameColors.getTextColor(Theme.of(context).brightness),
        ),
      ),
    );
  }
}
