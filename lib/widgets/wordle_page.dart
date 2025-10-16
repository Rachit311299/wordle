import 'package:flutter/material.dart';
import 'package:wordle/widgets/wordle_keyboard.dart';
import 'package:wordle/widgets/wordle_grid.dart';
import 'package:wordle/widgets/wordle_title_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordle/providers/history_provider.dart';

class WordlePage extends ConsumerWidget {
  const WordlePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    // mark a new game start on page build (lightweight)
    ref.read(historyProvider.notifier).markGameStart();
    
    final gameContent = SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.3),
              blurRadius: 50,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              WordleTitleBar(),
              WordleGrid(),
              WordleKeyboard(),
            ],
          ),
        ),
      ),
    );

    Widget content = gameContent;

    if (screenWidth > 1366) {
      content = Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1000,
          ),
          child: content,
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.9),
      body: content,
    );
  }
}