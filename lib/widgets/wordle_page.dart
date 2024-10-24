import 'package:flutter/material.dart';
import 'package:wordle/widgets/wordle_keyboard.dart';
import 'package:wordle/widgets/wordle_grid.dart';
import 'package:wordle/widgets/wordle_title_bar.dart';

class WordlePage extends StatelessWidget {
  const WordlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child: const Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment:MainAxisAlignment.spaceBetween ,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [WordleTitleBar(),WordleGrid(),WordleKeyboard(),],
        ),
      )
    );
  }
}