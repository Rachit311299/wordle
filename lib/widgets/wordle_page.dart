import 'package:flutter/material.dart';
import 'package:wordle/widgets/wordle_keyboard.dart';
import 'package:wordle/widgets/wordle_grid.dart';
import 'package:wordle/widgets/wordle_title_bar.dart';

class WordlePage extends StatelessWidget {
  const WordlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300], // Set background outside the container to grey
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500, // Restrict to mobile width
          ),
          child: Container(
            color: Colors.white, // Color inside the container (Wordle app area)
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 55.0),
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
        ),
      ),
    );
  }
}
