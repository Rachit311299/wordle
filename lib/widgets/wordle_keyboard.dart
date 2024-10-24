import 'package:flutter/material.dart';
import 'package:wordle/widgets/wordle_key_element.dart';

class WordleKeyboard extends StatelessWidget {
  const WordleKeyboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for(var i in "QWERTYUIOP".split("")) WordleKeyElement(letter: i)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for(var i in "ASDFGHJKL".split("")) WordleKeyElement(letter: i)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           for(var i in "_ZXCVBNM+".split("")) WordleKeyElement(letter: i)
          ],
        ),
      ],
    );
  }
}