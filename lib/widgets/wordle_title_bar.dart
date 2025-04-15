import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordle/providers/game_settings_provider.dart';
import 'package:wordle/providers/theme_provider.dart';
import 'package:wordle/theme/theme_data.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class WordSizeToggle extends ConsumerWidget {
  const WordSizeToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameSettings = ref.watch(GameSettingsProvider);
    final gameSettingsNotifier = ref.watch(GameSettingsProvider.notifier);

    void _updateWordSize() {
      var newWordSize = 5;
      if (gameSettings.wordsize == 4) newWordSize = 5;
      if (gameSettings.wordsize == 5) newWordSize = 6;
      if (gameSettings.wordsize == 6) newWordSize = 4;
      gameSettingsNotifier.UpdateWordsize(newWordSize);
    }

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
        child: Text(
          gameSettings.wordsize.toString(),
          style: TextStyle(
            color:
                AppTheme.gameColors.getTextColor(Theme.of(context).brightness),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class WordAttemptToggle extends ConsumerWidget {
  const WordAttemptToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameSettings = ref.watch(GameSettingsProvider);
    final gameSettingsNotifier = ref.watch(GameSettingsProvider.notifier);

    void _updateAttempts() {
      var newAttempts = 6;
      if (gameSettings.attempts == 4) newAttempts = 5;
      if (gameSettings.attempts == 5) newAttempts = 6;
      if (gameSettings.attempts == 6) newAttempts = 4;
      gameSettingsNotifier.UpdateAttempts(newAttempts);
    }

    String difftext;
    switch (gameSettings.attempts) {
      case 4:
        difftext = "HIGH";
        break;
      case 5:
        difftext = "MED";
        break;
      case 6:
      default:
        difftext = "LOW";
        break;
    }

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
        child: Text(
          difftext,
          style: TextStyle(
            color:
                AppTheme.gameColors.getTextColor(Theme.of(context).brightness),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
