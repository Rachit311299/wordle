import 'package:flutter/material.dart';
import 'package:wordle/widgets/wordle_keyboard.dart';
import 'package:wordle/widgets/wordle_grid.dart';
import 'package:wordle/widgets/wordle_title_bar.dart';

class WordlePage extends StatelessWidget {
  const WordlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, bottom: 55.0), // Adds 40px space at the top
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
  }
}
