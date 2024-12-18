import 'package:flutter/material.dart';
import 'package:wordle/widgets/wordle_keyboard.dart';
import 'package:wordle/widgets/wordle_grid.dart';
import 'package:wordle/widgets/wordle_title_bar.dart';

class WordlePage extends StatelessWidget {
  const WordlePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    final screenWidth = MediaQuery.of(context).size.width;
    
    // The content of our app
    Widget content = Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
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
    );

    // If screen width is greater than 500, wrap in ConstrainedBox
    if (screenWidth > 500) {
      content = Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
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